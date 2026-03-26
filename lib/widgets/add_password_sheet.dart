import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'gradient_button.dart';
import '../theme.dart';

class AddPasswordSheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  const AddPasswordSheet({super.key, required this.onAdd});

  @override
  State<AddPasswordSheet> createState() => _AddPasswordSheetState();
}

class _AddPasswordSheetState extends State<AddPasswordSheet> {
  final _siteController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      margin: EdgeInsets.fromLTRB(
          AppSpacing.medium,
          100,
          AppSpacing.medium,
          MediaQuery.sizeOf(context).viewInsets.bottom + AppSpacing.xlarge),
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Save Password',
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.large),
          TextField(
            controller: _siteController,
            decoration: const InputDecoration(labelText: 'Website / App'),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextField(
            controller: _userController,
            decoration: const InputDecoration(labelText: 'Username / Email'),
          ),
          const SizedBox(height: AppSpacing.medium),
          TextField(
            controller: _passController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: AppSpacing.xlarge),
          GradientButton(
            text: 'Save Password',
            onPressed: () {
              if (_siteController.text.isNotEmpty) {
                widget.onAdd(_siteController.text, _userController.text, _passController.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
