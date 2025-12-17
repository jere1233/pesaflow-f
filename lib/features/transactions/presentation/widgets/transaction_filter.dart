// lib/features/transactions/presentation/widgets/transaction_filter.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class TransactionFilter extends StatefulWidget {
  final VoidCallback onApply;

  const TransactionFilter({
    super.key,
    required this.onApply,
  });

  @override
  State<TransactionFilter> createState() => _TransactionFilterState();
}

class _TransactionFilterState extends State<TransactionFilter> {
  String? _selectedType;
  String? _selectedStatus;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _types = ['All', 'Credit', 'Debit', 'Transfer'];
  final List<String> _statuses = ['All', 'Completed', 'Pending', 'Failed'];
  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Utilities',
    'Entertainment',
    'Salary',
    'Transfer',
    'Bill Payment',
    'Subscription',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<TransactionProvider>();
    _selectedType = provider.selectedType;
    _selectedStatus = provider.selectedStatus;
    _selectedCategory = provider.selectedCategory;
    _startDate = provider.startDate;
    _endDate = provider.endDate;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _applyFilters() {
    final provider = context.read<TransactionProvider>();

    // Set filters (null means "All")
    provider.setTypeFilter(_selectedType == 'All' ? null : _selectedType);
    provider.setStatusFilter(_selectedStatus == 'All' ? null : _selectedStatus);
    provider.setCategoryFilter(
        _selectedCategory == 'All' ? null : _selectedCategory);
    provider.setDateRange(_startDate, _endDate);

    widget.onApply();
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _selectedCategory = null;
      _startDate = null;
      _endDate = null;
    });
    context.read<TransactionProvider>().clearFilters();
    widget.onApply();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(),

          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Type
                  _FilterSection(
                    title: 'Transaction Type',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _types.map((type) {
                        final isSelected = _selectedType == type ||
                            (_selectedType == null && type == 'All');
                        return _FilterChip(
                          label: type,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedType = type == 'All' ? null : type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status
                  _FilterSection(
                    title: 'Status',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statuses.map((status) {
                        final isSelected = _selectedStatus == status ||
                            (_selectedStatus == null && status == 'All');
                        return _FilterChip(
                          label: status,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedStatus = status == 'All' ? null : status;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category
                  _FilterSection(
                    title: 'Category',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category ||
                            (_selectedCategory == null && category == 'All');
                        return _FilterChip(
                          label: category,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategory =
                                  category == 'All' ? null : category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date Range
                  _FilterSection(
                    title: 'Date Range',
                    child: InkWell(
                      onTap: _selectDateRange,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _startDate != null && _endDate != null
                                    ? '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}'
                                    : 'Select date range',
                                style: TextStyle(
                                  color: _startDate != null && _endDate != null
                                      ? Colors.black87
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            if (_startDate != null && _endDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _startDate = null;
                                    _endDate = null;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}