import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../accounts/presentation/providers/account_provider.dart';
import '../../../accounts/presentation/widgets/deposit_modal.dart';
import '../../../../shared/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    // Load accounts when entering payments screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          if (provider.status == AccountStatus.loading && !provider.hasAccounts) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == AccountStatus.error && !provider.hasAccounts) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.errorMessage ?? 'Failed to load accounts'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => provider.fetchAccounts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final accounts = provider.accounts;

          if (accounts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No pension accounts found. Create or activate an account to start contributing.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchAccounts(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchAccounts(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.accountType,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  account.accountNumber,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Balance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Text('KES ${account.currentBalance.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Navigate to contribution screen for this account
                                  context.push('${RouteNames.addContribution}/${account.id}');
                                },
                                child: const Text('Contribute'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Show deposit modal
                                  showDialog(
                                    context: context,
                                    builder: (_) => DepositModal(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                child: const Text('Deposit'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Open bank details screen for this account
                                  context.push('${RouteNames.bankDetails}/${account.id}');
                                },
                                icon: const Icon(Icons.account_balance, size: 18),
                                label: const Text('Bank Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
