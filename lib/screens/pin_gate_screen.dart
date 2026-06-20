import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class PinGateScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String pinKey; // SharedPreferences key that holds the correct PIN
  final List<Color> gradient;
  final Widget Function(BuildContext) destinationBuilder;

  const PinGateScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pinKey,
    required this.gradient,
    required this.destinationBuilder,
  });

  @override
  State<PinGateScreen> createState() => _PinGateScreenState();
}

class _PinGateScreenState extends State<PinGateScreen>
    with SingleTickerProviderStateMixin {
  String _entered = '';
  bool _wrong = false;
  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shake, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _addDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() {
      _entered += d;
      _wrong = false;
    });
    if (_entered.length == 4) _verify();
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _verify() async {
    final prefs = await SharedPreferences.getInstance();
    final correct = prefs.getString(widget.pinKey) ?? '';
    if (_entered == correct) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: widget.destinationBuilder),
      );
    } else {
      await _shake.forward(from: 0);
      setState(() {
        _entered = '';
        _wrong = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: widget.gradient),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x25000000),
                    blurRadius: 20,
                    offset: Offset(0, 8)),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('🔐', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(widget.title,
                        style: GoogleFonts.baloo2(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 4),
                    Text(widget.subtitle,
                        style: GoogleFonts.baloo2(
                            fontSize: 14, color: Colors.white70)),
                    const SizedBox(height: 24),
                    // 4-dot indicator
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(
                          _shake.isAnimating
                              ? 8 * ((_shakeAnim.value * 6).round() % 2 == 0
                                  ? 1
                                  : -1)
                              : 0,
                          0,
                        ),
                        child: child,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: i < _entered.length
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                  width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_wrong)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Incorrect PIN. Try again.',
                          style: GoogleFonts.baloo2(
                              color: Colors.red.shade200,
                              fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Number pad
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['', '0', '⌫'],
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: row.map((key) {
                          if (key.isEmpty) {
                            return const SizedBox(width: 72);
                          }
                          final isBack = key == '⌫';
                          return GestureDetector(
                            onTap: isBack
                                ? _backspace
                                : () => _addDigit(key),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 100),
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: isBack
                                    ? AppColors.surfaceVariant
                                    : AppColors.surface,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.card,
                              ),
                              child: Center(
                                child: isBack
                                    ? const Icon(
                                        Icons.backspace_outlined,
                                        color: AppColors.textMid,
                                        size: 22,
                                      )
                                    : Text(
                                        key,
                                        style: GoogleFonts.baloo2(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
