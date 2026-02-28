import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/presentation/providers/auth_provider.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/data/models/canteen_model.dart';
import 'package:mobile_app/presentation/widgets/glass_container.dart';
import 'package:mobile_app/presentation/widgets/glass_button.dart';
import 'package:mobile_app/presentation/widgets/fade_in_slide.dart';

class CanteenScreen extends ConsumerWidget {
  const CanteenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(canteenProductsProvider);
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen POS'),
        actions: [
          _buildCartAction(context, ref, cart, isDark),
          const SizedBox(width: 16),
        ],
      ),
      body: productsAsync.when(
        data: (products) => FadeInSlide(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GlassContainer(
                padding: EdgeInsets.zero,
                child: InkWell(
                  onTap: () => _addToCart(ref, product),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 20),
                        ),
                        const Spacer(),
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(product.category, style: const TextStyle(color: AppColors.textSub, fontSize: 11)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('EGP ${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
                            const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCartAction(BuildContext context, WidgetRef ref, List<CartItem> cart, bool isDark) {
    return GestureDetector(
      onTap: () => _showCart(context, ref),
      child: GlassContainer(
        width: 44,
        height: 44,
        borderRadius: 12,
        blur: 10,
        opacity: isDark ? 0.1 : 0.05,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 22),
            if (cart.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addToCart(WidgetRef ref, CanteenProduct product) {
    final cart = ref.read(cartProvider);
    final index = cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cart[index].quantity++;
      ref.read(cartProvider.notifier).state = [...cart];
    } else {
      ref.read(cartProvider.notifier).state = [...cart, CartItem(product: product)];
    }
  }

  void _showCart(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final cart = ref.watch(cartProvider);
        final total = cart.fold<double>(0, (sum, item) => sum + item.total);

        return GlassContainer(
          borderRadius: 32,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Sora')),
              const SizedBox(height: 24),
              if (cart.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text('Your cart is empty', style: TextStyle(color: AppColors.textSub)),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${item.quantity} x EGP ${item.product.price}', style: const TextStyle(color: AppColors.textSub, fontSize: 12)),
                                ],
                              ),
                            ),
                            Text('EGP ${item.total}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('EGP $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 32),
              GlassButton(
                label: 'Confirm Sale',
                onPressed: cart.isEmpty ? () => Navigator.pop(context) : () => _checkout(context, ref),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _checkout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(canteenRepositoryProvider).checkout(ref.read(cartProvider));
      ref.read(cartProvider.notifier).state = [];
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction completed!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showProductManagement(BuildContext context, WidgetRef ref) {
    // Placeholder for admin management
  }
}
