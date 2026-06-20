import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';
import '../widgets/help_button.dart';
import 'feedback_screen.dart';

class StoryScreen extends StatefulWidget {
  final Story story;
  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int _currentStep = -1;
  int _starsThisRound = 0;
  final List<bool> _choiceResults = [];

  void _startStory() => setState(() => _currentStep = 0);

  Future<void> _onChoice(StoryChoice choice) async {
    _choiceResults.add(choice.isSafe);
    if (choice.isSafe) _starsThisRound++;
    final isLast = _currentStep == widget.story.decisions.length - 1;
    final nextStep = _currentStep + 1;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackScreen(
          choice: choice,
          isLastDecision: isLast,
          onContinue: () => _afterFeedback(isLast, nextStep),
        ),
      ),
    );
  }

  Future<void> _afterFeedback(bool isLast, int nextStep) async {
    if (isLast) {
      final prefs = await SharedPreferences.getInstance();
      final prev = prefs.getInt('stars_${widget.story.id}') ?? 0;
      if (_starsThisRound > prev) {
        await prefs.setInt('stars_${widget.story.id}', _starsThisRound);
      }
      await prefs.setBool('completed_${widget.story.id}', true);
      final safeCount = _choiceResults.where((c) => c).length;
      final riskyCount = _choiceResults.length - safeCount;
      // Per-story last-run breakdown (for dashboards)
      await prefs.setInt('safe_${widget.story.id}', safeCount);
      await prefs.setInt('risky_${widget.story.id}', riskyCount);
      // Cumulative totals
      await prefs.setInt('total_safe_choices',
          (prefs.getInt('total_safe_choices') ?? 0) + safeCount);
      await prefs.setInt('total_risky_choices',
          (prefs.getInt('total_risky_choices') ?? 0) + riskyCount);
      await prefs.setInt(
          'total_sessions', (prefs.getInt('total_sessions') ?? 0) + 1);
      await prefs.setString('last_played', widget.story.id);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SummaryScreen(
            story: widget.story,
            starsEarned: _starsThisRound,
            choiceResults: List.from(_choiceResults),
          ),
        ),
      );
    } else {
      setState(() => _currentStep = nextStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          _currentStep == -1
              ? _buildIntro(context)
              : _buildDecision(context),
          const HelpButton(),
        ],
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final idx =
        (int.tryParse(widget.story.id.split('_').last) ?? 1) - 1;
    final gradients = [
      AppColors.story1,
      AppColors.story2,
      AppColors.story3
    ];
    final gradient = gradients[idx % gradients.length];

    return Column(
      children: [
        // Gradient header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      _BackButton(onTap: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(widget.story.emoji,
                      style: const TextStyle(fontSize: 72)),
                  const SizedBox(height: 12),
                  Text(
                    widget.story.title.en,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.story.characterName}, age ${widget.story.characterAge}  •  ${widget.story.decisions.length} decisions',
                      style: GoogleFonts.baloo2(
                          fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppShadows.card,
                  ),
                  child: Text(
                    widget.story.intro.en,
                    style: AppText.bodyLarge(),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: "Let's go! 🚀",
                  onTap: _startStory,
                  gradient: gradient,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecision(BuildContext context) {
    final decision = widget.story.decisions[_currentStep];
    final progress =
        (_currentStep + 1) / widget.story.decisions.length;

    return Column(
      children: [
        // Header bar
        Container(
          color: AppColors.surface,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  _BackButton(
                      onTap: () => Navigator.pop(context),
                      dark: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.story.title.en,
                          style: AppText.headingSmall(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_currentStep + 1}/${widget.story.decisions.length}',
                      style: AppText.caption().copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                Text(decision.emoji,
                    style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppShadows.card,
                  ),
                  child: Text(
                    decision.scenario.en,
                    style: AppText.bodyLarge(),
                  ),
                ),
                const SizedBox(height: 20),
                _ChoiceButton(
                  text: decision.choiceA.text.en,
                  isSafe: true,
                  onTap: () => _onChoice(decision.choiceA),
                ),
                const SizedBox(height: 12),
                _ChoiceButton(
                  text: decision.choiceB.text.en,
                  isSafe: false,
                  onTap: () => _onChoice(decision.choiceB),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Summary Screen
// ─────────────────────────────────────────────
class SummaryScreen extends StatelessWidget {
  final Story story;
  final int starsEarned;
  final List<bool> choiceResults;

  const SummaryScreen({
    super.key,
    required this.story,
    required this.starsEarned,
    required this.choiceResults,
  });

  @override
  Widget build(BuildContext context) {
    final perfect = starsEarned == story.decisions.length;
    final safeCount = choiceResults.where((c) => c).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: perfect
                        ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
                        : [AppColors.primary, AppColors.primaryLight],
                  ),
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
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    child: Column(
                      children: [
                        Text(perfect ? '🎉' : '👏',
                            style: const TextStyle(fontSize: 64)),
                        const SizedBox(height: 10),
                        Text(
                          perfect ? 'Perfect Score!' : 'Story Complete!',
                          style: GoogleFonts.baloo2(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0;
                                i < story.decisions.length;
                                i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  i < starsEarned ? '⭐' : '☆',
                                  style: const TextStyle(
                                      fontSize: 28, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    children: [
                      // Score breakdown
                      Row(
                        children: [
                          _ScoreTile(
                            value: '$starsEarned/${story.decisions.length}',
                            label: 'Stars',
                            color: const Color(0xFFF39C12),
                          ),
                          const SizedBox(width: 12),
                          _ScoreTile(
                            value: '$safeCount',
                            label: 'Safe choices',
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          _ScoreTile(
                            value:
                                '${choiceResults.length - safeCount}',
                            label: 'Risky choices',
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppShadows.card,
                        ),
                        child: Text(
                          story.endSummary.en,
                          textAlign: TextAlign.center,
                          style: AppText.bodyLarge(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Back to Stories',
                        onTap: () =>
                            Navigator.popUntil(context, (r) => r.isFirst),
                        gradient: AppColors.headerGradient,
                        leading: const Icon(Icons.home_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 12),
                      AppOutlinedButton(
                        label: 'Play Again',
                        color: AppColors.primary,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  StoryScreen(story: story)),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const HelpButton(),
        ],
      ),
    );
  }
}

// ─── Shared sub-widgets ────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool dark;
  const _BackButton({required this.onTap, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: dark
              ? AppColors.surfaceVariant
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: dark ? AppColors.textDark : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String text;
  final bool isSafe;
  final VoidCallback onTap;

  const _ChoiceButton(
      {required this.text, required this.isSafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSafe ? AppColors.success : AppColors.warning,
            width: 2,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSafe
                    ? AppColors.successLight
                    : AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSafe
                    ? Icons.check_rounded
                    : Icons.help_outline_rounded,
                size: 18,
                color: isSafe
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppText.headingSmall().copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _ScoreTile(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color)),
            Text(label,
                style: AppText.caption()
                    .copyWith(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
