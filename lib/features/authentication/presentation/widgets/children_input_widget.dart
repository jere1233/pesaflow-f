import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../authentication/data/models/auth_response_model.dart';
import 'date_picker_field.dart';
import 'custom_text_field.dart';

class ChildrenInputWidget extends StatefulWidget {
  final List<ChildModel> children;
  final Function(List<ChildModel>) onChildrenChanged;

  const ChildrenInputWidget({
    super.key,
    required this.children,
    required this.onChildrenChanged,
  });

  @override
  State<ChildrenInputWidget> createState() => _ChildrenInputWidgetState();
}

class _ChildrenInputWidgetState extends State<ChildrenInputWidget> {
  final List<_ChildEntry> _childEntries = [];

  @override
  void initState() {
    super.initState();
    // Initialize with existing children
    if (widget.children.isNotEmpty) {
      for (var child in widget.children) {
        _childEntries.add(_ChildEntry(
          nameController: TextEditingController(text: child.name),
          dobController: TextEditingController(text: child.dob),
        ));
      }
    }
  }

  @override
  void dispose() {
    for (var entry in _childEntries) {
      entry.nameController.dispose();
      entry.dobController.dispose();
    }
    super.dispose();
  }

  void _addChild() {
    setState(() {
      _childEntries.add(_ChildEntry(
        nameController: TextEditingController(),
        dobController: TextEditingController(),
      ));
    });
  }

  void _removeChild(int index) {
    setState(() {
      _childEntries[index].nameController.dispose();
      _childEntries[index].dobController.dispose();
      _childEntries.removeAt(index);
      _updateChildren();
    });
  }

  void _updateChildren() {
    final children = _childEntries.map((entry) {
      return ChildModel(
        name: entry.nameController.text,
        dob: entry.dobController.text,
      );
    }).toList();
    widget.onChildrenChanged(children);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Children',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: _addChild,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text(
                'Add Child',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        if (_childEntries.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Center(
              child: Text(
                'No children added yet',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        
        ...List.generate(_childEntries.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Child ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeChild(index),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                CustomTextField(
                  controller: _childEntries[index].nameController,
                  labelText: 'Child Name',
                  hintText: 'Enter child name',
                  prefixIcon: Icons.child_care,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => _updateChildren(),
                ),
                
                const SizedBox(height: 12),
                
                DatePickerField(
                  controller: _childEntries[index].dobController,
                  labelText: 'Date of Birth',
                  hintText: 'Select date',
                  prefixIcon: Icons.cake,
                  lastDate: DateTime.now(),
                  initialDate: DateTime.now().subtract(const Duration(days: 365)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _ChildEntry {
  final TextEditingController nameController;
  final TextEditingController dobController;

  _ChildEntry({
    required this.nameController,
    required this.dobController,
  });
}