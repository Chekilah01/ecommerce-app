import 'dart:io';

import 'package:final_project/features/product/domain/entities/product_entity.dart';
import 'package:final_project/features/product/domain/entities/product_image_entity.dart';
import 'package:final_project/features/product/presentation/bloc/product_bloc.dart';
import 'package:final_project/features/product/presentation/bloc/product_event.dart';
import 'package:final_project/features/product/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({required this.product, super.key});

  final ProductEntity product;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _deliveryFeeController;
  late final TextEditingController _stockController;

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _newMainImage;

  late List<ProductImage> _keptAdditionalImages;
  final List<XFile> _newAdditionalImages = [];

  late String _categoryId;
  late bool _isFeatured;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameController = TextEditingController(text: product.name);

    _descriptionController = TextEditingController(
      text: product.description,
    );

    _priceController = TextEditingController(
      text: product.price.toString(),
    );

    _deliveryFeeController = TextEditingController(
      text: product.deliveryFee.toString(),
    );

    _stockController = TextEditingController(
      text: product.stock.toString(),
    );

    _categoryId = product.categoryId;
    _isFeatured = product.isFeatured;

    _keptAdditionalImages = List<ProductImage>.from(
      product.additionalImages,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _deliveryFeeController.dispose();
    _stockController.dispose();

    super.dispose();
  }

  Future<void> _pickNewMainImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _newMainImage = image;
    });
  }

  Future<void> _pickNewAdditionalImage() async {
    final totalImages =
        _keptAdditionalImages.length +
        _newAdditionalImages.length;

    if (totalImages >= 5) {
      _showMessage(
        'You can add a maximum of 5 additional images.',
      );
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _newAdditionalImages.add(image);
    });
  }

  void _removeExistingAdditionalImage(int index) {
    setState(() {
      _keptAdditionalImages.removeAt(index);
    });
  }

  void _removeNewAdditionalImage(int index) {
    setState(() {
      _newAdditionalImages.removeAt(index);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      deliveryFee: double.parse(
        _deliveryFeeController.text.trim(),
      ),
      stock: int.parse(_stockController.text.trim()),
      categoryId: _categoryId,
      isFeatured: _isFeatured,
    );

    context.read<ProductBloc>().add(
      UpdateProduct(
        product: updatedProduct,
        newMainImage: _newMainImage,
        keptAdditionalImages: List.unmodifiable(
          _keptAdditionalImages,
        ),
        newAdditionalImages: List.unmodifiable(
          _newAdditionalImages,
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  String? _positiveNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    final number = double.tryParse(value.trim());

    if (number == null) {
      return 'Enter a valid number.';
    }

    if (number < 0) {
      return 'Cannot be negative.';
    }

    return null;
  }

  String? _stockValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    final number = int.tryParse(value.trim());

    if (number == null) {
      return 'Enter a whole number.';
    }

    if (number < 0) {
      return 'Cannot be negative.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.status == ProductStatus.actionSuccess) {
          _showMessage(
            state.successMessage ??
                'Product updated successfully.',
          );

          context.pop();
        }

        if (state.status == ProductStatus.failure) {
          _showMessage(
            state.errorMessage ??
                'Something went wrong.',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Text(
                  'Main Product Image',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 8),

                _buildMainImageSection(),

                const SizedBox(height: 24),

                Text(
                  'Additional Images',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 8),

                _buildAdditionalImagesSection(),

                const SizedBox(height: 24),

                _buildProductDetailsSection(),

                const SizedBox(height: 16),

                _buildPricingAndStockSection(),

                const SizedBox(height: 16),

                _buildCategorySection(),

                const SizedBox(height: 16),

                SwitchListTile(
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.green,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Featured product'),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    final isLoading =
                        state.status == ProductStatus.loading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor:
                              const Color.fromARGB(
                            255,
                            33,
                            24,
                            196,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                            isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainImageSection() {
    final imageWidget = _newMainImage != null
        ? Image.file(
            File(_newMainImage!.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.network(
            widget.product.mainImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder:
                (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported_outlined,
                size: 60,
              );
            },
          );

    return GestureDetector(
      onTap: _pickNewMainImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageWidget,

              Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to change image',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalImagesSection() {
    final totalImages =
        _keptAdditionalImages.length +
        _newAdditionalImages.length;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        // Existing Cloudinary images.
        if (index < _keptAdditionalImages.length) {
          final image =
              _keptAdditionalImages[index];

          return _buildExistingImageSlot(
            image.url,
            () => _removeExistingAdditionalImage(index),
          );
        }

        // Newly selected local images.
        final newImageIndex =
            index - _keptAdditionalImages.length;

        if (newImageIndex <
            _newAdditionalImages.length) {
          final image =
              _newAdditionalImages[newImageIndex];

          return _buildNewImageSlot(
            image,
            () => _removeNewAdditionalImage(
              newImageIndex,
            ),
          );
        }

        // Empty slot.
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index == 4 ? 0 : 8,
            ),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(12),
              onTap: totalImages >= 5
                  ? null
                  : _pickNewAdditionalImage,
              child: Icon(
                Icons.add,
                color: Colors.amber.shade700,
                size: 20,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildExistingImageSlot(
    String imageUrl,
    VoidCallback onRemove,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          right: 8,
        ),
        height: 60,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons
                            .image_not_supported_outlined,
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewImageSlot(
    XFile image,
    VoidCallback onRemove,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          right: 8,
        ),
        height: 60,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            const Text(
              'Product Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(Icons.star_outline),
                labelText: 'Product name',
                border: OutlineInputBorder(),
              ),
              validator: _requiredValidator,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              maxLines: null,
              keyboardType:
                  TextInputType.multiline,
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(Icons.description),
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: _requiredValidator,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingAndStockSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Pricing & Stock',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      prefixIcon: Icon(
                        Icons
                            .attach_money_outlined,
                      ),
                      labelText: 'Price (DA)',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        _positiveNumberValidator,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller:
                        _deliveryFeeController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    decoration:
                        const InputDecoration(
                      prefixIcon: Icon(
                        Icons.local_shipping,
                      ),
                      labelText:
                          'Delivery fee (DA)',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        _positiveNumberValidator,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
                prefixIcon: Icon(
                  Icons.inventory,
                ),
                border: OutlineInputBorder(),
              ),
              validator: _stockValidator,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: DropdownButtonFormField<String>(
        initialValue: _categoryId,
        decoration: const InputDecoration(
          prefixIcon: Icon(Iconsax.category),
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(
            value: 'electronics',
            child: Text('Electronics'),
          ),
          DropdownMenuItem(
            value: 'clothing',
            child: Text('Clothing'),
          ),
          DropdownMenuItem(
            value: 'shoes',
            child: Text('Shoes'),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            _categoryId = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }

          return null;
        },
      ),
    );
  }
}