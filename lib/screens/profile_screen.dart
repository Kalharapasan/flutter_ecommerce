import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // User Name
                  Text(
                    'John Doe',
                    style: AppTextStyle.headlineLarge(),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Email
                  Text(
                    'john.doe@example.com',
                    style: AppTextStyle.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('12', 'Orders'),
                      _buildStatItem('\$324.50', 'Total Spent'),
                      _buildStatItem('15', 'Wishlist'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Recent Orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Orders',
                    style: AppTextStyle.headlineSmall(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildOrderItem(
                    orderNumber: '#ORD-001234',
                    date: 'Dec 20, 2024',
                    status: 'Delivered',
                    amount: '\$149.99',
                    statusColor: AppColors.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildOrderItem(
                    orderNumber: '#ORD-001233',
                    date: 'Dec 15, 2024',
                    status: 'Delivered',
                    amount: '\$89.99',
                    statusColor: AppColors.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildOrderItem(
                    orderNumber: '#ORD-001232',
                    date: 'Dec 10, 2024',
                    status: 'In Transit',
                    amount: '\$45.99',
                    statusColor: AppColors.warning,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: AppTextStyle.headlineSmall(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.location_on,
                    title: 'Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage payment methods',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: 'Toggle dark mode',
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() => _darkMode = value);
                      },
                    ),
                    onTap: null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help with your account',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSettingItem(
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'About ShopHub',
                    onTap: () => _showAboutDialog(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: const Text('Logout'),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.headlineSmall(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyle.bodySmall(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String orderNumber,
    required String date,
    required String status,
    required String amount,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderNumber,
                style: AppTextStyle.labelLarge(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  status,
                  style: AppTextStyle.labelSmall(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: AppTextStyle.bodySmall(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                amount,
                style: AppTextStyle.labelLarge(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.labelLarge(),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodySmall(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature coming soon!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ShopHub'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: AppTextStyle.bodyMedium(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'ShopHub is a modern e-commerce flutter application built with clean architecture and best practices.',
              style: AppTextStyle.bodySmall(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '© 2026 ShopHub. All rights reserved.',
              style: AppTextStyle.bodySmall(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/splash');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}