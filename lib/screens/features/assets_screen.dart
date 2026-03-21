import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/success_animation.dart';
import '../../theme.dart';

class AssetsScreen extends StatefulWidget {
  final List<Map<String, String>> assets;
  final VoidCallback? onBack;
  const AssetsScreen({super.key, required this.assets, this.onBack});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {

  void _addAsset() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddAssetSheet(onAdd: (name, value, type) {
        setState(() {
          widget.assets.add({'name': name, 'value': value, 'type': type});
        });
        SuccessAnimationOverlay.show(context);
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
                child: widget.assets.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: widget.assets.length,
                        itemBuilder: (context, index) {
                          final asset = widget.assets[index];
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
                                    child: Icon(
                                      asset['type'] == 'Digital'
                                          ? Icons.currency_bitcoin_rounded
                                          : Icons.inventory_2_rounded,
                                      color: AppTheme.lavenderAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(asset['name']!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.platinum)),
                                        Text(asset['type']!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.silverMist
                                                    .withValues(alpha: 0.5))),
                                      ],
                                    ),
                                  ),
                                  Text(asset['value']!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.lavenderAccent)),
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
        onPressed: _addAsset,
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
          const Text('Assets',
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
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: AppTheme.silverMist.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No assets added yet',
              style: TextStyle(
                  color: AppTheme.silverMist.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}

class _AddAssetSheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  const _AddAssetSheet({required this.onAdd});

  @override
  State<_AddAssetSheet> createState() => _AddAssetSheetState();
}

class _AddAssetSheetState extends State<_AddAssetSheet> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  String _type = 'Digital';

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
          const Text('Add New Asset',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Asset Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            decoration: const InputDecoration(labelText: 'Value / Identifier'),
          ),
          const SizedBox(height: 16),
          const Text('Category',
              style: TextStyle(color: AppTheme.silverMist, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              _typeChip('Digital'),
              const SizedBox(width: 12),
              _typeChip('Physical'),
            ],
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Add Asset',
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                widget.onAdd(_nameController.text, _valueController.text, _type);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _typeChip(String label) {
    final selected = _type == label;
    return GestureDetector(
      onTap: () => setState(() => _type = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? AppTheme.lavenderAccent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: selected
                ? AppTheme.lavenderAccent
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? AppTheme.platinum : AppTheme.silverMist,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400)),
      ),
    );
  }
}
