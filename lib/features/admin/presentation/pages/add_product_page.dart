import 'dart:io';

import 'package:final_project/features/product/presentation/bloc/product_bloc.dart';
import 'package:final_project/features/product/presentation/bloc/product_event.dart';
import 'package:final_project/features/product/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _deliveryFeeController = TextEditingController();
  final _stockController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _mainImage;
  final List<XFile> _additionalImages = [];

  String? _categoryId;
  bool _isFeatured = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _deliveryFeeController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickMainImage(ImageSource imageSource) async {
    final image = await _imagePicker.pickImage(source: imageSource);

    if (image == null) return;

    setState(() {
      _mainImage = image;
    });
  }

  Future<void> _pickSingleAdditionalImage(int index) async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      if (index < _additionalImages.length) {
        _additionalImages[index] = image;
      } else {
        _additionalImages.add(image);
      }
    });
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      _additionalImages.removeAt(index);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_mainImage == null) {
      _showMessage('Please select a main image.');
      return;
    }

    context.read<ProductBloc>().add(
      CreateProduct(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        deliveryFee: double.parse(_deliveryFeeController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        categoryId: _categoryId!,
        mainImage: _mainImage!,
        additionalImages: List.unmodifiable(_additionalImages),
        isFeatured: _isFeatured,
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
          _showMessage(state.successMessage ?? 'Product created successfully.');

          context.pop();
        }

        if (state.status == ProductStatus.failure) {
          _showMessage(state.errorMessage ?? 'Something went wrong.');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Product'), centerTitle: true),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Main Product Image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                _buildMainImageSection(),

                const SizedBox(height: 24),

                Text(
                  'Additional Images',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                _buildAdditionalImagesSection(),

                const SizedBox(height: 24),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Product Details',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.star_outline),
                            labelText: 'Product name',
                            border: OutlineInputBorder(),
                          ),
                          validator: _requiredValidator,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          validator: _requiredValidator,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Pricing & Stock',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.attach_money_outlined),
                                  labelText: 'Price (DA)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _positiveNumberValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _deliveryFeeController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.local_shipping),
                                  labelText: 'Delivery fee (DA)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: _positiveNumberValidator,
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
                            prefixIcon: Icon(Icons.inventory),
                            border: OutlineInputBorder(),
                          ),
                          validator: _stockValidator,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                      DropdownMenuItem(value: 'shoes', child: Text('Shoes')),
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
                ),

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
                    final isLoading = state.status == ProductStatus.loading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: const Color.fromARGB(
                            255,
                            33,
                            24,
                            196,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Product'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () async {
            final imageSource = await showModalBottomSheet<ImageSource>(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Select Image Source',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Gallery'),
                        onTap: () {
                          Navigator.of(context).pop(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Camera'),
                        onTap: () {
                          Navigator.of(context).pop(ImageSource.camera);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
            if (imageSource == null) return;
            await _pickMainImage(imageSource);
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _mainImage == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 60),
                      SizedBox(height: 8),
                      Text('Tap to select an image'),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_mainImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalImagesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final hasImage = index < _additionalImages.length;
        final image = hasImage ? _additionalImages[index] : null;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _pickSingleAdditionalImage(index),
              child: Stack(
                children: [
                  Center(
                    child: hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Icon(
                            Icons.add,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                  ),
                  if (hasImage)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => _removeAdditionalImage(index),
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
          ),
        );
      }),
    );
  }
}
