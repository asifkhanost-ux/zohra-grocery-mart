import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/banner_widget.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (_searchController.text.isEmpty && selectedCategory.isEmpty) {
      filteredProducts = productProvider.products;
    } else {
      var filtered = _searchController.text.isNotEmpty
          ? productProvider.searchProducts(_searchController.text)
          : productProvider.products;
      if (selectedCategory.isNotEmpty) {
        filtered = filtered.where((p) => p.category == selectedCategory).toList();
      }
      filteredProducts = filtered;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBarWidget(
        title: AppStrings.appName,
        cartCount: context.watch<CartProvider>().cartCount,
        onCartTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            BannerWidget(
              title: AppStrings.freshGrocery,
              subtitle: AppStrings.fastDelivery,
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppStrings.searchGrocery,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                          },
                          child: const Icon(Icons.close, color: AppColors.primaryGreen),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 100,
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  final categories = productProvider.categories;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final emoji = _getCategoryEmoji(category);
                      return CategoryCard(
                        emoji: emoji,
                        title: category,
                        onTap: () {
                          setState(() {
                            selectedCategory = selectedCategory == category ? '' : category;
                            _filterProducts();
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.popularProducts,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  final displayProducts = filteredProducts.isEmpty
                      ? (selectedCategory.isEmpty && _searchController.text.isEmpty
                          ? productProvider.products
                          : [])
                      : filteredProducts;

                  if (displayProducts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Column(
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('No products found', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  selectedCategory = '';
                                  _filterProducts();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                              ),
                              child: const Text(
                                AppStrings.continueShop,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () {
                          context.read<CartProvider>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onWishlist: () {
                          context.read<ProductProvider>().toggleWishlist(product.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    final emojiMap = {
      'Fruits': '🍎',
      'Vegetables': '🥦',
      'Dairy': '🥛',
      'Bakery': '🍞',
      'Drinks': '🥤',
      'Snacks': '🥨',
    };
    return emojiMap[category] ?? '🛒';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
