import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/service_model.dart';
import '../../models/category_model.dart';

class ServiceFormScreen extends StatefulWidget {
  final ServiceModel? service;
  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _basePriceCtrl;
  late TextEditingController _vatCtrl;
  late TextEditingController _discountCtrl;
  late TextEditingController _imageCtrl;

  String? _selectedCategoryId;
  double _totalPrice = 0.0;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.service?.name ?? '');
    _basePriceCtrl = TextEditingController(
      text: widget.service?.basePrice.toString() ?? '0',
    );
    _vatCtrl = TextEditingController(
      text: widget.service?.vatPercent.toString() ?? '0',
    );
    _discountCtrl = TextEditingController(
      text: widget.service?.discountAmount.toString() ?? '0',
    );
    _imageCtrl = TextEditingController(text: widget.service?.imageUrl ?? '');
    _selectedCategoryId = widget.service?.categoryId;
    _status = widget.service?.status ?? 'active';

    _calculateTotal();

    // Listeners for realtime calc
    _basePriceCtrl.addListener(_calculateTotal);
    _vatCtrl.addListener(_calculateTotal);
    _discountCtrl.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    double base = double.tryParse(_basePriceCtrl.text) ?? 0;
    double vat = double.tryParse(_vatCtrl.text) ?? 0;
    double discount = double.tryParse(_discountCtrl.text) ?? 0;

    if (mounted) {
      setState(() {
        _totalPrice = (base + (base * vat / 100)) - discount;
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      final db = context.read<DatabaseService>();
      final newService = ServiceModel(
        id: widget.service?.id ?? '',
        categoryId: _selectedCategoryId!,
        name: _nameCtrl.text,
        basePrice: double.parse(_basePriceCtrl.text),
        vatPercent: double.parse(_vatCtrl.text),
        discountAmount: double.parse(_discountCtrl.text),
        imageUrl: _imageCtrl.text,
        status: _status,
      );

      if (widget.service == null) {
        await db.addService(newService);
      } else {
        await db.updateService(newService);
      }
      if (mounted) Navigator.pop(context);
    } else if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _basePriceCtrl.dispose();
    _vatCtrl.dispose();
    _discountCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<DatabaseService>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? 'New Service' : 'Edit Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<List<CategoryModel>>(
                stream: db.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();

                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    hint: const Text('Select Category'),
                    items: snapshot.data!
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.title),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  prefixIcon: Icon(Icons.cleaning_services),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: Icon(Icons.image),
                ),
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Service Status',
                  prefixIcon: Icon(Icons.visibility),
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),

              const SizedBox(height: 24),
              const Text(
                "Pricing Details (ETB)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _basePriceCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Base Price',
                        prefixIcon: Icon(Icons.money),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _vatCtrl,
                      decoration: const InputDecoration(
                        labelText: 'VAT %',
                        prefixIcon: Icon(Icons.percent),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Discount Amount (Birr)',
                  prefixIcon: Icon(Icons.money_off),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Calculated Price',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ETB ${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Service Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
