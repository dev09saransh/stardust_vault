import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_password_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme.dart';

import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_password_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme.dart';
import '../../services/password_service.dart';

class PasswordsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isGuest;
  const PasswordsScreen({super.key, this.onBack, this.isGuest = false});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final PasswordService _passwordService = PasswordService();
  List<Map<String, dynamic>> _passwords = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _fetchPasswords();
    }
  }

  Future<void> _fetchPasswords() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final passwords = await _passwordService.getPasswords();
      setState(() {
        _passwords = passwords;
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

  void _addPassword() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddPasswordSheet(onAdd: (site, username, pass) async {
        try {
          await _passwordService.addPassword({
            'service_name': site,
            'username': username,
            'password': pass,
          });
          _fetchPasswords();
          if (mounted) SuccessAnimationOverlay.show(context);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save password: $e'), backgroundColor: Colors.redAccent),
            );
          }
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)))
                        : _passwords.isEmpty
                            ? _emptyState()
                            : RefreshIndicator(
                                onRefresh: _fetchPasswords,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(AppSpacing.edge),
                                  itemCount: _passwords.length,
                                  itemBuilder: (context, index) {
                                    final p = _passwords[index];
                                    return FadeInUp(
                                      duration: const Duration(milliseconds: 400),
                                      delay: Duration(milliseconds: index * 100),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                                        child: GlassCard(
                                          padding: const EdgeInsets.all(AppSpacing.medium),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(AppSpacing.medium - 4),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.lock_person_rounded,
                                                  color: theme.colorScheme.primary,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: AppSpacing.medium),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(p['service_name'] ?? 'Unknown',
                                                        style: theme.textTheme.titleLarge),
                                                    const SizedBox(height: 2),
                                                    Text(p['username'] ?? 'No Username',
                                                        style: theme.textTheme.bodySmall),
                                                  ],
                                                ),
                                              ),
                                              Icon(Icons.visibility_off_outlined,
                                                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                                  size: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPassword,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.edge),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: theme.colorScheme.onSurface, size: isMobile ? 20 : 24),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.small),
          Text('Passwords',
              style: isMobile ? theme.textTheme.headlineMedium : theme.textTheme.headlineLarge),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.medium),
          Text('No passwords saved',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
          if (!widget.isGuest) ...[
            const SizedBox(height: AppSpacing.medium),
            TextButton(onPressed: _fetchPasswords, child: const Text('Refresh')),
          ],
        ],
      ),
    );
  }
}
}
