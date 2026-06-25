import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/theme_provider.dart';
import 'package:flutter_ecommerce/providers/user_data_provider.dart';
import 'package:flutter_ecommerce/screens/address_screen.dart';
import 'package:flutter_ecommerce/screens/order_detail_screen.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userData, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // User Profile Section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.2 : 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => _showEditProfileSheet(context, userData),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).cardColor,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(Icons.edit, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        userData.name,
                        style: AppTextStyle.headlineLarge(),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        userData.email,
                        style: AppTextStyle.bodySmall(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                      ),
                      if (userData.phone.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          userData.phone,
                          style: AppTextStyle.bodySmall(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('${userData.orders.length}', 'Orders'),
                          _buildStatItem(
                            '\$${userData.orders.fold<double>(0, (sum, o) => sum + (double.tryParse(o.amount.replaceAll('\$', '')) ?? 0)).toStringAsFixed(0)}',
                            'Total Spent',
                          ),
                          _buildStatItem('${userData.addresses.length}', 'Addresses'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Recent Orders
                if (userData.orders.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Orders', style: AppTextStyle.headlineSmall()),
                            Text(
                              '${userData.orders.length} orders',
                              style: AppTextStyle.bodySmall(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...userData.orders.map((order) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildOrderCard(context, order),
                          );
                        }),
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
                      Text('Settings', style: AppTextStyle.headlineSmall()),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Update your name, email and phone',
                        onTap: () => _showEditProfileSheet(context, userData),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.location_on_rounded,
                        title: 'Addresses',
                        subtitle: 'Manage delivery addresses',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddressScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage your notifications',
                        onTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.payment_rounded,
                        title: 'Payment Methods',
                        subtitle: 'Manage payment methods',
                        onTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.dark_mode_rounded,
                        title: 'Dark Mode',
                        subtitle: 'Toggle dark mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                        ),
                        onTap: null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        subtitle: 'Get help with your account',
                        onTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSettingItem(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        subtitle: 'About ShopHub',
                        onTap: () => _showAboutDialog(context),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showLogoutDialog(context),
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
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.headlineSmall(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyle.bodySmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderItem order) {
    Color statusColor = AppColors.textSecondary;
    if (order.statusColor == 'success') statusColor = AppColors.success;
    if (order.statusColor == 'warning') statusColor = AppColors.warning;
    if (order.statusColor == 'error') statusColor = AppColors.error;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
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
                Text(order.orderNumber, style: AppTextStyle.labelLarge()),
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
                    order.status,
                    style: AppTextStyle.labelSmall(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.date,
                  style: AppTextStyle.bodySmall(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                Text(
                  order.amount,
                  style: AppTextStyle.labelLarge(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Details',
                  style: AppTextStyle.bodySmall(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
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
              child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.labelLarge()),
                  Text(
                    subtitle,
                    style: AppTextStyle.bodySmall(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.arrow_forward_ios, color: Theme.of(context).disabledColor, size: 16),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, UserDataProvider userData) {
    final nameCtrl = TextEditingController(text: userData.name);
    final emailCtrl = TextEditingController(text: userData.email);
    final phoneCtrl = TextEditingController(text: userData.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewInsets.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Edit Profile', style: AppTextStyle.headlineSmall()),
              const SizedBox(height: AppSpacing.md),
              _profileField('Full Name', nameCtrl, context),
              const SizedBox(height: AppSpacing.sm),
              _profileField('Email', emailCtrl, context, keyboard: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.sm),
              _profileField('Phone', phoneCtrl, context, keyboard: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    userData.updateProfile(
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileField(String label, TextEditingController ctrl, BuildContext context,
      {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.labelLarge()),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
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
            Text('Version 1.0.0', style: AppTextStyle.bodyMedium()),
            const SizedBox(height: AppSpacing.md),
            Text(
              'ShopHub is a modern e-commerce flutter application built with clean architecture and best practices.',
              style: AppTextStyle.bodySmall(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '© 2026 ShopHub. All rights reserved.',
              style: AppTextStyle.bodySmall(color: AppColors.textTertiary),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}