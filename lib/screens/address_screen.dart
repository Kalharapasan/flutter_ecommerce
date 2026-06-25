import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/user_data_provider.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:flutter_ecommerce/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'My Addresses',
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(context, null),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
      body: Consumer<UserDataProvider>(
        builder: (context, userData, _) {
          final addresses = userData.addresses;

          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off_rounded,
                    size: 72,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No saved addresses',
                    style: AppTextStyle.headlineSmall(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tap the button below to add one',
                    style: AppTextStyle.bodyMedium(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _AddressCard(
                address: address,
                onEdit: () => _showAddressForm(context, address),
                onDelete: () => _confirmDelete(context, address, userData),
                onSetDefault: () => userData.setDefaultAddress(address.id),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Address address, UserDataProvider userData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              userData.deleteAddress(address.id);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddressForm(BuildContext context, Address? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddressForm(existing: existing),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: address.isDefault
              ? Theme.of(context).primaryColor.withOpacity(0.5)
              : Theme.of(context).dividerColor,
          width: address.isDefault ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _labelColor(address.label).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  address.label,
                  style: AppTextStyle.labelSmall(
                    color: _labelColor(address.label),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Default',
                    style: AppTextStyle.labelSmall(color: AppColors.success),
                  ),
                ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                  if (value == 'default') onSetDefault();
                },
                itemBuilder: (ctx) => [
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Text('Set as Default'),
                    ),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            address.fullName,
            style: AppTextStyle.labelLarge(),
          ),
          const SizedBox(height: 2),
          Text(
            address.phone,
            style: AppTextStyle.bodySmall(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
            style: AppTextStyle.bodyMedium(),
          ),
        ],
      ),
    );
  }

  Color _labelColor(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return AppColors.primary;
      case 'work':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _AddressForm extends StatefulWidget {
  final Address? existing;

  const _AddressForm({this.existing});

  @override
  State<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<_AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _zipCtrl;
  String _label = 'Home';
  bool _isDefault = false;

  final List<String> _labels = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    _fullNameCtrl = TextEditingController(text: a?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: a?.phone ?? '');
    _streetCtrl = TextEditingController(text: a?.street ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _stateCtrl = TextEditingController(text: a?.state ?? '');
    _zipCtrl = TextEditingController(text: a?.zipCode ?? '');
    _label = a?.label ?? 'Home';
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
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
              Text(
                widget.existing == null ? 'Add New Address' : 'Edit Address',
                style: AppTextStyle.headlineSmall(),
              ),
              const SizedBox(height: AppSpacing.md),

              // Label selector
              Text('Label', style: AppTextStyle.labelLarge()),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: _labels.map((label) {
                  final selected = label == _label;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _label = label),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.md),

              _buildField('Full Name', _fullNameCtrl, 'Enter full name'),
              _buildField('Phone', _phoneCtrl, 'Enter phone number',
                  keyboardType: TextInputType.phone),
              _buildField('Street Address', _streetCtrl, 'Enter street address'),
              Row(
                children: [
                  Expanded(child: _buildField('City', _cityCtrl, 'City')),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _buildField('State', _stateCtrl, 'State')),
                ],
              ),
              _buildField('ZIP Code', _zipCtrl, 'ZIP Code',
                  keyboardType: TextInputType.number),

              // Default toggle
              Row(
                children: [
                  Switch(
                    value: _isDefault,
                    onChanged: (v) => setState(() => _isDefault = v),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Set as default address', style: AppTextStyle.bodyMedium()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    widget.existing == null ? 'Add Address' : 'Save Changes',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.labelLarge()),
          const SizedBox(height: 4),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            decoration: InputDecoration(
              hintText: hint,
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
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final userData = context.read<UserDataProvider>();
    final id = widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final address = Address(
      id: id,
      label: _label,
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      zipCode: _zipCtrl.text.trim(),
      isDefault: _isDefault,
    );

    if (widget.existing == null) {
      userData.addAddress(address);
    } else {
      userData.updateAddress(address);
    }

    Navigator.pop(context);
  }
}
