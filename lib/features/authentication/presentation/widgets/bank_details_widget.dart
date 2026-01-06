import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dropdown_field.dart';

class BankDetailsWidget extends StatelessWidget {
  final TextEditingController accountNameController;
  final TextEditingController accountNumberController;
  final TextEditingController branchNameController;
  final TextEditingController branchCodeController;
  final String? selectedBankName; // 🆕 For dropdown
  final Function(String?)? onBankNameChanged; // 🆕 For dropdown

  const BankDetailsWidget({
    super.key,
    required this.accountNameController,
    required this.accountNumberController,
    required this.branchNameController,
    required this.branchCodeController,
    this.selectedBankName, // 🆕 NEW FIELD
    this.onBankNameChanged, // 🆕 For dropdown
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                Icons.account_balance,
                color: const Color(0xFF667eea),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Bank Account Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Required for pension disbursements',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        
        // 🆕 Bank Name Dropdown - FIXED NULL SAFETY
        DropdownField(
          value: selectedBankName,
          labelText: 'Bank Name',
          hintText: 'Select your bank',
          prefixIcon: Icons.account_balance_rounded,
          items: const [
            'Equity Bank',
            'KCB Bank',
            'Co-operative Bank',
            'NCBA Bank',
            'Standard Chartered',
            'Absa Bank',
            'DTB Bank',
            'Stanbic Bank',
            'I&M Bank',
            'Family Bank',
            'Barclays Bank',
            'Other',
          ],
          onChanged: onBankNameChanged != null 
              ? (value) => onBankNameChanged!(value) // 🔥 FIXED: Handle nullable callback
              : (value) {}, // 🔥 FIXED: Provide empty callback if null
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your bank';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: accountNameController,
          labelText: 'Account Holder Name',
          hintText: 'John Doe',
          prefixIcon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account holder name';
            }
            if (value.length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: accountNumberController,
          labelText: 'Account Number',
          hintText: '1234567890',
          prefixIcon: Icons.numbers_rounded,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter account number';
            }
            if (value.length < 8) {
              return 'Please enter a valid account number';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: branchNameController,
          labelText: 'Branch Name',
          hintText: 'Nairobi West',
          prefixIcon: Icons.location_on_outlined,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter branch name';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: branchCodeController,
          labelText: 'Branch Code',
          hintText: '001',
          prefixIcon: Icons.tag_rounded,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter branch code';
            }
            if (value.length < 2) {
              return 'Branch code too short';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF667eea).withOpacity(0.1),
                const Color(0xFFF093FB).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF667eea).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF667eea),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your pension benefits will be deposited to this account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}