import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';
import '../widgets/help_button.dart';

class _BadgeDef {
  final String emoji;
  final String name;
  final String description;
  final List<Color> gradient;
  const _BadgeDef(this.emoji, this.name, this.description, this.gradient);
}

const _badges = [
  _BadgeDef('⭐', 'Safety Star', 'Complete any 1 story',
      [Color(0xFFF7971E), Color(0xFFFFD200)]),
  _BadgeDef('🧠', 'Smart Chooser', 'Make 5 safe choices total',
      [Color(0xFF667EEA), Color(0xFF764BA2)]),
  _BadgeDef('🏆', 'Story Master', 'Complete all 3 stories',
      [Color(0xFF11998E), Color(0xFF38EF7D)]),
];

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  int _totalStars = 0;
  int _totalSafeChoices = 0;
  int _completedStories = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int total = 0;
    int completed = 0;
    for (final story in allStories) {
      total += prefs.getInt('stars_${story.id}') ?? 0;
      if (prefs.getBool('completed_${story.id}') ?? false) completed++;
    }
    setState(() {
      _totalStars = total;
      _totalSafeChoices = prefs.getInt('total_safe_choices') ?? 0;
      _completedStories = completed;
    });
  }

  List<bool> get _unlocked => [
        _completedStories >= 1,
        _totalSafeChoices >= 5,
        _completedStories >= allStories.length,
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              GradientHeader(
                title: 'My Badges',
                subtitle: 'Keep playing to unlock more!',
                colors: const [Color(0xFFF7971E), Color(0xFFFFD200)],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    children: [
                      // Stats row
                      Row(
                        children: [
                          _MiniStat(
                              value: '$_totalStars',
                              label: 'Stars',
                              color: const Color(0xFFF39C12)),
                          const SizedBox(width: 12),
                          _MiniStat(
                              value: '$_totalSafeChoices',
                              label: 'Safe choices',
                              color: AppColors.success),
                          const SizedBox(width: 12),
                          _MiniStat(
                              value: '$_completedStories/${allStories.length}',
                              label: 'Stories done',
                              color: AppColors.primary),
                        ],
                      ),
                      const SizedBox(height: 24),
                      for (int i = 0; i < _badges.length; i++) ...[
                        _BadgeCard(
                            badge: _badges[i], unlocked: _unlocked[i]),
                        if (i < _badges.length - 1)
                          const SizedBox(height: 14),
                      ],
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

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.baloo2(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: AppText.caption()),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatefulWidget {
  final _BadgeDef badge;
  final bool unlocked;
  const _BadgeCard({required this.badge, required this.unlocked});

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.97,
      upperBound: 1.03,
    );
    if (widget.unlocked) _bounce.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: widget.unlocked
            ? LinearGradient(colors: widget.badge.gradient)
            : null,
        color: widget.unlocked ? null : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(22),
        boxShadow: widget.unlocked
            ? [
                BoxShadow(
                  color: widget.badge.gradient.first.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: widget.unlocked
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                widget.badge.emoji,
                style: TextStyle(
                  fontSize: 30,
                  color: widget.unlocked ? null : const Color(0xFFCCCCCC),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.badge.name,
                  style: GoogleFonts.baloo2(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: widget.unlocked ? Colors.white : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.badge.description,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    color: widget.unlocked
                        ? Colors.white70
                        : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.unlocked
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.unlocked
                  ? Icons.check_rounded
                  : Icons.lock_outline_rounded,
              size: 18,
              color: widget.unlocked
                  ? Colors.white
                  : AppColors.textLight,
            ),
          ),
        ],
      ),
    );

    if (!widget.unlocked) return card;
    return ScaleTransition(scale: _bounce, child: card);
  }
}
