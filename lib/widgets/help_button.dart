import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/help_screen.dart';

class HelpButton extends StatefulWidget {
  const HelpButton({super.key});

  @override
  State<HelpButton> createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _wiggle;
  late Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    _wiggle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _angle = Tween<double>(begin: -0.07, end: 0.07).animate(
      CurvedAnimation(parent: _wiggle, curve: Curves.elasticIn),
    );
    Future.delayed(const Duration(seconds: 2), _startWiggleLoop);
  }

  void _startWiggleLoop() {
    if (!mounted) return;
    _wiggle.forward().then((_) {
      if (!mounted) return;
      _wiggle.reverse().then((_) {
        Future.delayed(const Duration(seconds: 5), _startWiggleLoop);
      });
    });
  }

  @override
  void dispose() {
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: AnimatedBuilder(
        animation: _angle,
        builder: (context, child) =>
            Transform.rotate(angle: _angle.value, child: child),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpScreen()),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55FF416C),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'I Feel Unsafe',
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
