import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/model/product.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _quantity = 1;
  late AnimationController _imageController;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOut),
    );
    _imageController.forward();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final cartProvider = context.read<CartProvider>();
    
    for (int i = 0; i < _quantity; i++) {
      cartProvider.addToCart(widget.product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity item(s) to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );

    // Optional: Go to cart automatically after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushNamed(context, '/cart');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final isInCart = cartProvider.isInCart(widget.product.id);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Product Details',
        showBackButton: true,
        showCartIcon: true,
        onCartPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            FadeTransition(
              opacity: _imageAnimation,
              child: Container(
                width: double.infinity,
                height: 300,
                color: Theme.of(context).cardColor,
                child: Hero(
                  tag: 'product-image-${widget.product.id}',
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.05)
                            : AppColors.borderLight,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      widget.product.category,
                      style: AppTextStyle.labelSmall(
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Product Name
                  Text(
                    widget.product.name,
                    style: AppTextStyle.displayMedium(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < widget.product.rating.floor()
                              ? Icons.star_rounded
                              : index < widget.product.rating
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded,
                          color: AppColors.ratingColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        '${widget.product.rating}/5.0',
                        style: AppTextStyle.labelLarge(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '(${widget.product.reviews} reviews)',
                        style: AppTextStyle.bodySmall(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        widget.product.inStock > 0
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: widget.product.inStock > 0
                            ? AppColors.success
                            : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        widget.product.inStock > 0
                            ? '${widget.product.inStock} in stock'
                            : 'Out of stock',
                        style: AppTextStyle.bodyMedium(
                          color: widget.product.inStock > 0
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Divider
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Price Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: AppTextStyle.bodySmall(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: AppTextStyle.displayLarge(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      if (isInCart)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Quantity Selector
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          child: Icon(
                            Icons.remove_rounded,
                            color: _quantity > 1
                                ? AppColors.primary
                                : Theme.of(context).disabledColor,
                            size: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: Text(
                            _quantity.toString(),
                            style: AppTextStyle.headlineSmall(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _quantity++),
                          child: const Icon(
                            Icons.add_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Description
                  Text(
                    'Description',
                    style: AppTextStyle.headlineSmall(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    widget.product.description,
                    style: AppTextStyle.bodyMedium(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.product.inStock > 0
                          ? _addToCart
                          : null,
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Share Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product link copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('Share Product'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}