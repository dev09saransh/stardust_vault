import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_asset_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';
import '../../widgets/drop_zone_wrapper.dart';
import '../../widgets/add_doc_sheet.dart';
import '../../widgets/card_benefits_sheet.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/document_viewer.dart';
import '../../theme.dart';

import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_asset_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';
import '../../widgets/drop_zone_wrapper.dart';
import '../../widgets/add_doc_sheet.dart';
import '../../widgets/card_benefits_sheet.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/document_viewer.dart';
import '../../theme.dart';
import '../../services/asset_service.dart';

class AssetsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isGuest;
  const AssetsScreen({super.key, this.onBack, this.isGuest = false});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AssetService _assetService = AssetService();
  
  List<Map<String, dynamic>> _assets = [];
  bool _isLoading = false;
  String? _errorMessage;

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
    if (!widget.isGuest) {
      _fetchAssets();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAssets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final assets = await _assetService.getAssets();
      setState(() {
        _assets = assets;
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

  void _addAsset() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    final currentCategory = _categories[_tabController.index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddAssetSheet(
        category: currentCategory,
        onAdd: (name, value, type) async {
          try {
            await _assetService.addAsset({
              'category': currentCategory,
              'title': name,
              'metadata': {
                'value': value,
                'type': type,
              },
              'is_encrypted': 1,
            });
            _fetchAssets();
            if (mounted) SuccessAnimationOverlay.show(context);
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add asset: $e'), backgroundColor: Colors.redAccent),
              );
            }
          }
        },
      ),
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
        onAdd: (title, fileKey, fileUrl) async {
          try {
            await _assetService.addAsset({
              'category': _categories[_tabController.index],
              'title': title,
              'metadata': {
                'value': 'Cloud Document',
                'type': 'Physical',
                'file_key': fileKey,
                'file_url': fileUrl,
              },
              'is_encrypted': 1,
            });
            _fetchAssets();
            if (mounted) SuccessAnimationOverlay.show(context);
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save document info: $e'), backgroundColor: Colors.redAccent),
              );
            }
          }
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
    final theme = Theme.of(context);
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        dividerColor: Colors.transparent,
        labelColor: theme.colorScheme.onSurface,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        labelStyle: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
        unselectedLabelStyle: theme.textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
      ),
    );
  }

  Widget _buildAssetList(String category) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)));
    }

    final filtered = _assets.where((a) => a['category'] == category).toList();
    final theme = Theme.of(context);
    
    if (filtered.isEmpty) return _emptyState();

    return RefreshIndicator(
      onRefresh: _fetchAssets,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.edge),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final asset = filtered[index];
          final metadata = asset['metadata'] ?? {};
          final type = metadata['type'] ?? 'Unknown';
          final value = metadata['value'] ?? '';
          final isCard = category == 'Cards' || type == 'Card';
          
          return FadeInUp(
            duration: const Duration(milliseconds: 400),
            delay: Duration(milliseconds: index * 100),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.medium),
              child: GlassCard(
                onTap: isCard ? () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CardBenefitsSheet(
                      cardName: asset['title'] ?? 'Unknown Card',
                      cardVariant: value,
                    ),
                  );
                } : (metadata['file_key'] != null || metadata['file_url'] != null ? () {
                  DocumentViewer.show(
                    context,
                    title: asset['title'] ?? 'Document',
                    fileKey: metadata['file_key'],
                    filePath: metadata['file_url'],
                  );
                } : null),
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
                        isCard 
                            ? Icons.credit_card_rounded
                            : (type == 'Digital' ? Icons.currency_bitcoin_rounded : Icons.inventory_2_rounded),
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset['title'] ?? 'Unnamed Asset',
                              style: theme.textTheme.titleLarge),
                          const SizedBox(height: 2),
                          Text(isCard ? 'Tap to view benefits' : type,
                              style: isCard 
                                  ? theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)
                                  : theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Text(value,
                        style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary)),
                  ],
                ),
              ),
            ),
          );
        },
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
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.small),
          Text('Assets',
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
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.medium),
          Text('No assets added yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
          if (!widget.isGuest) ...[
            const SizedBox(height: AppSpacing.medium),
            TextButton(onPressed: _fetchAssets, child: const Text('Refresh')),
          ],
        ],
      ),
    );
  }
}
}
