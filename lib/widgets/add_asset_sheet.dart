import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'gradient_button.dart';
import '../theme.dart';

class AddAssetSheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  final String category;
  const AddAssetSheet({super.key, required this.onAdd, this.category = 'Digital'});

  @override
  State<AddAssetSheet> createState() => _AddAssetSheetState();
}

class _AddAssetSheetState extends State<AddAssetSheet> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _variantController = TextEditingController();
  final _typeDetailController = TextEditingController();
  String _type = 'Digital';

  @override
  void initState() {
    super.initState();
    _type = widget.category == 'Cards' ? 'Physical' : 'Digital';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCard = widget.category == 'Cards';
    
    return GlassCard(
      margin: EdgeInsets.fromLTRB(
          AppSpacing.medium,
          100,
          AppSpacing.medium,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xlarge),
      padding: const EdgeInsets.all(AppSpacing.large),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCard ? 'Add New Card' : 'Add New Asset',
                style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.large),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: isCard ? 'Card Name' : 'Asset Name',
                hintText: isCard ? 'e.g. HDFC Millennia' : '',
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            if (isCard) ...[
              TextField(
                controller: _variantController,
                decoration: const InputDecoration(
                  labelText: 'Variant',
                  hintText: 'e.g. Gold, Platinum, Signature',
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              TextField(
                controller: _typeDetailController,
                decoration: const InputDecoration(
                  labelText: 'Card Type',
                  hintText: 'e.g. Visa, Rupay, Mastercard',
                ),
              ),
            ] else ...[
              TextField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Value / Identifier'),
              ),
            ],
            const SizedBox(height: AppSpacing.medium),
            if (!isCard) ...[
              Text('Category',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  _typeChip('Digital'),
                  const SizedBox(width: AppSpacing.medium),
                  _typeChip('Physical'),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xlarge),
            GradientButton(
              text: isCard ? 'Add Card' : 'Add Asset',
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  if (isCard) {
                    final value = '${_variantController.text} | ${_typeDetailController.text}';
                    widget.onAdd(_nameController.text, value, 'Card');
                  } else {
                    widget.onAdd(_nameController.text, _valueController.text, _type);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label) {
    final theme = Theme.of(context);
    final selected = _type == label;
    return GestureDetector(
      onTap: () => setState(() => _type = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large, vertical: AppSpacing.small + 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(label,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: selected 
                    ? theme.colorScheme.onSurface 
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
