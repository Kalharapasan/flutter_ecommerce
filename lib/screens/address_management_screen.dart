import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/user_data_provider.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'My Addresses',
        showBackButton: true,
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userProvider, _) {
          return Stack(
            children: [
              if (userProvider.addresses.isEmpty)
                _buildEmptyState(context)
              else
                ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: userProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = userProvider.addresses[index];
                    return _buildAddressCard(
                      context,
                      address,
                      userProvider,
                    );
                  },
                ),
              // Floating Action Button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    _navigateToAddEditAddress(context, null);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 50,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No addresses yet',
            style: AppTextStyle.headlineLarge(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add your first address to get started',
            style: AppTextStyle.bodyMedium(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () {
              _navigateToAddEditAddress(context, null);
            },
            child: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    Address address,
    UserDataProvider userProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: address.isDefault
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with label and default badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    address.label,
                    style: AppTextStyle.labelLarge(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        'Default',
                        style: AppTextStyle.labelSmall(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () {
                      _navigateToAddEditAddress(context, address);
                    },
                  ),
                  if (!address.isDefault)
                    PopupMenuItem(
                      child: const Text('Set as Default'),
                      onTap: () {
                        userProvider.setDefaultAddress(address.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Default address updated'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  PopupMenuItem(
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _showDeleteConfirmation(context, address, userProvider);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Full Name and Phone
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                address.fullName,
                style: AppTextStyle.bodySmall(),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                address.phone,
                style: AppTextStyle.bodySmall(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Address Details
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
                  style: AppTextStyle.bodySmall(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditAddress(BuildContext context, Address? address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          address: address,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Address address,
    UserDataProvider userProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete ${address.label}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  late TextEditingController _labelController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.address != null) {
      _labelController = TextEditingController(text: widget.address!.label);
      _fullNameController = TextEditingController(text: widget.address!.fullName);
      _phoneController = TextEditingController(text: widget.address!.phone);
      _streetController = TextEditingController(text: widget.address!.street);
      _cityController = TextEditingController(text: widget.address!.city);
      _stateController = TextEditingController(text: widget.address!.state);
      _zipCodeController = TextEditingController(text: widget.address!.zipCode);
      _isDefault = widget.address!.isDefault;
    } else {
      _labelController = TextEditingController();
      _fullNameController = TextEditingController();
      _phoneController = TextEditingController();
      _streetController = TextEditingController();
      _cityController = TextEditingController();
      _stateController = TextEditingController();
      _zipCodeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.address != null ? 'Edit Address' : 'Add Address',
        showBackButton: true,
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Label/Type
                _buildTextField(
                  'Address Label',
                  'e.g., Home, Work, etc.',
                  _labelController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Full Name
                _buildTextField(
                  'Full Name',
                  'Enter your full name',
                  _fullNameController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Phone
                _buildTextField(
                  'Phone Number',
                  'Enter your phone number',
                  _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Street Address
                _buildTextField(
                  'Street Address',
                  'Enter your street address',
                  _streetController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // City
                _buildTextField(
                  'City',
                  'Enter your city',
                  _cityController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // State
                _buildTextField(
                  'State/Province',
                  'Enter your state or province',
                  _stateController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Zip Code
                _buildTextField(
                  'Zip Code',
                  'Enter your zip code',
                  _zipCodeController,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Set as Default Checkbox
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Set as default address',
                        style: AppTextStyle.bodyMedium(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _saveAddress(userProvider),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save Address'),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelLarge(),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveAddress(UserDataProvider userProvider) async {
    if (_labelController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _zipCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.address != null) {
        // Update existing address
        final updatedAddress = widget.address!.copyWith(
          label: _labelController.text,
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipCodeController.text,
          isDefault: _isDefault,
        );
        await userProvider.updateAddress(updatedAddress);
      } else {
        // Create new address
        final newAddress = Address(
          id: const Uuid().v4(),
          label: _labelController.text,
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          zipCode: _zipCodeController.text,
          isDefault: _isDefault,
        );
        await userProvider.addAddress(newAddress);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.address != null
                  ? 'Address updated successfully'
                  : 'Address added successfully',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
