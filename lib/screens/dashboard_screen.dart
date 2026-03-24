import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glass_card.dart';
import '../theme.dart';
import 'features/assets_screen.dart';
import 'features/insurance_screen.dart';
import 'features/passwords_screen.dart';
import 'features/contacts_screen.dart';
import 'features/legal_center_screen.dart';
import 'features/settings_screen.dart';
import 'features/security_log_screen.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/glowing_text.dart';
import '../widgets/intro_modal.dart';
import '../widgets/guided_tour.dart';
import '../widgets/add_asset_sheet.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/success_animation.dart';
import '../widgets/login_prompt.dart';

class DashboardScreen extends StatefulWidget {
  final bool isGuest;
  final bool isLogin; // true if login, false if signup

  const DashboardScreen({
    super.key,
    this.isGuest = true,
    this.isLogin = true,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Centralized State
  final List<Map<String, String>> _assets = [
    {'name': 'Bitcoin Wallet', 'value': '0.5 BTC', 'type': 'Digital'},
    {'name': 'Safe Deposit Box', 'value': 'Key #123', 'type': 'Physical'},
  ];
  final List<Map<String, String>> _policies = [
    {'provider': 'Star Health', 'policyNo': 'POL-8822', 'type': 'Health'},
    {'provider': 'Liberty General', 'policyNo': 'VEH-9933', 'type': 'Vehicle'},
  ];
  final List<Map<String, String>> _passwords = [
    {'site': 'Google', 'username': 'user@gmail.com', 'pass': '••••••••'},
    {'site': 'Amazon', 'username': 'user_shop', 'pass': '••••••••'},
  ];
  final List<Map<String, String>> _contacts = [
    {'name': 'John Doe', 'relation': 'Brother', 'status': 'Verified'},
    {'name': 'Jane Smith', 'relation': 'Spouse', 'status': 'Pending'},
  ];
  final List<Map<String, String>> _docs = [
    {'title': 'Will & Testament', 'date': '2025-10-12', 'status': 'Signed'},
    {'title': 'Property Deed', 'date': '2024-05-20', 'status': 'Vaulted'},
  ];

  bool _showIntro = true;
  bool _showTour = false;
  bool _showCatalog = false;

  static const _menuItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Assets'},
    {'icon': Icons.health_and_safety_rounded, 'label': 'Insurance'},
    {'icon': Icons.lock_rounded, 'label': 'Passwords'},
    {'icon': Icons.gavel_rounded, 'label': 'Legal Center'},
    {'icon': Icons.contacts_rounded, 'label': 'Contacts'},
    {'icon': Icons.security_rounded, 'label': 'Security Log'},
  ];

  @override
  void initState() {
    super.initState();
    _showIntro = widget.isGuest; // Guest still gets intro modal
    // Auto-start tour for Signup
    if (!widget.isGuest && !widget.isLogin) {
      _showTour = true;
    }
  }

  void _onMenuItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showLoginRequiredPrompt() {
    LoginRequiredPrompt.show(context);
  }

  void _showAddAssetSheet() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddAssetSheet(onAdd: (name, value, type) {
        setState(() {
          _assets.add({'name': name, 'value': value, 'type': type});
        });
        SuccessAnimationOverlay.show(context);
      }),
    );
  }

  void _showAddNomineeSheet() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddContactSheet(onAdd: (name, relation) {
        setState(() {
          _contacts.add({'name': name, 'relation': relation, 'status': 'Pending'});
        });
        SuccessAnimationOverlay.show(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: _sidebarContent(),
            ),
      body: StardustBackground(
        child: Stack(
          children: [
            Row(
              children: [
                if (isWide) _sidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _appBar(isWide),
                      Expanded(child: _mainContentArea(context, isWide)),
                    ],
                  ),
                ),
              ],
            ),
            if (_showIntro)
              IntroModal(
                onFinish: () {
                  setState(() {
                    _showIntro = false;
                    _showTour = true;
                  });
                },
              ),
            if (_showTour)
              GuidedTour(
                onStepChange: (index) {
                  final targetIndex = [
                    0, // Overview
                    1, // Assets
                    2, // Insurance
                    3, // Passwords
                    4, // Legal Center
                    5, // Contacts
                    6, // Security Log
                  ][index];
                  setState(() => _selectedIndex = targetIndex);
                },
                steps: [
                  TourStep(
                    title: 'Welcome to your Dashboard',
                    description: 'This is your central command center for all your secure information.',
                    icon: Icons.dashboard_rounded,
                  ),
                  TourStep(
                    title: 'Secure Asset Management',
                    description: 'Manage all your digital and physical assets, including Real Estate, Banking, and Crypto.',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  TourStep(
                    title: 'Insurance Policies',
                    description: 'Keep track of all your health, vehicle, and life insurance policies in one place.',
                    icon: Icons.health_and_safety_rounded,
                  ),
                  TourStep(
                    title: 'Password Vault',
                    description: 'Store and organize your sensitive login credentials with military-grade encryption.',
                    icon: Icons.lock_rounded,
                  ),
                  TourStep(
                    title: 'Legal documents',
                    description: 'Securely store and share wills, property deeds, and other critical legal records.',
                    icon: Icons.gavel_rounded,
                  ),
                  TourStep(
                    title: 'Trusted Contacts',
                    description: 'Designate nominees and emergency contacts who can access your vault when needed.',
                    icon: Icons.contacts_rounded,
                  ),
                  TourStep(
                    title: 'Real-time Security Log',
                    description: 'Monitor all access attempts and security events to keep your data safe.',
                    icon: Icons.security_rounded,
                  ),
                ],
                onFinish: () {
                  setState(() {
                    _showTour = false;
                    _selectedIndex = 0;
                  });
                },
              ),
            if (_showCatalog)
              _catalogOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _catalogOverlay() {
    final categories = [
      {'label': 'Real Estate', 'icon': Icons.home_work_outlined, 'color': Colors.blue},
      {'label': 'Bank Accounts', 'icon': Icons.account_balance_outlined, 'color': Colors.green},
      {'label': 'Investments', 'icon': Icons.trending_up_rounded, 'color': Colors.orange},
      {'label': 'Insurance', 'icon': Icons.security_outlined, 'color': Colors.red},
      {'label': 'Passwords', 'icon': Icons.password_outlined, 'color': Colors.teal},
      {'label': 'Legal Docs', 'icon': Icons.gavel_outlined, 'color': Colors.purple},
      {'label': 'Contacts', 'icon': Icons.people_outline, 'color': Colors.indigo},
      {'label': 'Settings', 'icon': Icons.settings_outlined, 'color': Colors.grey},
    ];

    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: const Text('Asset Catalog', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 40),
            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: InkWell(
                      onTap: () => setState(() => _showCatalog = false),
                      child: GlassCard(
                        width: 160,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 32),
                            const SizedBox(height: 12),
                            Text(cat['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 48),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _actionButton(
                label: 'Close Catalog',
                icon: Icons.close_rounded,
                onPressed: () => setState(() => _showCatalog = false),
                isPrimary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sidebar & Navigation ───
  Widget _sidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? const Color(0xFF0D0D19) 
            : Colors.white,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: _sidebarContent(),
    );
  }

  Widget _sidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _logoIcon(),
              const SizedBox(width: 12),
              Text('STARDUST',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
        const SizedBox(height: 48),
        _sectionLabel('CORE VAULT'),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              return _SidebarTile(
                icon: item['icon'] as IconData,
                label: item['label'] as String,
                selected: _selectedIndex == index,
                onTap: () => _onMenuItemSelected(index),
              );
            },
          ),
        ),
        _sectionLabel('PREFERENCES'),
        const SizedBox(height: 16),
        if (widget.isGuest) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _authButton(
              icon: Icons.login_rounded,
              label: 'Sign In',
              onPressed: () => Navigator.pushNamed(context, '/auth'),
              isPrimary: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _authButton(
              icon: Icons.person_add_rounded,
              label: 'Create Account',
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              isPrimary: true,
            ),
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _logoIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.shield_rounded, color: Theme.of(context).colorScheme.primary, size: 24),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _authButton({required IconData icon, required String label, required VoidCallback onPressed, required bool isPrimary}) {
    final color = isPrimary ? Theme.of(context).colorScheme.primary : Colors.transparent;
    final onColor = isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final borderColor = isPrimary ? Colors.transparent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: onColor, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: onColor, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _appBar(bool isWide) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          if (!isWide)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          const Spacer(),
          _themeToggle(),
          const SizedBox(width: 20),
          _userProfile(),
          const SizedBox(width: 20),
          _actionButton(
            label: 'Add Nominee',
            onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddNomineeSheet(),
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          _actionButton(
            label: 'Add New Resource',
            icon: Icons.add,
            onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddAssetSheet(),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _themeToggle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark 
            ? Colors.black.withValues(alpha: 0.3) 
            : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lavenderAccent.withValues(alpha: isDark ? 0.3 : 0.8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lavenderAccent.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
          color: AppTheme.lavenderAccent,
          size: 22,
        ),
      ),
    );
  }

  Widget _userProfile() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.isGuest ? 'Guest' : 'User',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            Text(widget.isGuest ? 'GUEST' : 'PREMIUM',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, letterSpacing: 1)),
          ],
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(widget.isGuest ? 'G' : 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _actionButton({required String label, IconData? icon, required VoidCallback onPressed, required bool isPrimary}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        foregroundColor: isPrimary ? Colors.white : Theme.of(context).colorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _mainContentArea(BuildContext context, bool isWide) {
    // Filter screens
    final screens = [
      _dashboardHome(context, isWide),
      AssetsScreen(assets: _assets, onBack: () => setState(() => _selectedIndex = 0), isGuest: widget.isGuest),
      InsuranceScreen(policies: _policies, onBack: () => setState(() => _selectedIndex = 0), isGuest: widget.isGuest),
      PasswordsScreen(passwords: _passwords, onBack: () => setState(() => _selectedIndex = 0), isGuest: widget.isGuest),
      LegalCenterScreen(docs: _docs, onBack: () => setState(() => _selectedIndex = 0), isGuest: widget.isGuest),
      ContactsScreen(contacts: _contacts, onBack: () => setState(() => _selectedIndex = 0), isGuest: widget.isGuest),
      SecurityLogScreen(),
    ];

    return screens[_selectedIndex];
  }

  Widget _dashboardHome(BuildContext context, bool isWide) {
    final welcomeMsg = widget.isGuest 
        ? 'Welcome' 
        : (widget.isLogin ? 'Welcome back 👋' : 'Welcome 👋');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: GlowingText(welcomeMsg,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ),
                  const SizedBox(height: 8),
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                    child: Text('Monitor your global asset health and security status.',
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                  ),
                ],
              ),
              const Spacer(),
              if (!widget.isGuest && widget.isLogin)
                FadeInRight(
                  duration: const Duration(milliseconds: 600),
                  child: _actionButton(
                    label: 'Start Tour',
                    icon: Icons.play_circle_outline_rounded,
                    onPressed: () => setState(() => _showTour = true),
                    isPrimary: false,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 48),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
            child: _premiumHeroCard(),
          ),
          const SizedBox(height: 48),
          _sectionLabel('CORE VAULT FEATURES'),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: isWide ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.4,
            children: [
              _featureGridCard('Assets', 'Digital & Physical', Icons.account_balance_wallet_outlined, 0, () => _onMenuItemSelected(1)),
              _featureGridCard('Insurance', 'Policies & Claims', Icons.security_outlined, 1, () => _onMenuItemSelected(2)),
              _featureGridCard('Passwords', 'Secure Vault', Icons.password_outlined, 2, () => _onMenuItemSelected(3)),
              _featureGridCard('Contacts', 'Trusted Nominees', Icons.people_outline, 3, () => _onMenuItemSelected(5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureGridCard(String title, String subtitle, IconData icon, int index, VoidCallback onTap) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: 300 + (index * 100)),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            const SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }

  Widget _premiumHeroCard() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _heroIcon(),
              const SizedBox(height: 40),
              Text(
                'Your Digital Legacy, Secured.',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Stardust. The most private and secure way to catalog your wealth, store your sensitive documents, and ensure your family has everything they need when it matters most.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _heroActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: Icon(Icons.shield_rounded, size: 48, color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _heroActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _heroButton(
          label: 'Add First Asset',
          icon: Icons.add,
          onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddAssetSheet(),
          isPrimary: true,
        ),
        const SizedBox(width: 16),
        _heroButton(
          label: 'Add Nominee',
          icon: Icons.person_add_outlined,
          onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddNomineeSheet(),
          isPrimary: false,
        ),
        const SizedBox(width: 16),
        _heroButton(
          label: 'View Catalog',
          onPressed: () => setState(() => _showCatalog = true),
          isPrimary: false,
          isGhost: true,
        ),
      ],
    );
  }

  Widget _heroButton({required String label, IconData? icon, required VoidCallback onPressed, required bool isPrimary, bool isGhost = false}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary 
                ? Theme.of(context).colorScheme.primary 
                : (isGhost ? Colors.transparent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(12),
            border: isGhost ? Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)) : null,
            boxShadow: isPrimary ? [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, color: isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface, size: 18), const SizedBox(width: 8)],
              Text(label, style: TextStyle(
                color: isPrimary ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected;
    final active = isSelected || _isHovering;
    final color = active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: isSelected ? Colors.white : color, size: 20),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (active ? Theme.of(context).colorScheme.onSurface : color),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
