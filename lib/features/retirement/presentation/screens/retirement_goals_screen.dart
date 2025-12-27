// lib/features/retirement/presentation/screens/retirement_goals_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class RetirementGoalsScreen extends StatefulWidget {
  const RetirementGoalsScreen({super.key});

  @override
  State<RetirementGoalsScreen> createState() => _RetirementGoalsScreenState();
}

class _RetirementGoalsScreenState extends State<RetirementGoalsScreen> {
  final _currentAgeController = TextEditingController(text: '35');
  final _targetAgeController = TextEditingController(text: '65');
  final _currentBalanceController = TextEditingController(text: '1088000');
  final _monthlyController = TextEditingController(text: '5000');
  final _annualReturnController = TextEditingController(text: '8');

  Map<String, dynamic>? _projected;

  @override
  void dispose() {
    _currentAgeController.dispose();
    _targetAgeController.dispose();
    _currentBalanceController.dispose();
    _monthlyController.dispose();
    _annualReturnController.dispose();
    super.dispose();
  }

  void _calculate() {
    final currentAge = int.tryParse(_currentAgeController.text) ?? 35;
    final targetAge = int.tryParse(_targetAgeController.text) ?? 65;
    final currentBalance = double.tryParse(_currentBalanceController.text) ?? 1088000;
    final monthly = double.tryParse(_monthlyController.text) ?? 5000;
    final annualReturn = double.tryParse(_annualReturnController.text) ?? 8;

    final years = targetAge - currentAge;

    if (years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Retirement age must be in the future'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate future value
    double futureValue = currentBalance * pow(1 + annualReturn / 100, years);
    final monthlyContributions = monthly * 12 * (pow(1 + annualReturn / 100, years) - 1) / (annualReturn / 100);
    futureValue += monthlyContributions;

    // 4% withdrawal rule
    final monthlyIncome = futureValue * 0.04 / 12;
    final totalContributed = currentBalance + (monthly * 12 * years);

    setState(() {
      _projected = {
        'futureValue': futureValue.round(),
        'monthlyIncome': monthlyIncome.round(),
        'years': years,
        'totalContributed': totalContributed.round(),
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retirement plan calculated'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _reset() {
    setState(() {
      _currentAgeController.text = '35';
      _targetAgeController.text = '65';
      _currentBalanceController.text = '1088000';
      _monthlyController.text = '5000';
      _annualReturnController.text = '8';
      _projected = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form reset'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Retirement Goals'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Plan your retirement and see detailed projections based on your contributions and investment returns.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Goal Cards
            Row(
              children: [
                Expanded(
                  child: _GoalCard(
                    icon: Icons.flag,
                    iconColor: AppColors.primary,
                    label: 'Comfortable Retirement',
                    amount: 5000000,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GoalCard(
                    icon: Icons.lightbulb,
                    iconColor: Colors.orange,
                    label: 'Healthcare Fund',
                    amount: 1000000,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _GoalCard(
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                    label: 'Emergency Reserve',
                    amount: 500000,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 32),

            // Input Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _InputField(
                    label: 'Current Age',
                    controller: _currentAgeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _InputField(
                    label: 'Target Retirement Age',
                    controller: _targetAgeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _InputField(
                    label: 'Current Balance (KES)',
                    controller: _currentBalanceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _InputField(
                    label: 'Monthly Contribution (KES)',
                    controller: _monthlyController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _InputField(
                    label: 'Expected Annual Return (%)',
                    controller: _annualReturnController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _calculate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Calculate',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _reset,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Results
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Projection',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_projected != null) ...[
                    _ResultCard(
                      title: 'Projected Retirement Pot',
                      value: 'KES ${_formatNumber(_projected!['futureValue'])}',
                      subtitle: 'At age ${int.tryParse(_targetAgeController.text) ?? 65} (in ${_projected!['years']} years)',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
                      ),
                      textColor: const Color(0xFF065F46),
                    ),
                    const SizedBox(height: 16),
                    _ResultCard(
                      title: 'Monthly Income at Retirement',
                      value: 'KES ${_formatNumber(_projected!['monthlyIncome'])}',
                      subtitle: 'Using 4% withdrawal rule',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDEFAFF), Color(0xFFBAE6FD)],
                      ),
                      textColor: const Color(0xFF0C4A6E),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _SmallResultCard(
                            title: 'Total Contributed',
                            value: 'KES ${_formatNumber(_projected!['totalContributed'])}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SmallResultCard(
                            title: 'Investment Growth',
                            value: 'KES ${_formatNumber(_projected!['futureValue'] - _projected!['totalContributed'])}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ProgressCard(
                      progress: min(1.0, _projected!['futureValue'] / 5000000),
                      goalAmount: 5000000,
                      currentAmount: _projected!['futureValue'],
                    ),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 48,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Enter your details and click Calculate\nto see your projection',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int amount;

  const _GoalCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
  });

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'KES ${_formatNumber(amount)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Target amount',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Gradient gradient;
  final Color textColor;

  const _ResultCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallResultCard extends StatelessWidget {
  final String title;
  final String value;

  const _SmallResultCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final int goalAmount;
  final int currentAmount;

  const _ProgressCard({
    required this.progress,
    required this.goalAmount,
    required this.currentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retirement Readiness',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% towards KES 5M goal',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}