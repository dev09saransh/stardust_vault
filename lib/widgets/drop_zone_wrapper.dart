import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';

class DropZoneWrapper extends StatefulWidget {
  final Widget child;
  final Function(XFile) onDrop;

  const DropZoneWrapper({
    super.key,
    required this.child,
    required this.onDrop,
  });

  @override
  State<DropZoneWrapper> createState() => _DropZoneWrapperState();
}

class _DropZoneWrapperState extends State<DropZoneWrapper> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) => setState(() => _isHovering = true),
      onDragExited: (details) => setState(() => _isHovering = false),
      onDragDone: (details) {
        setState(() => _isHovering = false);
        if (details.files.isNotEmpty) {
          widget.onDrop(details.files.first);
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_isHovering)
            _buildDropOverlay(),
        ],
      ),
    );
  }

  Widget _buildDropOverlay() {
    return Positioned.fill(
      child: FadeIn(
        duration: const Duration(milliseconds: 200),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Drop to Vault',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Release your files to securely upload them',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
