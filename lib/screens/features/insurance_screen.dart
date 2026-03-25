import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/login_prompt.dart';
import '../../theme.dart';
import 'package:animate_do/animate_do.dart';
import '../../widgets/drop_zone_wrapper.dart';
import '../../widgets/add_doc_sheet.dart';
import 'package:image_picker/image_picker.dart';

class InsuranceScreen extends StatefulWidget {
  final List<Map<String, String>> policies;
  final VoidCallback? onBack;
  final bool isGuest;
  const InsuranceScreen({super.key, required this.policies, this.onBack, this.isGuest = false});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {

  void _addPolicy() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
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
        type: 'Insurance',
        initialFile: file,
        onAdd: (title) {
          setState(() {
            widget.policies.add({
              'provider': title,
              'policyNo': 'UPLOAD-${DateTime.now().millisecond}',
              'type': 'General'
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
                Expanded(
                  child: widget.policies.isEmpty
                      ? _emptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: widget.policies.length,
                          itemBuilder: (context, index) {
                            final policy = widget.policies[index];
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
                                          color: Theme.of(context).colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          policy['type'] == 'Health'
                                              ? Icons.health_and_safety_rounded
                                              : Icons.directions_car_rounded,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(policy['provider']!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).colorScheme.onSurface)),
                                            Text(policy['type']!,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).colorScheme.onSurfaceVariant
                                                        .withValues(alpha: 0.6))),
                                          ],
                                        ),
                                      ),
                                      Text(policy['policyNo']!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context).colorScheme.onSurface)),
                                    ],
                                  ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPolicy,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('Insurance',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.health_and_safety_outlined,
              size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No policies added yet',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
          Text('Add New Policy',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface)),
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
          Text('Type',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
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
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
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
