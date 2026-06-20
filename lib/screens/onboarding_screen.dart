import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  final TextEditingController _name = TextEditingController();
  int _step = 0;
  bool _saving = false;

  static const _parentPin = '1234';
  static const _teacherPin = '5678';
  static const _govPin = '0000';

  Future<void> _finish() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', _name.text.trim());
    // Set default PINs only if not already customised.
    prefs.getString('parent_pin') == null
        ? await prefs.setString('parent_pin', _parentPin)
        : null;
    prefs.getString('teacher_pin') == null
        ? await prefs.setString('teacher_pin', _teacherPin)
        : null;
    prefs.getString('gov_pin') == null
        ? await prefs.setString('gov_pin', _govPin)
        : null;
    await prefs.setBool('setup_complete', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _nextPage() {
    if (_step == 1 && _name.text.trim().isEmpty) return;
    _pages.nextPage(
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: PageView(
        controller: _pages,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _step = i),
        children: [
          _WelcomePage(onNext: _nextPage),
          _NamePage(controller: _name, onNext: _nextPage),
          _PinInfoPage(
            parentPin: _parentPin,
            teacherPin: _teacherPin,
            govPin: _govPin,
            onDone: _saving ? null : _finish,
          ),
        ],
      ),
    );
  }
}

// ─── Step indicator ────────────────────────────────────────────────────────
class _StepDots extends StatelessWidget {
  final int current;
  final int total;
  const _StepDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == current ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == current
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

// ─── Page 1: Welcome ───────────────────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: AppColors.headerGradient),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🛡️', style: TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to\nSafeSteps',
              textAlign: TextAlign.center,
              style: AppText.displayLarge(),
            ),
            const SizedBox(height: 16),
            Text(
              'Learn how to stay safe through\nfun choose-your-own-adventure stories.',
              textAlign: TextAlign.center,
              style: AppText.bodyLarge(),
            ),
            const Spacer(),
            AppButton(label: 'Get Started', onTap: onNext),
            const SizedBox(height: 24),
            const _StepDots(current: 0, total: 3),
          ],
        ),
      ),
    );
  }
}

// ─── Page 2: Name entry ────────────────────────────────────────────────────
class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;
  const _NamePage({required this.controller, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text('👋', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text('What\'s your name?', style: AppText.displayLarge()),
            const SizedBox(height: 8),
            Text(
              'We\'ll use this to personalise your experience.',
              style: AppText.bodyMedium(),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              style: AppText.headingMedium(),
              decoration: InputDecoration(
                hintText: 'Enter your name...',
                hintStyle: AppText.headingMedium()
                    .copyWith(color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
              ),
              onSubmitted: (_) => onNext(),
            ),
            const Spacer(),
            AppButton(label: 'Continue', onTap: onNext),
            const SizedBox(height: 24),
            const _StepDots(current: 1, total: 3),
          ],
        ),
      ),
    );
  }
}

// ─── Page 3: PIN info ─────────────────────────────────────────────────────
class _PinInfoPage extends StatelessWidget {
  final String parentPin;
  final String teacherPin;
  final String govPin;
  final VoidCallback? onDone;
  const _PinInfoPage({
    required this.parentPin,
    required this.teacherPin,
    required this.govPin,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔑', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 20),
            Text('Dashboard Access', style: AppText.displayLarge()),
            const SizedBox(height: 8),
            Text(
              'Parents, teachers, and government officials can view progress dashboards using these PINs:',
              style: AppText.bodyMedium(),
            ),
            const SizedBox(height: 28),
            _PinTile(
              icon: '👨‍👩‍👧',
              role: 'Parent / Guardian',
              pin: parentPin,
              gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            const SizedBox(height: 12),
            _PinTile(
              icon: '👩‍🏫',
              role: 'Teacher',
              pin: teacherPin,
              gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
            const SizedBox(height: 12),
            _PinTile(
              icon: '🏛️',
              role: 'Government Agency',
              pin: govPin,
              gradient: const [Color(0xFFF7971E), Color(0xFFFFD200)],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Share these PINs only with trusted adults. You can change them from the dashboards later.',
                      style: AppText.caption()
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: "Let's go! 🚀",
              onTap: onDone,
            ),
            const SizedBox(height: 24),
            const _StepDots(current: 2, total: 3),
          ],
        ),
      ),
    );
  }
}

class _PinTile extends StatelessWidget {
  final String icon;
  final String role;
  final String pin;
  final List<Color> gradient;
  const _PinTile(
      {required this.icon,
      required this.role,
      required this.pin,
      required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: AppText.headingSmall()),
                Text('Tap dashboards → enter PIN',
                    style: AppText.caption()),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              pin,
              style: GoogleFonts.baloo2(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
