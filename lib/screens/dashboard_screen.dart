import 'package:flutter/material.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glass_card.dart';
import '../theme.dart';
import 'features/assets_screen.dart';
import 'features/insurance_screen.dart';
import 'features/passwords_screen.dart';
import 'features/contacts_screen.dart';
import 'features/legal_center_screen.dart';
import 'features/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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

  static const _menuItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Assets'},
    {'icon': Icons.health_and_safety_rounded, 'label': 'Insurance'},
    {'icon': Icons.lock_rounded, 'label': 'Passwords'},
    {'icon': Icons.contacts_rounded, 'label': 'Contacts'},
    {'icon': Icons.gavel_rounded, 'label': 'Legal Center'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  static const _gridItems = [
    {
      'icon': Icons.account_balance_wallet_rounded,
      'label': 'Assets',
      'desc': 'Manage your digital & physical assets',
      'color': Color(0xFF7C4DFF)
    },
    {
      'icon': Icons.health_and_safety_rounded,
      'label': 'Insurance',
      'desc': 'Insurance policies & claims',
      'color': Color(0xFF536DFE)
    },
    {
      'icon': Icons.lock_rounded,
      'label': 'Passwords',
      'desc': 'Secure password manager',
      'color': Color(0xFFB388FF)
    },
    {
      'icon': Icons.contacts_rounded,
      'label': 'Contacts',
      'desc': 'Trusted contacts & nominees',
      'color': Color(0xFF7E57C2)
    },
    {
      'icon': Icons.gavel_rounded,
      'label': 'Legal Center',
      'desc': 'Legal documents & wills',
      'color': Color(0xFF9C27B0)
    },
    {
      'icon': Icons.settings_rounded,
      'label': 'Settings',
      'desc': 'App preferences & security',
      'color': Color(0xFF6C63FF)
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: AppTheme.darkBg.withValues(alpha: 0.97),
              child: _sidebarContent(),
            ),
      body: StardustBackground(
        child: Row(
          children: [
            if (isWide) _sidebar(),
            Expanded(
              child: Column(
                children: [
                  _appBar(isWide),
                  Expanded(child: _mainContentArea(context)),
                ],
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
      width: 260,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppTheme.lavenderAccent.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: _sidebarContent(),
    );
  }

  Widget _sidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.shield_rounded, color: AppTheme.lavenderAccent, size: 32),
              const SizedBox(width: 12),
              Text('Stardust',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.platinum)),
            ],
          ),
        ),
        const SizedBox(height: 40),
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
                onTap: () {
                  setState(() => _selectedIndex = index);
                  if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _appBar(bool isWide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          if (!isWide)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: AppTheme.platinum),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lavenderAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline_rounded,
                color: AppTheme.lavenderAccent, size: 20),
          ),
        ],
      ),
    );
  }


  // ─── Main Content Switcher with IndexedStack ───
  Widget _mainContentArea(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _dashboardHome(context),
        _PageWrapper(
            child: AssetsScreen(
                assets: _assets,
                onBack: () => setState(() => _selectedIndex = 0))),
        _PageWrapper(
            child: InsuranceScreen(
                policies: _policies,
                onBack: () => setState(() => _selectedIndex = 0))),
        _PageWrapper(
            child: PasswordsScreen(
                passwords: _passwords,
                onBack: () => setState(() => _selectedIndex = 0))),
        _PageWrapper(
            child: ContactsScreen(
                contacts: _contacts,
                onBack: () => setState(() => _selectedIndex = 0))),
        _PageWrapper(
            child: LegalCenterScreen(
                docs: _docs,
                onBack: () => setState(() => _selectedIndex = 0))),
        _PageWrapper(
            child: SettingsScreen(
                onBack: () => setState(() => _selectedIndex = 0))),
      ],
    );
  }

  // ─── Original Dashboard Content ───
  Widget _dashboardHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back 👋',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.platinum)),
          const SizedBox(height: 4),
          Text('Manage your digital legacy securely',
              style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.silverMist.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
          _statsRow(),
          const SizedBox(height: 24),
          Text('Quick Access',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 16),
          _grid(context),
        ],
      ),
    );
  }

  Widget _statsRow() {
    const stats = [
      {'label': 'Total Assets', 'value': '12', 'icon': Icons.trending_up},
      {'label': 'Active Policies', 'value': '3', 'icon': Icons.verified_user},
      {'label': 'Saved Passwords', 'value': '28', 'icon': Icons.key},
    ];
    return LayoutBuilder(builder: (ctx, constraints) {
      if (constraints.maxWidth > 600) {
        return Row(
          children: stats
              .map((s) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _statCard(s))))
              .toList(),
        );
      }
      return Column(
          children: stats
              .map((s) =>
                  Padding(padding: const EdgeInsets.only(bottom: 10), child: _statCard(s)))
              .toList());
    });
  }

  Widget _statCard(Map<String, dynamic> s) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.lavenderAccent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(s['icon'] as IconData, color: AppTheme.lavenderAccent, size: 22),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s['value'] as String,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.platinum)),
          Text(s['label'] as String,
              style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.silverMist.withValues(alpha: 0.5))),
        ]),
      ]),
    );
  }

  Widget _grid(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    int cols = 2;
    if (w > 1100) cols = 3;
    if (w < 500) cols = 1;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: _gridItems.map((item) => _gridCard(context, item)).toList(),
    );
  }

  Widget _gridCard(BuildContext context, Map<String, dynamic> item) {
    return GlassCard(
      onTap: () =>
          _showFeaturePage(context, item['label'] as String, item['icon'] as IconData),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (item['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'] as IconData,
                color: item['color'] as Color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(item['label'] as String,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 4),
          Text(item['desc'] as String,
              style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.silverMist.withValues(alpha: 0.5)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  void _showFeaturePage(BuildContext ctx, String title, IconData icon) {
    int index = -1;
    switch (title) {
      case 'Assets':
        index = 1;
        break;
      case 'Insurance':
        index = 2;
        break;
      case 'Passwords':
        index = 3;
        break;
      case 'Contacts':
        index = 4;
        break;
      case 'Legal Center':
        index = 5;
        break;
      case 'Settings':
        index = 6;
        break;
    }

    if (index != -1) {
      setState(() => _selectedIndex = index);
    } else {
      // Fallback for items not in sidebar
      Navigator.push(
          ctx,
          PageRouteBuilder(
            pageBuilder: (_, a, __) =>
                FadeTransition(opacity: a, child: _FeaturePage(title: title, icon: icon)),
            transitionDuration: const Duration(milliseconds: 300),
          ));
    }
  }
}

// ─── Sidebar tile ───
class _SidebarTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SidebarTile(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hov;
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: active
                ? AppTheme.lavenderAccent.withValues(alpha: 0.1)
                : Colors.transparent,
            border: widget.selected
                ? Border.all(
                    color: AppTheme.lavenderAccent.withValues(alpha: 0.2))
                : null,
          ),
          child: Row(children: [
            Icon(widget.icon,
                color: active ? AppTheme.lavenderAccent : AppTheme.silverMist.withValues(alpha: 0.4),
                size: 20),
            const SizedBox(width: 14),
            Text(widget.label,
                style: TextStyle(
                    color: active ? AppTheme.platinum : AppTheme.silverMist.withValues(alpha: 0.6),
                    fontWeight:
                        widget.selected ? FontWeight.w500 : FontWeight.w400,
                    fontSize: 14)),
          ]),
        ),
      ),
    );
  }
}

// ─── Page Wrapper to hide individual headers when inside dashboard ───
class _PageWrapper extends StatelessWidget {
  final Widget child;
  const _PageWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    // If the child is one of our feature screens, we might want to "unwrap" its Scaffold
    // But for now, let's see how it looks. Feature screens have their own Scaffold and Back button.
    // When inside the dashboard, the back button pops back to the previous screen (e.g. login).
    // We should probably remove the back button from the feature screens header if they are inside here.
    return child;
  }
}

// ─── Feature detail placeholder page ───
class _FeaturePage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _FeaturePage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: AppTheme.silverMist),
                    onPressed: () => Navigator.pop(context)),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.platinum)),
              ]),
            ),
            Expanded(
              child: Center(
                child: GlassCard(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lavenderAccent.withValues(alpha: 0.1),
                      ),
                      child: Icon(icon,
                          size: 56, color: AppTheme.lavenderAccent),
                    ),
                    const SizedBox(height: 20),
                    Text(title,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.platinum)),
                    const SizedBox(height: 8),
                    Text('This feature is coming soon!',
                        style: TextStyle(
                            color: AppTheme.silverMist
                                .withValues(alpha: 0.5))),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
