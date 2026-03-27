import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../theme.dart';
import 'package:animate_do/animate_do.dart';
import '../../services/security_service.dart';

class SecurityLogScreen extends StatefulWidget {
  const SecurityLogScreen({super.key});

  @override
  State<SecurityLogScreen> createState() => _SecurityLogScreenState();
}

class _SecurityLogScreenState extends State<SecurityLogScreen> {
  final SecurityService _securityService = SecurityService();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final logs = await _securityService.getLogs();
      setState(() {
        _logs = logs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.edge),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () => Navigator.pop(context),
                      iconSize: isMobile ? 20 : 24,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      'Security Log',
                      style: isMobile ? theme.textTheme.headlineMedium : theme.textTheme.headlineLarge,
                    ),
                    const Spacer(),
                    if (!_isLoading)
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: _fetchLogs,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)))
                        : FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: RefreshIndicator(
                              onRefresh: _fetchLogs,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.edge),
                                child: GlassCard(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.medium),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: theme.dividerColor.withValues(alpha: 0.1),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(flex: 2, child: Text('EVENT', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold))),
                                            Expanded(flex: 2, child: Text('IP ADDRESS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold))),
                                            Expanded(flex: 2, child: Text('TIMESTAMP', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold))),
                                          ],
                                        ),
                                      ),
                                      if (_logs.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(AppSpacing.huge),
                                          child: Text('No security events logged yet.', style: theme.textTheme.bodySmall),
                                        )
                                      else
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: _logs.length,
                                          separatorBuilder: (context, index) => Divider(
                                            height: 1,
                                            color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
                                          ),
                                          itemBuilder: (context, index) {
                                            final log = _logs[index];
                                            final date = log['created_at'] != null 
                                                ? log['created_at'].toString().split('T')[0] + ' ' + 
                                                  log['created_at'].toString().split('T')[1].substring(0, 5)
                                                : 'Recently';
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.medium),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      log['event_type'] ?? 'Unknown Event',
                                                      style: theme.textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      log['ip_address'] ?? 'N/A',
                                                      style: theme.textTheme.bodySmall,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      date,
                                                      style: theme.textTheme.bodySmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
