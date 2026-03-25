import 'package:flutter/material.dart';
import '../../widgets/stardust_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/success_animation.dart';
import '../../widgets/add_contact_sheet.dart';
import '../../widgets/login_prompt.dart';
import 'package:animate_do/animate_do.dart';

class ContactsScreen extends StatefulWidget {
  final List<Map<String, String>> contacts;
  final VoidCallback? onBack;
  final bool isGuest;
  const ContactsScreen({super.key, required this.contacts, this.onBack, this.isGuest = false});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  void _addContact() {
    if (widget.isGuest) {
      LoginRequiredPrompt.show(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddContactSheet(onAdd: (name, relation, phone) {
        setState(() {
          widget.contacts.add({'name': name, 'relation': relation, 'phone': phone, 'status': 'Pending'});
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
                child: widget.contacts.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: widget.contacts.length,
                        itemBuilder: (context, index) {
                          final c = widget.contacts[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            delay: Duration(milliseconds: index * 100),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GlassCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      child: Icon(Icons.person_rounded,
                                          color: Theme.of(context).colorScheme.primary),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(c['name']!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context).colorScheme.onSurface)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.phone_outlined, size: 12,
                                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                                              const SizedBox(width: 4),
                                              Text(c['phone'] ?? 'N/A',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context).colorScheme.onSurfaceVariant
                                                          .withValues(alpha: 0.6))),
                                            ],
                                          ),
                                          Text(c['relation']!,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context).colorScheme.onSurfaceVariant
                                                      .withValues(alpha: 0.5))),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: c['status'] == 'Verified'
                                            ? Colors.green.withValues(alpha: 0.1)
                                            : Colors.orange.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        c['status']!,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: c['status'] == 'Verified'
                                                ? Colors.greenAccent
                                                : Colors.orangeAccent,
                                            fontWeight: FontWeight.w500),
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
            ],
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
          Text('Contacts',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
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
          Icon(Icons.contacts_outlined,
              size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text('No contacts added',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 16)),
        ],
      ),
    );
  }
}
