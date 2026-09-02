import 'package:final_project/features/product/domain/entities/product_entity.dart';
import 'package:final_project/features/product/presentation/bloc/product_bloc.dart';
import 'package:final_project/features/product/presentation/bloc/product_event.dart';
import 'package:final_project/features/product/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CustomerSearchPage extends StatefulWidget {
  const CustomerSearchPage({super.key});

  @override
  State<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearchFocused = false;

  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = const [
    {'id': 'all', 'name': 'All'},
    {'id': 'electronics', 'name': 'Electronics'},
    {'id': 'clothing', 'name': 'Clothing'},
    {'id': 'shoes', 'name': 'Shoes'},
  ];

  @override
  void initState() {
    super.initState();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    context.read<ProductBloc>().add(const LoadProducts());

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ProductBloc>().add(
      SearchProducts(
        query: _searchController.text,
        categoryId: _selectedCategory,
      ),
    );
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });

    context.read<ProductBloc>().add(
      SearchProducts(query: _searchController.text, categoryId: categoryId),
    );
  }

  void _openProductDetails(ProductEntity product) {
    context.pushNamed('customer-product-details', extra: product);
  }

  String _formatCategory(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'electronics':
        return 'Electronics';

      case 'clothing':
        return 'Clothing';

      case 'shoes':
        return 'Shoes';

      default:
        return categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.status == ProductStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: PopScope(
        canPop: !_isSearchFocused,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          if (_isSearchFocused) {
            _searchFocusNode.unfocus();
          }
        },
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(title: const Text('Search'), centerTitle: true),

          body: Column(
            children: [
              _buildSearchBar(),

              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Category filter',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              _buildCategoryFilter(),

              const SizedBox(height: 8),

              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state.status == ProductStatus.loading &&
                        state.products.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == ProductStatus.failure &&
                        state.products.isEmpty) {
                      return _buildErrorState(
                        state.errorMessage ?? 'Something went wrong.',
                      );
                    }

                    if (state.products.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        if (_selectedCategory == 'all') {
                          context.read<ProductBloc>().add(const LoadProducts());
                        } else {
                          context.read<ProductBloc>().add(
                            SearchProducts(
                              categoryId: _selectedCategory,
                              query: _searchController.text,
                            ),
                          );
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildProductCard(product),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];

          final id = category['id']!;
          final name = category['name']!;

          final selected = _selectedCategory == id;

          return ChoiceChip(
            label: Text(name),
            selected: selected,
            onSelected: (_) {
              _selectCategory(id);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _openProductDetails(product);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${product.price.toStringAsFixed(2)} DA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatCategory(product.categoryId),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

  Widget _buildProductImage(ProductEntity product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        product.mainImageUrl,
        width: 90,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 90,
            height: 110,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image_not_supported_outlined),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            period: const Duration(milliseconds: 1500),
            child: Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilters =
        _searchController.text.trim().isNotEmpty || _selectedCategory != 'all';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters
                  ? Icons.search_off_outlined
                  : Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),

            const SizedBox(height: 16),

            Text(
              hasFilters ? 'No products found.' : 'No products available.',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            if (hasFilters)
              const Text(
                'Try another search or category.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(const LoadProducts());
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 16),

                    Text(message, textAlign: TextAlign.center),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(const LoadProducts());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
