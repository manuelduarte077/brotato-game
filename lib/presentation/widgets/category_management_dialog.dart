import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/category.dart';

class CategoryManagementBottomSheet extends ConsumerStatefulWidget {
  const CategoryManagementBottomSheet({super.key});

  @override
  ConsumerState<CategoryManagementBottomSheet> createState() =>
      _CategoryManagementBottomSheetState();
}

class _CategoryManagementBottomSheetState
    extends ConsumerState<CategoryManagementBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedColor = '#FF4081';
  String _selectedIcon = 'shopping_bag';

  final List<IconData> _iconOptions = [
    Icons.shopping_bag_outlined,
    Icons.fastfood_outlined,
    Icons.home_outlined,
    Icons.directions_car_outlined,
    Icons.flight_outlined,
    Icons.fitness_center_outlined,
    Icons.school_outlined,
    Icons.pets_outlined,
    Icons.medical_services_outlined,
    Icons.work_outlined,
    Icons.local_grocery_store_outlined,
    Icons.local_laundry_service_outlined,
    Icons.local_movies_outlined,
    Icons.local_offer_outlined,
  ];

  final List<String> _colorOptions = [
    '#FF4081',
    '#2196F3',
    '#4CAF50',
    '#FFC107',
    '#9C27B0',
    '#FF5722',
    '#000000',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nueva Categoría',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la categoría',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Color:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colorOptions.map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              Color(int.parse(color.replaceAll('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: _selectedColor == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Icono:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_iconOptions.length, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon =
                          _iconOptions[index].codePoint.toString()),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedIcon ==
                                  _iconOptions[index].codePoint.toString()
                              ? Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _iconOptions[index],
                          color: _selectedIcon ==
                                  _iconOptions[index].codePoint.toString()
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 28,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newCategory = Category(
                        name: _nameController.text,
                        color: _selectedColor,
                        icon: _selectedIcon,
                      );
                      Navigator.of(context).pop(newCategory);
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Guardar Categoría'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
