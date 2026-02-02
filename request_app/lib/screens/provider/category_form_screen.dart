import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/category_model.dart';

class CategoryFormScreen extends StatefulWidget {
  final CategoryModel? category;
  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _imageUrlController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.category?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.category?.imageUrl ?? '',
    );
    _status = widget.category?.status ?? 'active';
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final db = context.read<DatabaseService>();
      final newCat = CategoryModel(
        id: widget.category?.id ?? '', // ID handled by DB if empty/new
        title: _titleController.text,
        description: _descController.text,
        status: _status,
        imageUrl: _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : null,
      );

      if (widget.category == null) {
        await db.addCategory(newCat);
      } else {
        await db.updateCategory(newCat);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'New Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            // Changed to ListView to avoid overflow
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Category Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Icon/Image URL (Top Priority)',
                  hintText: 'https://images.unsplash.com/...',
                  helperText:
                      'Paste an Unsplash URL here to display in the app.',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
