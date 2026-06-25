import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/model/product.dart';
import 'package:flutter_ecommerce/providers/product_provider.dart';
import 'package:provider/provider.dart';


class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add product',
            onPressed: () => _showForm(context, null),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, pp, _) {
          if (pp.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (pp.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No products yet'),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _showForm(context, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pp.products.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 72),
            itemBuilder: (context, i) {
              final p = pp.products[i];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    p.image,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 52,
                      height: 52,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(p.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  '\$${p.price.toStringAsFixed(2)}  ·  ${p.category}  ·  Stock: ${p.inStock}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showForm(context, p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.red),
                      onPressed: () => _confirmDelete(context, pp, p),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showForm(BuildContext context, Product? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ProductFormSheet(existing: existing),
    );
  }

  void _confirmDelete(
      BuildContext context, ProductProvider pp, Product p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Remove "${p.name}" permanently?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await pp.deleteProduct(p.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${p.name}" deleted')));
              }
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ProductFormSheet extends StatefulWidget {
  final Product? existing;
  const _ProductFormSheet({this.existing});

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _price, _desc,
      _image, _stock, _rating, _reviews;
  late String _category;
  bool _saving = false;

  static const _cats = ['Electronics', 'Wearables', 'Accessories'];

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _name    = TextEditingController(text: p?.name ?? '');
    _price   = TextEditingController(text: p?.price.toString() ?? '');
    _desc    = TextEditingController(text: p?.description ?? '');
    _image   = TextEditingController(text: p?.image ?? 'data/images/1.jpg');
    _stock   = TextEditingController(text: p?.inStock.toString() ?? '0');
    _rating  = TextEditingController(text: p?.rating.toString() ?? '4.5');
    _reviews = TextEditingController(text: p?.reviews.toString() ?? '0');
    _category = p?.category ?? _cats.first;
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _desc, _image, _stock, _rating, _reviews]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text(isEdit ? 'Edit Product' : 'Add New Product',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _field(_name, 'Product Name'),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _field(_price, 'Price (\$)', isNum: true)),
                const SizedBox(width: 12),
                Expanded(child: _field(_stock, 'Stock', isNum: true)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _field(_rating, 'Rating (0–5)', isNum: true)),
                const SizedBox(width: 12),
                Expanded(child: _field(_reviews, 'Reviews', isNum: true)),
              ]),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder()),
                items: _cats
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              _field(_image, 'Image asset path (e.g. data/images/1.jpg)'),
              const SizedBox(height: 12),
              _field(_desc, 'Description', maxLines: 3),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white))
                      : Text(isEdit ? 'Save Changes' : 'Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {bool isNum = false, int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
          labelText: label, border: const OutlineInputBorder()),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final pp = context.read<ProductProvider>();
    final product = Product(
      id: widget.existing?.id ?? pp.nextId(),
      name: _name.text.trim(),
      price: double.tryParse(_price.text) ?? 0,
      description: _desc.text.trim(),
      rating: double.tryParse(_rating.text) ?? 4.5,
      reviews: int.tryParse(_reviews.text) ?? 0,
      image: _image.text.trim(),
      category: _category,
      inStock: int.tryParse(_stock.text) ?? 0,
    );

    if (widget.existing == null) {
      await pp.addProduct(product);
    } else {
      await pp.updateProduct(product);
    }

    setState(() => _saving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.existing == null
              ? '"${product.name}" added'
              : '"${product.name}" updated')));
    }
  }
}
