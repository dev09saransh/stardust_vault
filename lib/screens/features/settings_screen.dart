import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../theme.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const SettingsScreen({super.key, this.onBack});

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
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.edge),
                  children: [
                    _sectionHeader(context, 'Profile'),
                    _settingsTile(context, Icons.person_outline_rounded, 'Account Details', 'Guest User'),
                    _settingsTile(context, Icons.alternate_email_rounded, 'Email Address', 'guest@example.com'),
                    const SizedBox(height: AppSpacing.large),
                    _sectionHeader(context, 'Security'),
                    _settingsTile(context, Icons.fingerprint_rounded, 'Biometric Lock', 'Enabled', toggle: true),
                    _settingsTile(context, Icons.verified_user_rounded, 'Two-Factor Auth', 'Enabled'),
                    _settingsTile(context, Icons.key_rounded, 'Change Password', ''),
                    const SizedBox(height: AppSpacing.large),
                    _sectionHeader(context, 'Preferences'),
                    _settingsTile(context, Icons.notifications_none_rounded, 'Notifications', 'On', toggle: true),
                    _settingsTile(context, Icons.language_rounded, 'Language', 'English'),
                    const SizedBox(height: AppSpacing.huge),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
                      child: Text('Log Out', style: theme.textTheme.labelLarge?.copyWith(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                color: theme.colorScheme.onSurface,
                size: isMobile ? 20 : 24),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.small),
          Text('Settings',
              style: isMobile ? theme.textTheme.headlineMedium : theme.textTheme.headlineLarge),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.small),
      child: Text(title,
          style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
              letterSpacing: 1.5,
              fontSize: 10)),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String value, {bool toggle = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.medium - 2),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), size: 22),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Text(title,
                  style: theme.textTheme.bodyLarge),
            ),
            if (toggle)
              Switch(value: true, onChanged: (_) {}, activeThumbImage: null, activeThumbColor: theme.colorScheme.primary)
            else if (value.isNotEmpty)
              Text(value,
                  style: theme.textTheme.bodySmall),
            if (!toggle) const SizedBox(width: AppSpacing.small),
            if (!toggle)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
