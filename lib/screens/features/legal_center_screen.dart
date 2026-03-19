import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../theme.dart';

class LegalCenterScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const LegalCenterScreen({super.key, this.onBack});

  @override
  State<LegalCenterScreen> createState() => _LegalCenterScreenState();
}

class _LegalCenterScreenState extends State<LegalCenterScreen> {
  final List<Map<String, String>> _docs = [
    {'title': 'Will & Testament', 'date': '2025-10-12', 'status': 'Signed'},
    {'title': 'Property Deed', 'date': '2024-05-20', 'status': 'Vaulted'},
  ];

  void _addDoc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddDocSheet(onAdd: (title) {
        setState(() {
          _docs.add({'title': title, 'date': 'Today', 'status': 'Pending'});
        });
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
                child: _docs.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _docs.length,
                        itemBuilder: (context, index) {
                          final d = _docs[index];
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
                                    child: const Icon(
                                      Icons.gavel_rounded,
                                      color: AppTheme.lavenderAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(d['title']!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.platinum)),
                                        Text('Added on ${d['date']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.silverMist
                                                    .withValues(alpha: 0.5))),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.file_download_outlined,
                                      color: AppTheme.silverMist, size: 20),
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
        onPressed: _addDoc,
        backgroundColor: AppTheme.lavenderAccent,
        child: const Icon(Icons.upload_file_rounded, color: Colors.white),
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
          const Text('Legal Center',
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
          Icon(Icons.gavel_outlined,
              size: 80, color: AppTheme.silverMist.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No documents uploaded',
              style: TextStyle(
                  color: AppTheme.silverMist.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}

class _AddDocSheet extends StatefulWidget {
  final Function(String) onAdd;
  const _AddDocSheet({required this.onAdd});

  @override
  State<_AddDocSheet> createState() => _AddDocSheetState();
}

class _AddDocSheetState extends State<_AddDocSheet> {
  final _titleController = TextEditingController();

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
          const Text('Upload Document',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.platinum)),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Document Title'),
          ),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Upload',
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                widget.onAdd(_titleController.text);
                Navigator.pop(context);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
