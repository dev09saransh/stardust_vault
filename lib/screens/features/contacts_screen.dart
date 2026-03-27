import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_contact_sheet.dart';
import '../../widgets/add_doc_sheet.dart';
import '../../widgets/login_prompt.dart';
import '../../widgets/drop_zone_wrapper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/document_viewer.dart';
import '../../theme.dart';

import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_contact_sheet.dart';
import '../../widgets/add_doc_sheet.dart';
import '../../widgets/login_prompt.dart';
import '../../widgets/drop_zone_wrapper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/document_viewer.dart';
import '../../theme.dart';
import '../../services/contact_service.dart';

class ContactsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final bool isGuest;
  const ContactsScreen({super.key, this.onBack, this.isGuest = false});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactService _contactService = ContactService();
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _fetchContacts();
    }
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final contacts = await _contactService.getContacts();
      setState(() {
        _contacts = contacts;
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
        type: 'Identity',
        initialFile: file,
        onAdd: (title, filePath) async {
          // Placeholder for real upload logic
          setState(() {
            _contacts.add({
              'name': title,
              'relation': 'Identity Doc',
              'phone': 'N/A',
              'status': 'Pending',
              'filePath': filePath,
            });
          });
          SuccessAnimationOverlay.show(context);
        },
      ),
    );
  }

  void _addContact() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddContactSheet(onAdd: (name, relation, phone) async {
        try {
          await _contactService.addContact({
            'name': name,
            'relation': relation,
            'phone': phone,
            'status': 'Pending',
          });
          _fetchContacts();
          if (mounted) SuccessAnimationOverlay.show(context);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save contact: $e'), backgroundColor: Colors.redAccent),
            );
          }
        }
      }),
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)))
                          : _contacts.isEmpty
                              ? _emptyState()
                              : RefreshIndicator(
                                  onRefresh: _fetchContacts,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(AppSpacing.edge),
                                    itemCount: _contacts.length,
                                    itemBuilder: (context, index) {
                                      final c = _contacts[index];
                                      final status = c['status'] ?? 'Pending';
                                      
                                      return FadeInUp(
                                        duration: const Duration(milliseconds: 400),
                                        delay: Duration(milliseconds: index * 100),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                                          child: GlassCard(
                                            onTap: c['filePath'] != null ? () {
                                              DocumentViewer.show(
                                                context,
                                                title: c['name'] ?? 'Contact',
                                                filePath: c['filePath'],
                                                status: status,
                                              );
                                            } : null,
                                            padding: const EdgeInsets.all(AppSpacing.medium),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                                  child: Icon(Icons.person_rounded, color: theme.colorScheme.primary),
                                                ),
                                                const SizedBox(width: AppSpacing.medium),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(c['name'] ?? 'Unknown',
                                                          style: theme.textTheme.titleLarge),
                                                      const SizedBox(height: 2),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.phone_outlined,
                                                              size: 12,
                                                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                                                          const SizedBox(width: AppSpacing.tiny),
                                                          Text(c['phone'] ?? 'N/A',
                                                              style: theme.textTheme.bodySmall),
                                                        ],
                                                      ),
                                                      Text(c['relation'] ?? 'Contact',
                                                          style: theme.textTheme.bodySmall?.copyWith(
                                                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4))),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: AppSpacing.small, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: status == 'Verified'
                                                        ? Colors.green.withValues(alpha: 0.1)
                                                        : Colors.orange.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    status,
                                                    style: theme.textTheme.labelSmall?.copyWith(
                                                        color: status == 'Verified'
                                                            ? Colors.greenAccent
                                                            : Colors.orangeAccent,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
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
                color: theme.colorScheme.onSurface, size: isMobile ? 20 : 24),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.small),
          Text('Contacts',
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
          Icon(Icons.contacts_outlined,
              size: 80, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.medium),
          Text('No contacts added',
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
          if (!widget.isGuest) ...[
            const SizedBox(height: AppSpacing.medium),
            TextButton(onPressed: _fetchContacts, child: const Text('Refresh')),
          ],
        ],
      ),
    );
  }
}
}
