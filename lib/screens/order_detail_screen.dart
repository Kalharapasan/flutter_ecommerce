import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/user_data_provider.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderItem order;

  const OrderDetailScreen({super.key, required this.order});

  Color _getStatusColor(String statusColor) {
    switch (statusColor) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'error':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.statusColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Order Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderNumber,
                        style: AppTextStyle.headlineSmall(),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              order.statusColor == 'success'
                                  ? Icons.check_circle_rounded
                                  : order.statusColor == 'warning'
                                      ? Icons.local_shipping_rounded
                                      : Icons.cancel_rounded,
                              color: statusColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.status,
                              style: AppTextStyle.labelSmall(color: statusColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Ordered on ${order.date}',
                    style: AppTextStyle.bodySmall(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTimeline(context),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Items Section
            if (order.items.isNotEmpty) ...[
              Text('Order Items', style: AppTextStyle.headlineSmall()),
              const SizedBox(height: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: order.items.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] as String? ?? '',
                                      style: AppTextStyle.labelLarge(),
                                    ),
                                    Text(
                                      'Qty: ${item['qty']}',
                                      style: AppTextStyle.bodySmall(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item['price'] as String? ?? '',
                                style: AppTextStyle.labelLarge(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < order.items.length - 1)
                          Divider(height: 1, color: Theme.of(context).dividerColor),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            // Delivery Address
            if (order.address != null) ...[
              Text('Delivery Address', style: AppTextStyle.headlineSmall()),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        order.address!,
                        style: AppTextStyle.bodyMedium(),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            // Payment Method
            if (order.paymentMethod != null) ...[
              Text('Payment Method', style: AppTextStyle.headlineSmall()),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.payment_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      order.paymentMethod!,
                      style: AppTextStyle.bodyMedium(),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            // Order Total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(isDark ? 0.15 : 0.06),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Total',
                    style: AppTextStyle.headlineSmall(),
                  ),
                  Text(
                    order.amount,
                    style: AppTextStyle.headlineSmall(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final steps = ['Order Placed', 'Processing', 'Shipped', 'Delivered'];
    int activeStep = 1;
    if (order.statusColor == 'warning') activeStep = 2;
    if (order.statusColor == 'success') activeStep = 3;

    return Row(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final step = entry.value;
        final isCompleted = i <= activeStep;
        final isCurrent = i == activeStep;
        final isLast = i == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                                width: 3,
                              )
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        color: isCompleted ? Colors.white : Colors.transparent,
                        size: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: isCompleted
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: i < activeStep
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
