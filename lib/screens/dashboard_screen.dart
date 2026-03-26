import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../main.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glass_card.dart';
import '../theme.dart';
import 'features/assets_screen.dart';
import 'features/insurance_screen.dart';
import 'features/passwords_screen.dart';
import 'features/contacts_screen.dart';
import 'features/legal_center_screen.dart';
import 'features/security_log_screen.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/glowing_text.dart';
import '../widgets/intro_modal.dart';
import '../widgets/guided_tour.dart';
import '../widgets/add_asset_sheet.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/add_doc_sheet.dart';
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
    {'name': 'John Doe', 'relation': 'Brother', 'phone': '+91 98765 43210', 'status': 'Verified'},
    {'name': 'Jane Smith', 'relation': 'Spouse', 'phone': '+91 91234 56789', 'status': 'Pending'},
  ];
  final List<Map<String, String>> _docs = [
    {'title': 'Will & Testament', 'date': '2025-10-12', 'status': 'Signed'},
    {'title': 'Property Deed', 'date': '2024-05-20', 'status': 'Vaulted'},
  ];

  bool _showIntro = true;
  bool _showTour = false;
  bool _showCatalog = false;
  bool _showDocumentCatalog = false;

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
      builder: (sheetContext) => AddContactSheet(onAdd: (name, relation, phone) {
        setState(() {
          _contacts.add({'name': name, 'relation': relation, 'phone': phone, 'status': 'Pending'});
        });
        SuccessAnimationOverlay.show(context);
      }),
    );
  }

  void _showAddDocSheet(String type) {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddDocSheet(
        type: type,
        onAdd: (title) {
          setState(() {
            _docs.add({
              'title': title,
              'date': DateTime.now().toString().split(' ')[0],
              'status': 'Vaulted'
            });
          });
          SuccessAnimationOverlay.show(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;

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
            if (_showDocumentCatalog)
              _documentCatalogOverlay(),
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark 
        ? Colors.black.withValues(alpha: 0.4) 
        : Colors.white.withValues(alpha: 0.2);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Positioned.fill(
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () => setState(() => _showCatalog = false),
          child: Container(
            color: bgColor,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when clicking inside
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        FadeInDown(
                          child: Text('Asset Catalog', 
                            style: theme.textTheme.displayLarge),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        FadeInDown(
                          delay: const Duration(milliseconds: 100),
                          child: Text('Explore your vault categories', 
                            style: theme.textTheme.bodyLarge?.copyWith(color: textColor.withValues(alpha: 0.6))),
                        ),
                        const SizedBox(height: AppSpacing.huge),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
                          child: Wrap(
                            spacing: AppSpacing.large,
                            runSpacing: AppSpacing.large,
                            alignment: WrapAlignment.center,
                            children: List.generate(categories.length, (index) {
                              final cat = categories[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 150 + (index * 50)),
                                child: InkWell(
                                  onTap: () => setState(() => _showCatalog = false),
                                  borderRadius: BorderRadius.circular(24),
                                  child: GlassCard(
                                    width: 180,
                                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xlarge, horizontal: AppSpacing.medium),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppSpacing.medium),
                                          decoration: BoxDecoration(
                                            color: (cat['color'] as Color).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: (cat['color'] as Color).withValues(alpha: 0.2)),
                                          ),
                                          child: Icon(cat['icon'] as IconData, 
                                            color: cat['color'] as Color, 
                                            size: 32),
                                        ),
                                        const SizedBox(height: AppSpacing.medium),
                                        Text(cat['label'] as String, 
                                          style: theme.textTheme.titleLarge),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.huge),
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: _actionButton(
                            label: 'Close Catalog',
                            icon: Icons.close_rounded,
                            onPressed: () => setState(() => _showCatalog = false),
                            isPrimary: true,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _documentCatalogOverlay() {
    final docTypes = [
      {'label': 'Assets', 'icon': Icons.account_balance_wallet_outlined, 'color': Colors.blue},
      {'label': 'Insurance', 'icon': Icons.health_and_safety_outlined, 'color': Colors.red},
      {'label': 'Legal', 'icon': Icons.gavel_outlined, 'color': Colors.purple},
      {'label': 'Identity', 'icon': Icons.badge_outlined, 'color': Colors.orange},
      {'label': 'Medical', 'icon': Icons.medical_services_outlined, 'color': Colors.green},
      {'label': 'Passwords', 'icon': Icons.password_outlined, 'color': Colors.teal},
      {'label': 'Finance', 'icon': Icons.attach_money_rounded, 'color': Colors.indigo},
      {'label': 'Others', 'icon': Icons.more_horiz_rounded, 'color': Colors.grey},
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark 
        ? Colors.black.withValues(alpha: 0.4) 
        : Colors.white.withValues(alpha: 0.2);
    final textColor = theme.colorScheme.onSurface;

    return Positioned.fill(
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: () => setState(() => _showDocumentCatalog = false),
          child: Container(
            color: bgColor,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.edge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacing.huge),
                        FadeInDown(
                          child: Text('Select Document Type', 
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        FadeInDown(
                          delay: const Duration(milliseconds: 100),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
                            child: Text('What type of document would you like to scan or upload?', 
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(color: textColor.withValues(alpha: 0.6))),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.huge),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
                          child: Wrap(
                            spacing: AppSpacing.large,
                            runSpacing: AppSpacing.large,
                            alignment: WrapAlignment.center,
                            children: List.generate(docTypes.length, (index) {
                              final type = docTypes[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: 150 + (index * 50)),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => _showDocumentCatalog = false);
                                    _showAddDocSheet(type['label'] as String);
                                  },
                                  borderRadius: BorderRadius.circular(24),
                                  child: GlassCard(
                                    width: 180,
                                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xlarge, horizontal: AppSpacing.medium),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(AppSpacing.medium),
                                          decoration: BoxDecoration(
                                            color: (type['color'] as Color).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: (type['color'] as Color).withValues(alpha: 0.2)),
                                          ),
                                          child: Icon(type['icon'] as IconData, 
                                            color: type['color'] as Color, 
                                            size: 32),
                                        ),
                                        const SizedBox(height: AppSpacing.medium),
                                        Text(type['label'] as String, 
                                          style: theme.textTheme.titleLarge),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.huge),
                        FadeInUp(
                          delay: const Duration(milliseconds: 800),
                          child: _actionButton(
                            label: 'Cancel',
                            icon: Icons.close_rounded,
                            onPressed: () => setState(() => _showDocumentCatalog = false),
                            isPrimary: true,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.huge),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
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
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: AppSpacing.huge),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          child: Row(
            children: [
              _logoIcon(),
              const SizedBox(width: AppSpacing.medium),
              Text('STARDUST',
                  style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 2)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.huge),
        _sectionLabel('CORE VAULT'),
        const SizedBox(height: AppSpacing.medium),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlarge),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            letterSpacing: 1.5,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 10,
            fontWeight: FontWeight.w900,
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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isVeryNarrow = screenWidth < 450;
    final horizontalPadding = isVeryNarrow ? AppSpacing.medium : AppSpacing.large;

    return Container(
      padding: EdgeInsets.fromLTRB(horizontalPadding, AppSpacing.medium, horizontalPadding, AppSpacing.medium),
      child: Row(
        children: [
          if (!isWide)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          const Spacer(),
          _themeToggle(),
          SizedBox(width: isVeryNarrow ? 8 : 20),
          _userProfile(isVeryNarrow),
          SizedBox(width: isVeryNarrow ? 8 : 20),
          _actionButton(
            label: isVeryNarrow ? '' : 'Scan',
            icon: Icons.document_scanner_rounded,
            onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : setState(() => _showDocumentCatalog = true),
            isPrimary: true,
          ),
          if (!isVeryNarrow) ...[
            const SizedBox(width: 12),
            _actionButton(
              label: 'Add Resource',
              icon: Icons.add,
              onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddAssetSheet(),
              isPrimary: true,
            ),
          ],
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

  Widget _userProfile(bool isNarrow) {
    return Row(
      children: [
        if (!isNarrow) ...[
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
        ],
        CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(widget.isGuest ? 'G' : 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _actionButton({required String label, IconData? icon, required VoidCallback onPressed, required bool isPrimary, double? width}) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        foregroundColor: isPrimary ? Colors.white : Theme.of(context).colorScheme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 18),
          if (label.isNotEmpty) ...[const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12))],
        ],
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }

  Widget _mainContentArea(BuildContext context, bool isWide) {
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

    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? AppSpacing.huge : AppSpacing.edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: GlowingText(welcomeMsg,
                          style: isWide ? theme.textTheme.displayLarge : theme.textTheme.headlineLarge),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: Text('Monitor your global asset health and security status.',
                          softWrap: true,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                    ),
                  ],
                ),
              ),
              if (isWide && !widget.isGuest && widget.isLogin)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: FadeInRight(
                    duration: const Duration(milliseconds: 600),
                    child: _actionButton(
                      label: 'Start Tour',
                      icon: Icons.play_circle_outline_rounded,
                      onPressed: () => setState(() => _showTour = true),
                      isPrimary: false,
                    ),
                  ),
                ),
            ],
          ),
          if (!isWide && !widget.isGuest && widget.isLogin) ...[
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _actionButton(
                label: 'Start Tour',
                icon: Icons.play_circle_outline_rounded,
                onPressed: () => setState(() => _showTour = true),
                isPrimary: false,
                width: 200,
              ),
            ),
          ],
          SizedBox(height: isWide ? AppSpacing.huge : AppSpacing.xlarge),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
            child: _premiumHeroCard(),
          ),
          const SizedBox(height: AppSpacing.huge),
          _sectionLabel('CORE VAULT FEATURES'),
          const SizedBox(height: AppSpacing.large),
          GridView.count(
            crossAxisCount: isWide ? 4 : (MediaQuery.sizeOf(context).width > 600 ? 2 : 1),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.large,
            mainAxisSpacing: AppSpacing.large,
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
    final theme = Theme.of(context);
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: 300 + (index * 100)),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.tiny),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }

  Widget _premiumHeroCard() {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return GlassCard(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppSpacing.xlarge : AppSpacing.huge * 1.5, 
        horizontal: isMobile ? AppSpacing.large : AppSpacing.huge
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _heroIcon(),
              const SizedBox(height: AppSpacing.huge),
              Text(
                'Your Digital Legacy, Secured.',
                style: isMobile ? theme.textTheme.headlineLarge : theme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                'Welcome to Stardust. The most private and secure way to catalog your wealth, store your sensitive documents, and ensure your family has everything they need when it matters most.',
                style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.huge),
              _heroActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroIcon() {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: Icon(Icons.shield_rounded, size: 48, color: theme.colorScheme.primary),
    );
  }

  Widget _heroActionButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _heroButton(
          label: 'Scan / Upload',
          icon: Icons.document_scanner_rounded,
          onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : setState(() => _showDocumentCatalog = true),
          isPrimary: true,
        ),
        _heroButton(
          label: 'Add Nominee',
          icon: Icons.person_add_outlined,
          onPressed: () => widget.isGuest ? _showLoginRequiredPrompt() : _showAddNomineeSheet(),
          isPrimary: false,
        ),
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
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium, horizontal: AppSpacing.medium),
          decoration: BoxDecoration(
            color: isPrimary 
                ? theme.colorScheme.primary 
                : (isGhost ? Colors.transparent : theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(12),
            border: isGhost ? Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.2), width: 1.5) : null,
            boxShadow: isPrimary ? [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: isPrimary ? Colors.white : theme.colorScheme.primary), const SizedBox(width: AppSpacing.small)],
              Text(label, style: theme.textTheme.labelLarge?.copyWith(color: isPrimary ? Colors.white : theme.colorScheme.onSurface)),
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
    final theme = Theme.of(context);
    final isSelected = widget.selected;
    final active = isSelected || _isHovering;
    final color = active ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.tiny),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.medium - 2),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: isSelected ? Colors.white : color, size: 20),
                const SizedBox(width: AppSpacing.medium),
                Text(
                  widget.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : (active ? theme.colorScheme.onSurface : color.withValues(alpha: theme.brightness == Brightness.dark ? 0.4 : 0.8)),
                    fontWeight: FontWeight.w900,
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
