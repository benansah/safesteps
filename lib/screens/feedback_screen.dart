import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';
import '../widgets/help_button.dart';

class FeedbackScreen extends StatefulWidget {
  final StoryChoice choice;
  final bool isLastDecision;
  final VoidCallback onContinue;

  const FeedbackScreen({
    super.key,
    required this.choice,
    required this.isLastDecision,
    required this.onContinue,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _pop;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _pop = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _pop, curve: Curves.elasticOut);
    _pop.forward();
    if (widget.choice.isSafe) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safe = widget.choice.isSafe;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              // Top banner
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: safe
                        ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
                        : [const Color(0xFFF7971E), const Color(0xFFFFD200)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 20,
                        offset: Offset(0, 8)),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scale,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(safe ? '⭐' : '🤔',
                                  style: const TextStyle(fontSize: 44)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          safe
                              ? 'Great choice!'
                              : 'Something to think about...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        if (safe)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'You earned a star! ⭐',
                              style: GoogleFonts.baloo2(
                                  fontSize: 14, color: Colors.white70),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Feedback body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppShadows.card,
                          border: Border.all(
                            color: safe
                                ? AppColors.success.withOpacity(0.2)
                                : AppColors.warning.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          widget.choice.feedback.en,
                          textAlign: TextAlign.center,
                          style: AppText.bodyLarge(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: safe
                            ? (widget.isLastDecision
                                ? 'See my score! 🎉'
                                : 'Next choice  →')
                            : 'Okay, got it!  👍',
                        onTap: () {
                          Navigator.pop(context);
                          widget.onContinue();
                        },
                        gradient: safe
                            ? [
                                const Color(0xFF11998E),
                                const Color(0xFF38EF7D)
                              ]
                            : [
                                const Color(0xFFF7971E),
                                const Color(0xFFFFD200)
                              ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 22,
              maxBlastForce: 35,
              minBlastForce: 12,
              gravity: 0.3,
              colors: const [
                Color(0xFFFFD700),
                Color(0xFF4FC3F7),
                Color(0xFF81C784),
                Color(0xFFFF7043),
                Color(0xFFE040FB),
                Colors.white,
              ],
            ),
          ),
          const HelpButton(),
        ],
      ),
    );
  }
}
