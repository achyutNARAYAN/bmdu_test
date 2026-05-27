import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/error_view.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final TextEditingController _searchController;
  bool _requestedProducts = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requestedProducts) {
      _requestedProducts = true;
      context.read<ProductProvider>().loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<ProductProvider>().refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, AuthProvider>(
      builder: (context, provider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shop Products'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: () async {
                  await authProvider.logout();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: provider.searchProducts,
                  ),
                  const SizedBox(height: 16),
                  if (provider.isLoading)
                    Expanded(child: _buildLoadingPlaceholder())
                  else if (provider.errorMessage != null)
                    Expanded(
                      child: ErrorView(
                        message: provider.errorMessage!,
                        onRetry: provider.loadProducts,
                      ),
                    )
                  else if (!provider.hasResults)
                    const Expanded(
                      child: Center(child: Text('No products found.')),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount:
                            provider.products.length +
                            (provider.recentProducts.isNotEmpty ? 1 : 0),
                        separatorBuilder: (_, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          if (index == 0 &&
                              provider.recentProducts.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recently viewed',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 120,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: provider.recentProducts.length,
                                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                                    itemBuilder: (context, recentIndex) {
                                      final recent =
                                          provider.recentProducts[recentIndex];
                                      return GestureDetector(
                                        onTap: () =>
                                            _openDetail(context, recent),
                                        child: SizedBox(
                                          width: 170,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  child: Image.network(
                                                    recent.image,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                recent.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }
                          final product =
                              provider.products[provider
                                      .recentProducts
                                      .isNotEmpty
                                  ? index - 1
                                  : index];
                          return ProductCard(
                            product: product,
                            onTap: () => _openDetail(context, product),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingPlaceholder() {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: 106,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  void _openDetail(BuildContext context, Product product) {
    context.read<ProductProvider>().markProductViewed(product);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }
}
