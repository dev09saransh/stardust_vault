import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

class AddContactSheet extends StatefulWidget {
  final Function(String, String, String) onAdd;
  const AddContactSheet({super.key, required this.onAdd});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _nameController = TextEditingController();
  final _relController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            Text('Add Trusted Contact',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'e.g. John Doe',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'e.g. +91 98765 43210',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _relController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                hintText: 'e.g. Spouse, Brother, Parent',
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Add Contact',
              onPressed: () {
                if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                  widget.onAdd(_nameController.text, _relController.text, _phoneController.text);
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
}
