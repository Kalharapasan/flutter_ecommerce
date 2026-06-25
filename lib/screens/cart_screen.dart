import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        showBackButton: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items[index];
                    return _buildCartItem(
                      context,
                      cartProvider,
                      cartItem,
                    );
                  },
                ),
              ),
              // Cart Summary and Checkout
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    // Price Summary
                    _buildSummaryRow(
                      'Subtotal',
                      '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSummaryRow(
                      'Shipping',
                      'Free',
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSummaryRow(
                      'Tax',
                      '\$${(cartProvider.totalPrice * 0.1).toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Divider(
                      color: AppColors.border,
                      thickness: 1,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Total
                    _buildSummaryRow(
                      'Total',
                      '\$${(cartProvider.totalPrice + (cartProvider.totalPrice * 0.1)).toStringAsFixed(2)}',
                      isBold: true,
                      valueColor: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showCheckoutDialog(context, cartProvider);
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Continue Shopping
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Continue Shopping'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 50,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Your cart is empty',
            style: AppTextStyle.headlineLarge(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add some products to get started',
            style: AppTextStyle.bodyMedium(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartProvider cartProvider,
    dynamic cartItem,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Image.network(
              cartItem.product.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 32,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.labelLarge(),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: AppTextStyle.bodySmall(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // Quantity and Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Remove Button
              GestureDetector(
                onTap: () {
                  cartProvider.removeFromCart(cartItem.product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Removed from cart'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cartProvider.addToCart(cartItem.product);
                        },
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          cartProvider.updateQuantity(
                            cartItem.product.id,
                            cartItem.quantity - 1,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: cartItem.quantity > 1
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${cartItem.quantity}',
                        style: AppTextStyle.bodySmall(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cartProvider.updateQuantity(
                          cartItem.product.id,
                          cartItem.quantity + 1,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color valueColor = AppColors.textPrimary,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyle.labelLarge()
              : AppTextStyle.bodyMedium(),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyle.headlineSmall(color: valueColor)
              : AppTextStyle.bodyMedium(color: valueColor),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppTextStyle.labelLarge(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Items: ${cartProvider.totalItems}',
              style: AppTextStyle.bodyMedium(),
            ),
            Text(
              'Total: \$${(cartProvider.totalPrice + (cartProvider.totalPrice * 0.1)).toStringAsFixed(2)}',
              style: AppTextStyle.bodyMedium(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Thank you for your order! This is a demo app.',
              style: AppTextStyle.bodySmall(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              });
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}