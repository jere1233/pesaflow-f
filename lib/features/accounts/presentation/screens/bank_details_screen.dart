import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/account_provider.dart';

class BankDetailsScreen extends StatefulWidget {
  final int accountId;

  const BankDetailsScreen({super.key, required this.accountId});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _branchNameCtrl = TextEditingController();
  final _branchCodeCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchBankDetails(widget.accountId).then((details) {
        if (details != null) {
          _nameCtrl.text = details['bankAccountName'] ?? '';
          _numberCtrl.text = details['bankAccountNumber'] ?? '';
          _branchNameCtrl.text = details['bankBranchName'] ?? '';
          _branchCodeCtrl.text = details['bankBranchCode'] ?? '';
        }
      });
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _branchNameCtrl.dispose();
    _branchCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await context.read<AccountProvider>().saveBankDetails(
      accountId: widget.accountId,
      bankAccountName: _nameCtrl.text.trim(),
      bankAccountNumber: _numberCtrl.text.trim(),
      bankBranchName: _branchNameCtrl.text.trim().isEmpty ? null : _branchNameCtrl.text.trim(),
      bankBranchCode: _branchCodeCtrl.text.trim().isEmpty ? null : _branchCodeCtrl.text.trim(),
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bank details saved'), backgroundColor: Colors.green));
      Navigator.of(context).pop(true);
    } else {
      final msg = context.read<AccountProvider>().errorMessage ?? 'Failed to save bank details';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete bank details'),
        content: const Text('Are you sure you want to delete bank details for this account?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await context.read<AccountProvider>().deleteBankDetails(widget.accountId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bank details deleted'), backgroundColor: Colors.green));
      Navigator.of(context).pop(true);
    } else {
      final msg = context.read<AccountProvider>().errorMessage ?? 'Failed to delete bank details';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter account name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numberCtrl,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter account number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _branchNameCtrl,
                decoration: const InputDecoration(labelText: 'Branch Name (optional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _branchCodeCtrl,
                decoration: const InputDecoration(labelText: 'Branch Code (optional)'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _delete,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
