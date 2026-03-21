import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/success_animation.dart';
import '../../theme.dart';

class InsuranceScreen extends StatefulWidget {
  final List<Map<String, String>> policies;
  final VoidCallback? onBack;
  const InsuranceScreen({super.key, required this.policies, this.onBack});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {

  void _addPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddPolicySheet(onAdd: (provider, policyNo, type) {
        setState(() {
          widget.policies.add({'provider': provider, 'policyNo': policyNo, 'type': type});
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
                child: widget.policies.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: widget.policies.length,
                        itemBuilder: (context, index) {
                          final policy = widget.policies[index];
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
                                      policy['type'] == 'Health'
                                          ? Icons.health_and_safety_rounded
                                          : Icons.directions_car_rounded,
                                      color: AppTheme.lavenderAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(policy['provider']!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.platinum)),
                                        Text(policy['type']!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.silverMist
                                                    .withValues(alpha: 0.5))),
                                      ],
                                    ),
                                  ),
                                  Text(policy['policyNo']!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppTheme.platinum)),
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
        onPressed: _addPolicy,
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
          const Text('Insurance',
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
          Icon(Icons.health_and_safety_outlined,
              size: 80, color: AppTheme.silverMist.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No policies added yet',
              style: TextStyle(
                  color: AppTheme.silverMist.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}

class _AddPolicySheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  const _AddPolicySheet({required this.onAdd});

  @override
  State<_AddPolicySheet> createState() => _AddPolicySheetState();
}

class _AddPolicySheetState extends State<_AddPolicySheet> {
  final _providerController = TextEditingController();
  final _policyNoController = TextEditingController();
  String _type = 'Health';

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
          const Text('Add New Policy',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 24),
          TextField(
            controller: _providerController,
            decoration: const InputDecoration(labelText: 'Provider Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _policyNoController,
            decoration: const InputDecoration(labelText: 'Policy Number'),
          ),
          const SizedBox(height: 16),
          const Text('Type',
              style: TextStyle(color: AppTheme.silverMist, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              _typeChip('Health'),
              const SizedBox(width: 12),
              _typeChip('Vehicle'),
              const SizedBox(width: 12),
              _typeChip('Life'),
            ],
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Add Policy',
            onPressed: () {
              if (_providerController.text.isNotEmpty) {
                widget.onAdd(_providerController.text, _policyNoController.text, _type);
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
