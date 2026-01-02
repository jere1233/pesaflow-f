import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class BankDetailsWidget extends StatelessWidget {
  final TextEditingController accountNameController;
  final TextEditingController accountNumberController;
  final TextEditingController branchNameController;
  final TextEditingController branchCodeController;

  const BankDetailsWidget({
    super.key,
    required this.accountNameController,
    required this.accountNumberController,
    required this.branchNameController,
    required this.branchCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bank Account Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.95),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Required for pension disbursements',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 20),
        
        CustomTextField(
          controller: accountNameController,
          labelText: 'Account Holder Name',
          hintText: 'Enter account holder name',
          prefixIcon: Icons.account_balance_outlined,
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
          hintText: 'Enter account number',
          prefixIcon: Icons.credit_card_outlined,
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
        
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: branchNameController,
                labelText: 'Branch Name',
                hintText: 'e.g., Nairobi - West',
                prefixIcon: Icons.business_outlined,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter branch name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: CustomTextField(
                controller: branchCodeController,
                labelText: 'Branch Code',
                hintText: 'e.g., 011',
                prefixIcon: Icons.numbers_outlined,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (value.length < 2) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[300],
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your pension benefits will be deposited to this account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
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