import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartIcon;
  final VoidCallback? onCartPressed;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showCartIcon = false,
    this.onCartPressed,
    this.centerTitle = false,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyle.headlineLarge(),
      ),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      leading: showBackButton
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            )
          : leading,
      actions: [
        if (showCartIcon)
          GestureDetector(
            onTap: onCartPressed,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        if (cartProvider.totalItems == 0) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartProvider.totalItems > 99
                                ? '99+'
                                : '${cartProvider.totalItems}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (actions != null) ...actions!,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: AppColors.border,
          thickness: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}