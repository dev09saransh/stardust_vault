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
    final isCard = widget.category == 'Cards';
    
    return GlassCard(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 100),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCard ? 'Add New Card' : 'Add New Asset',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: isCard ? 'Card Name' : 'Asset Name',
                hintText: isCard ? 'e.g. HDFC Millennia' : '',
              ),
            ),
            const SizedBox(height: 16),
            if (isCard) ...[
              TextField(
                controller: _variantController,
                decoration: const InputDecoration(
                  labelText: 'Variant',
                  hintText: 'e.g. Gold, Platinum, Signature',
                ),
              ),
              const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            if (!isCard) ...[
              Text('Category',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _typeChip('Digital'),
                  const SizedBox(width: 12),
                  _typeChip('Physical'),
                ],
              ),
            ],
            const SizedBox(height: 32),
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
            const SizedBox(height: 16),
          ],
        ),
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
                color: selected 
                    ? Theme.of(context).colorScheme.onSurface 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400)),
      ),
    );
  }
}
