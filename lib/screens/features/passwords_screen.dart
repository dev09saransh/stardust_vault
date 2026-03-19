import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../theme.dart';

class PasswordsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const PasswordsScreen({super.key, this.onBack});

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final List<Map<String, String>> _passwords = [
    {'site': 'Google', 'username': 'user@gmail.com', 'pass': '••••••••'},
    {'site': 'Amazon', 'username': 'user_shop', 'pass': '••••••••'},
  ];

  void _addPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddPasswordSheet(onAdd: (site, username, pass) {
        setState(() {
          _passwords.add({'site': site, 'username': username, 'pass': pass});
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: _passwords.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _passwords.length,
                        itemBuilder: (context, index) {
                          final p = _passwords[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lavenderAccent
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.lock_person_rounded,
                                      color: AppTheme.lavenderAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(p['site']!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.platinum)),
                                        Text(p['username']!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.silverMist
                                                    .withValues(alpha: 0.5))),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.visibility_off_outlined,
                                      color: AppTheme.silverMist, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPassword,
        backgroundColor: AppTheme.lavenderAccent,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppTheme.silverMist),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text('Passwords',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.platinum)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 80, color: AppTheme.silverMist.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No passwords saved',
              style: TextStyle(
                  color: AppTheme.silverMist.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}

class _AddPasswordSheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  const _AddPasswordSheet({required this.onAdd});

  @override
  State<_AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<_AddPasswordSheet> {
  final _siteController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 100),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Save Password',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 24),
          TextField(
            controller: _siteController,
            decoration: const InputDecoration(labelText: 'Website / App'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _userController,
            decoration: const InputDecoration(labelText: 'Username / Email'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Save Password',
            onPressed: () {
              if (_siteController.text.isNotEmpty) {
                widget.onAdd(_siteController.text, _userController.text, _passController.text);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
