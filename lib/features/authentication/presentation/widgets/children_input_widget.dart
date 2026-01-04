// lib/features/authentication/presentation/widgets/children_input_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../authentication/data/models/register_request_model.dart';
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.child_care_rounded,
                    color: const Color(0xFF667eea),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Children',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _addChild,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          'Add Child',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_childEntries.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.child_friendly_rounded,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No children added',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap "Add Child" to add your children',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        
        ...List.generate(_childEntries.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Child ${index + 1}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                      iconSize: 22,
                      onPressed: () => _removeChild(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
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