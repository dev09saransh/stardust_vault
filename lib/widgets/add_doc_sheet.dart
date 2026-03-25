import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'gradient_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddDocSheet extends StatefulWidget {
  final String type;
  final Function(String) onAdd;
  const AddDocSheet({super.key, required this.type, required this.onAdd});

  @override
  State<AddDocSheet> createState() => _AddDocSheetState();
}

class _AddDocSheetState extends State<AddDocSheet> {
  final _titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _pickedFile = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing ${source == ImageSource.camera ? 'camera' : 'gallery'}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 100),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.description_rounded, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload ${widget.type} Document',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface)),
                  Text('Securely vault your files',
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Document Title',
              hintText: 'e.g. ${widget.type} Policy 2025',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: 24),
          if (_pickedFile != null)
            _imagePreview()
          else
            _selectionOptions(),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Vault Document',
            onPressed: (_pickedFile != null && _titleController.text.isNotEmpty)
                ? () {
                    widget.onAdd(_titleController.text);
                    Navigator.pop(context);
                  }
                : null,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return FadeIn(
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: kIsWeb
                  ? Image.network(_pickedFile!.path, fit: BoxFit.cover)
                  : Image.file(File(_pickedFile!.path), fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => setState(() => _pickedFile = null),
                icon: const Icon(Icons.cancel_rounded, color: Colors.white, size: 28),
                style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.black.withValues(alpha: 0.6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'File selected: ${_pickedFile!.name}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectionOptions() {
    return Row(
      children: [
        Expanded(
          child: _optionButton(
            icon: Icons.document_scanner_rounded,
            label: 'Scan Document',
            onTap: () => _pickImage(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _optionButton(
            icon: Icons.upload_file_rounded,
            label: 'Upload File',
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _optionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
