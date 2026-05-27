import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/help_screen.dart';

class HelpButton extends StatefulWidget {
  final bool highRisk;

  const HelpButton({super.key, this.highRisk = false});

  @override
  State<HelpButton> createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton> {
  Timer? _holdTimer;
  bool _isHolding = false;

  void _startHold() {
    _holdTimer?.cancel();
    setState(() => _isHolding = true);
    _holdTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    if (mounted) setState(() => _isHolding = false);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Hold for 2 seconds to activate the help alert.'),
          duration: Duration(seconds: 2),
        ));
      },
      onLongPressStart: (_) => _startHold(),
      onLongPressEnd: (_) => _cancelHold(),
      onLongPressCancel: _cancelHold,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'helpButton',
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            onPressed: null,
            child: const Icon(Icons.shield, color: Colors.white),
          ),
          if (_isHolding)
            const SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );

    return widget.highRisk
        ? button.animate(onPlay: (controller) => controller.repeat()).scaleXY(
            begin: 1,
            end: 1.08,
            duration: 600.ms,
            curve: Curves.easeInOut,
          )
        : button;
  }
}
