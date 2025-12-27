// lib/features/pension_plans/presentation/screens/pension_plans_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class PensionPlansScreen extends StatefulWidget {
  const PensionPlansScreen({super.key});

  @override
  State<PensionPlansScreen> createState() => _PensionPlansScreenState();
}

class _PensionPlansScreenState extends State<PensionPlansScreen> {
  bool _isAddingPlan = false;

  // Mock data - replace with real data from backend
  final List<Map<String, dynamic>> _myPlans = [
    {
      'id': 1,
      'name': 'Growth Pension',
      'balance': 548000.0,
      'contribution': 33000.0,
      'performance': 12.5,
      'manager': 'Equity Partners Ltd',
    },
    {
      'id': 2,
      'name': 'Balanced Pension',
      'balance': 325000.0,
      'contribution': 22000.0,
      'performance': 8.2,
      'manager': 'Asset Managers Kenya',
    },
    {
      'id': 3,
      'name': 'Conservative Pension',
      'balance': 215000.0,
      'contribution': 15000.0,
      'performance': 5.1,
      'manager': 'Fixed Income Fund',
    },
  ];

  final List<Map<String, dynamic>> _availablePlans = [
    {
      'id': 4,
      'name': 'Tech Innovation Fund',
      'minContribution': 5000.0,
      'expectedReturn': '14-18%',
      'risk': 'High',
      'icon': Icons.bolt,
    },
    {
      'id': 5,
      'name': 'Real Estate Growth',
      'minContribution': 10000.0,
      'expectedReturn': '9-12%',
      'risk': 'Medium',
      'icon': Icons.trending_up,
    },
    {
      'id': 6,
      'name': 'Bond Security Fund',
      'minContribution': 3000.0,
      'expectedReturn': '5-7%',
      'risk': 'Low',
      'icon': Icons.shield,
    },
    {
      'id': 7,
      'name': 'Mixed Portfolio',
      'minContribution': 8000.0,
      'expectedReturn': '8-11%',
      'risk': 'Medium',
      'icon': Icons.lock,
    },
  ];

  Future<void> _handleAddPlan(int planId) async {
    setState(() => _isAddingPlan = true);
    
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted) {
      setState(() => _isAddingPlan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan added to your portfolio'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Pension Plans'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Manage your active plans and explore new investment opportunities.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // My Active Plans Section
              const Text(
                'Your Active Plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              ..._myPlans.map((plan) => _MyPlanCard(
                    plan: plan,
                    onTap: () {
                      // TODO: Navigate to plan details
                    },
                  )),

              const SizedBox(height: 32),

              // Available Plans Section
              const Text(
                'Explore & Add Plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              ..._availablePlans.map((plan) => _AvailablePlanCard(
                    plan: plan,
                    isAdding: _isAddingPlan,
                    getRiskColor: _getRiskColor,
                    onAddPlan: () => _handleAddPlan(plan['id']),
                  )),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onTap;

  const _MyPlanCard({
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                plan['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                plan['manager'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KES ${plan['balance'].toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Monthly contribution and performance
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Contribution',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KES ${plan['contribution'].toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YTD Performance',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+${plan['performance']}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // View Details Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailablePlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final bool isAdding;
  final Color Function(String) getRiskColor;
  final VoidCallback onAddPlan;

  const _AvailablePlanCard({
    required this.plan,
    required this.isAdding,
    required this.getRiskColor,
    required this.onAddPlan,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = plan['icon'] as IconData;
    final riskColor = getRiskColor(plan['risk']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Show plan details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    iconData,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Expected Return
              Row(
                children: [
                  Text(
                    'Expected Return: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    plan['expectedReturn'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Min Contribution
              Row(
                children: [
                  Text(
                    'Min. Contribution: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'KES ${plan['minContribution'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Risk badge and Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${plan['risk']} Risk',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: riskColor,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isAdding ? null : onAddPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isAdding ? 'Adding...' : 'Add Plan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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