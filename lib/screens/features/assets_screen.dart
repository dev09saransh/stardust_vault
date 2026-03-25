import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_asset_sheet.dart';
import '../../widgets/login_prompt.dart';
import '../../theme.dart';
import 'package:animate_do/animate_do.dart';
import '../../widgets/drop_zone_wrapper.dart';
import '../../widgets/add_doc_sheet.dart';
import 'package:image_picker/image_picker.dart';

class AssetsScreen extends StatefulWidget {
  final List<Map<String, String>> assets;
  final VoidCallback? onBack;
  final bool isGuest;
  const AssetsScreen({super.key, required this.assets, this.onBack, this.isGuest = false});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'Real Estate',
    'Banking',
    'Cards',
    'Investments',
    'Vehicles',
    'Collectibles'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addAsset() {
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
          widget.assets.add({'name': name, 'value': value, 'type': type});
        });
        SuccessAnimationOverlay.show(context);
      }),
    );
  }

  void _onFileDropped(XFile file) {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddDocSheet(
        type: 'Asset',
        initialFile: file,
        onAdd: (title) {
          setState(() {
            widget.assets.add({
              'name': title,
              'value': 'Uploaded File',
              'type': 'Physical'
            });
          });
          SuccessAnimationOverlay.show(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DropZoneWrapper(
        onDrop: _onFileDropped,
        child: StardustBackground(
          child: SafeArea(
            child: Column(
              children: [
                _header(context),
                _categoryTabs(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _categories.map((cat) => _buildAssetList(cat)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAsset,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _categoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
      ),
    );
  }

  Widget _buildAssetList(String category) {
    // For now, filtering is simulated or based on 'type' if it matches
    final filtered = widget.assets.where((a) {
      if (category == 'Banking' && a['type'] == 'Digital') return true;
      if (category == 'Real Estate' && a['type'] == 'Physical') return true;
      // Default to showing some items if it's the first tab for demo
      return category == _categories[0]; 
    }).toList();

    if (filtered.isEmpty) return _emptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final asset = filtered[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: index * 100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      asset['type'] == 'Digital'
                          ? Icons.currency_bitcoin_rounded
                          : Icons.inventory_2_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(asset['name']!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface)),
                        Text(asset['type']!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                  Text(asset['value']!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('Assets',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No assets added yet',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}
