import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_doc_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';
import '../../widgets/drop_zone_wrapper.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme.dart';

class LegalCenterScreen extends StatefulWidget {
  final List<Map<String, String>> docs;
  final VoidCallback? onBack;
  final bool isGuest;
  const LegalCenterScreen({super.key, required this.docs, this.onBack, this.isGuest = false});

  @override
  State<LegalCenterScreen> createState() => _LegalCenterScreenState();
}

class _LegalCenterScreenState extends State<LegalCenterScreen> {

  void _addDoc() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddDocSheet(
        type: 'Legal',
        onAdd: (title) {
          setState(() {
            widget.docs.add({'title': title, 'date': 'Today', 'status': 'Pending'});
          });
          SuccessAnimationOverlay.show(context);
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
        type: 'Legal',
        initialFile: file,
        onAdd: (title) {
          setState(() {
            widget.docs.add({'title': title, 'date': 'Today', 'status': 'Vaulted'});
          });
          SuccessAnimationOverlay.show(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DropZoneWrapper(
        onDrop: _onFileDropped,
        child: StardustBackground(
          child: SafeArea(
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: widget.docs.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.edge),
                          itemCount: widget.docs.length,
                          itemBuilder: (context, index) {
                            final d = widget.docs[index];
                            return FadeInUp(
                              duration: const Duration(milliseconds: 400),
                              delay: Duration(milliseconds: index * 100),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                                child: GlassCard(
                                  padding: const EdgeInsets.all(AppSpacing.medium),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(AppSpacing.medium - 4),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.gavel_rounded,
                                          color: theme.colorScheme.primary,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.medium),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(d['title']!,
                                                style: theme.textTheme.titleLarge),
                                            Text('Added on ${d['date']}',
                                                style: theme.textTheme.bodySmall),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.file_download_outlined,
                                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6), size: 20),
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
        onPressed: _addDoc,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.upload_file_rounded, color: Colors.white),
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
          Text('Legal Center',
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
          Icon(Icons.gavel_outlined,
              size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.medium),
          Text('No documents uploaded',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}
