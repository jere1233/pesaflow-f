import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class RecentDepositsScreen extends StatefulWidget {
  const RecentDepositsScreen({super.key});

  @override
  State<RecentDepositsScreen> createState() => _RecentDepositsScreenState();
}

class _RecentDepositsScreenState extends State<RecentDepositsScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _loading = true;
  String? _error;
  List<dynamic> _deposits = [];

  @override
  void initState() {
    super.initState();
    _loadRecentDeposits();
  }

  Future<void> _loadRecentDeposits() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final resp = await _apiClient.get(ApiConstants.userRecentDeposits);
      if (resp.statusCode == 200) {
        final data = resp.data;
        if (data is Map<String, dynamic>) {
          _deposits = data['transactions'] ?? data['data'] ?? [];
        } else if (data is List) {
          _deposits = data;
        } else {
          _deposits = [];
        }
      } else {
        _error = 'Failed to load recent deposits';
      }
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Deposits')),
      body: RefreshIndicator(
        onRefresh: _loadRecentDeposits,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(_error ?? 'Unknown error'),
                            const SizedBox(height: 12),
                            ElevatedButton(onPressed: _loadRecentDeposits, child: const Text('Retry')),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _deposits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tx = _deposits[index] as Map<String, dynamic>;
                      final amount = tx['amount'] ?? tx['value'] ?? 0;
                      final createdAt = tx['createdAt'] ?? tx['timestamp'] ?? '';
                      final status = tx['status'] ?? '';
                      return ListTile(
                        title: Text('KES ${amount.toString()}'),
                        subtitle: Text('$createdAt • ${tx['description'] ?? ''}'),
                        trailing: Text(status.toString()),
                      );
                    },
                  ),
      ),
    );
  }
}
