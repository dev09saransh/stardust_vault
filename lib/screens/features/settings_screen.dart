import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _sectionHeader('Profile'),
                    _settingsTile(Icons.person_outline_rounded, 'Account Details', 'Guest User'),
                    _settingsTile(Icons.alternate_email_rounded, 'Email Address', 'guest@example.com'),
                    const SizedBox(height: 24),
                    _sectionHeader('Security'),
                    _settingsTile(Icons.fingerprint_rounded, 'Biometric Lock', 'Enabled', toggle: true),
                    _settingsTile(Icons.two_factor_authentication_rounded, 'Two-Factor Auth', 'Enabled'),
                    _settingsTile(Icons.key_rounded, 'Change Password', ''),
                    const SizedBox(height: 24),
                    _sectionHeader('Preferences'),
                    _settingsTile(Icons.notifications_none_rounded, 'Notifications', 'On', toggle: true),
                    _settingsTile(Icons.language_rounded, 'Language', 'English'),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
                      child: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.silverMist),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text('Settings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.platinum)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.lavenderAccent,
              letterSpacing: 1)),
    );
  }

  Widget _settingsTile(IconData icon, String title, String value, {bool toggle = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.silverMist, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.platinum,
                      fontWeight: FontWeight.w400)),
            ),
            if (toggle)
              Switch(value: true, onChanged: (_) {}, activeColor: AppTheme.lavenderAccent)
            else if (value.isNotEmpty)
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.silverMist.withValues(alpha: 0.6))),
            if (!toggle) const SizedBox(width: 8),
            if (!toggle)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppTheme.silverMist.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
