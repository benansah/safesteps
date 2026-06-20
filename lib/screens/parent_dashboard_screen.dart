import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';
import '../widgets/help_button.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  String _studentName = 'Your child';
  int _totalStars = 0;
  int _completedCount = 0;
  int _totalSafe = 0;
  int _totalRisky = 0;
  int _totalSessions = 0;
  String _lastPlayed = '';
  final Map<String, _StoryStats> _storyStats = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int stars = 0;
    int completed = 0;
    for (final s in allStories) {
      stars += prefs.getInt('stars_${s.id}') ?? 0;
      final c = prefs.getBool('completed_${s.id}') ?? false;
      if (c) completed++;
      _storyStats[s.id] = _StoryStats(
        completed: c,
        stars: prefs.getInt('stars_${s.id}') ?? 0,
        maxStars: s.decisions.length,
        safe: prefs.getInt('safe_${s.id}') ?? 0,
        risky: prefs.getInt('risky_${s.id}') ?? 0,
      );
    }
    setState(() {
      _studentName = prefs.getString('student_name') ?? 'Your child';
      _totalStars = stars;
      _completedCount = completed;
      _totalSafe = prefs.getInt('total_safe_choices') ?? 0;
      _totalRisky = prefs.getInt('total_risky_choices') ?? 0;
      _totalSessions = prefs.getInt('total_sessions') ?? 0;
      _lastPlayed = prefs.getString('last_played') ?? '';
    });
  }

  int get _totalChoices => _totalSafe + _totalRisky;
  double get _safeRate =>
      _totalChoices == 0 ? 0 : _totalSafe / _totalChoices;

  String get _lastPlayedTitle {
    if (_lastPlayed.isEmpty) return 'Not yet played';
    try {
      return allStories.firstWhere((s) => s.id == _lastPlayed).title.en;
    } catch (_) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              GradientHeader(
                title: 'Parent Dashboard',
                subtitle: _studentName,
                colors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    children: [
                      // Quick stats
                      _SectionLabel('Overview'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _StatCard(
                              icon: '📚',
                              value:
                                  '$_completedCount/${allStories.length}',
                              label: 'Stories\nCompleted',
                              color: AppColors.primary),
                          const SizedBox(width: 12),
                          _StatCard(
                              icon: '⭐',
                              value: '$_totalStars',
                              label: 'Stars\nEarned',
                              color: const Color(0xFFF39C12)),
                          const SizedBox(width: 12),
                          _StatCard(
                              icon: '🎮',
                              value: '$_totalSessions',
                              label: 'Total\nSessions',
                              color: AppColors.success),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Safe choices rate
                      _SectionLabel('Safe Choice Rate'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(_safeRate * 100).round()}% safe choices',
                                  style: AppText.headingSmall().copyWith(
                                      color: AppColors.success),
                                ),
                                Text(
                                  '$_totalSafe safe · $_totalRisky risky',
                                  style: AppText.caption(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _safeRate,
                                minHeight: 12,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                        AppColors.success),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _safeRate >= 0.8
                                  ? '🌟 Excellent! $_studentName is making very safe choices.'
                                  : _safeRate >= 0.5
                                      ? '👍 Good progress. Keep practising to improve safety awareness.'
                                      : '💙 $_studentName is learning. Consider discussing the stories together.',
                              style: AppText.bodyMedium(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Per-story breakdown
                      _SectionLabel('Story Breakdown'),
                      const SizedBox(height: 10),
                      for (final story in allStories)
                        _StoryBreakdownCard(
                          story: story,
                          stats: _storyStats[story.id] ??
                              _StoryStats(
                                  completed: false,
                                  stars: 0,
                                  maxStars: story.decisions.length,
                                  safe: 0,
                                  risky: 0),
                        ),
                      const SizedBox(height: 20),
                      // Last activity
                      _SectionLabel('Last Activity'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: Row(
                          children: [
                            const Text('🕐',
                                style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Last story played',
                                    style: AppText.caption()),
                                Text(_lastPlayedTitle,
                                    style: AppText.headingSmall()),
                              ],
                            ),
                          ],
                        ),
                      ),
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

// ─── Teacher Dashboard ─────────────────────────────────────────────────────
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends State<TeacherDashboardScreen> {
  String _studentName = 'Student';
  int _totalStars = 0;
  int _completedCount = 0;
  int _totalSafe = 0;
  int _totalRisky = 0;
  int _totalSessions = 0;
  final Map<String, _StoryStats> _storyStats = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int stars = 0;
    int completed = 0;
    for (final s in allStories) {
      stars += prefs.getInt('stars_${s.id}') ?? 0;
      final c = prefs.getBool('completed_${s.id}') ?? false;
      if (c) completed++;
      _storyStats[s.id] = _StoryStats(
        completed: c,
        stars: prefs.getInt('stars_${s.id}') ?? 0,
        maxStars: s.decisions.length,
        safe: prefs.getInt('safe_${s.id}') ?? 0,
        risky: prefs.getInt('risky_${s.id}') ?? 0,
      );
    }
    setState(() {
      _studentName = prefs.getString('student_name') ?? 'Student';
      _totalStars = stars;
      _completedCount = completed;
      _totalSafe = prefs.getInt('total_safe_choices') ?? 0;
      _totalRisky = prefs.getInt('total_risky_choices') ?? 0;
      _totalSessions = prefs.getInt('total_sessions') ?? 0;
    });
  }

  int get _totalChoices => _totalSafe + _totalRisky;
  double get _safeRate =>
      _totalChoices == 0 ? 0 : _totalSafe / _totalChoices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              GradientHeader(
                title: 'Teacher Dashboard',
                subtitle: 'Student: $_studentName',
                colors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    children: [
                      // Summary row
                      _SectionLabel('Student Summary'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _StatCard(
                              icon: '📚',
                              value:
                                  '$_completedCount/${allStories.length}',
                              label: 'Stories\nDone',
                              color: AppColors.primary),
                          const SizedBox(width: 12),
                          _StatCard(
                              icon: '✅',
                              value: '$_totalSafe',
                              label: 'Safe\nChoices',
                              color: AppColors.success),
                          const SizedBox(width: 12),
                          _StatCard(
                              icon: '⚠️',
                              value: '$_totalRisky',
                              label: 'Risky\nChoices',
                              color: AppColors.warning),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Bar chart per story
                      _SectionLabel('Safe Choice Rate per Story'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          children: [
                            for (final story in allStories)
                              _StoryBarRow(
                                story: story,
                                stats: _storyStats[story.id] ??
                                    _StoryStats(
                                        completed: false,
                                        stars: 0,
                                        maxStars: story.decisions.length,
                                        safe: 0,
                                        risky: 0),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Overall rate card
                      _SectionLabel('Overall Performance'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Overall safe choice rate',
                                          style: AppText.caption()),
                                      Text(
                                        '${(_safeRate * 100).round()}%',
                                        style: AppText.displayLarge()
                                            .copyWith(
                                          color: _safeRate >= 0.7
                                              ? AppColors.success
                                              : AppColors.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _RatingBadge(rate: _safeRate),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _safeRate,
                                minHeight: 14,
                                backgroundColor: AppColors.surfaceVariant,
                                valueColor: AlwaysStoppedAnimation(
                                  _safeRate >= 0.7
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _safeRate >= 0.8
                                  ? '🏅 Excellent performance. This student demonstrates strong safety awareness.'
                                  : _safeRate >= 0.5
                                      ? '📝 Good progress. Consider reviewing risky scenarios in class discussions.'
                                      : '⚠️ Additional support may be needed. Consider a one-on-one review of the stories.',
                              style: AppText.bodyMedium(),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline_rounded,
                                      size: 16, color: AppColors.textMid),
                                  const SizedBox(width: 8),
                                  Text(
                                      'Total sessions completed: $_totalSessions  •  Stars: $_totalStars',
                                      style: AppText.caption()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

// ─── Government Analytics Screen ──────────────────────────────────────────
class GovAnalyticsScreen extends StatefulWidget {
  const GovAnalyticsScreen({super.key});

  @override
  State<GovAnalyticsScreen> createState() => _GovAnalyticsScreenState();
}

class _GovAnalyticsScreenState extends State<GovAnalyticsScreen> {
  String _studentName = 'Student';
  int _completedCount = 0;
  int _totalSafe = 0;
  int _totalRisky = 0;
  int _totalSessions = 0;
  int _badgesEarned = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int completed = 0;
    for (final s in allStories) {
      if (prefs.getBool('completed_${s.id}') ?? false) completed++;
    }
    final safe = prefs.getInt('total_safe_choices') ?? 0;
    final risky = prefs.getInt('total_risky_choices') ?? 0;
    final sessions = prefs.getInt('total_sessions') ?? 0;
    // Badge unlock logic mirrored from badges_screen.dart
    int badges = 0;
    if (completed >= 1) badges++;
    if (safe >= 5) badges++;
    if (completed >= allStories.length) badges++;
    setState(() {
      _studentName = prefs.getString('student_name') ?? 'Student';
      _completedCount = completed;
      _totalSafe = safe;
      _totalRisky = risky;
      _totalSessions = sessions;
      _badgesEarned = badges;
    });
  }

  int get _totalChoices => _totalSafe + _totalRisky;
  double get _safeRate =>
      _totalChoices == 0 ? 0 : _totalSafe / _totalChoices;
  double get _completionRate => allStories.isEmpty
      ? 0
      : _completedCount / allStories.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Column(
            children: [
              GradientHeader(
                title: 'Analytics Overview',
                subtitle: 'Government / Agency View',
                colors: const [Color(0xFFF7971E), Color(0xFFFFD200)],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding:
                        const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    children: [
                      // Device banner
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.smartphone_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Showing single-device data for: $_studentName. For aggregate analytics across devices, a backend integration is required.',
                                style: AppText.caption()
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // KPI grid
                      _SectionLabel('Key Indicators'),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _KpiCard(
                            icon: '🎮',
                            value: '$_totalSessions',
                            label: 'Total Sessions',
                            color: AppColors.primary,
                          ),
                          _KpiCard(
                            icon: '📚',
                            value: '$_completedCount/${allStories.length}',
                            label: 'Stories Completed',
                            color: const Color(0xFF667EEA),
                          ),
                          _KpiCard(
                            icon: '✅',
                            value: '$_totalSafe',
                            label: 'Safe Choices',
                            color: AppColors.success,
                          ),
                          _KpiCard(
                            icon: '🏆',
                            value: '$_badgesEarned/3',
                            label: 'Badges Earned',
                            color: const Color(0xFFF7971E),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Engagement rates
                      _SectionLabel('Engagement Metrics'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          children: [
                            _MetricRow(
                              label: 'Safe Choice Rate',
                              value: '${(_safeRate * 100).round()}%',
                              progress: _safeRate,
                              color: AppColors.success,
                            ),
                            const SizedBox(height: 16),
                            _MetricRow(
                              label: 'Story Completion Rate',
                              value:
                                  '${(_completionRate * 100).round()}%',
                              progress: _completionRate,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            _MetricRow(
                              label: 'Badge Achievement Rate',
                              value:
                                  '${(_badgesEarned / 3 * 100).round()}%',
                              progress: _badgesEarned / 3,
                              color: const Color(0xFFF7971E),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Story-level data
                      _SectionLabel('Story-Level Breakdown'),
                      const SizedBox(height: 10),
                      for (final story in allStories)
                        _GovStoryRow(story: story),
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

// ─── Shared Sub-widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppText.headingSmall());
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.baloo2(
                    fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                textAlign: TextAlign.center,
                style: AppText.caption()),
          ],
        ),
      ),
    );
  }
}

class _StoryStats {
  final bool completed;
  final int stars;
  final int maxStars;
  final int safe;
  final int risky;
  const _StoryStats({
    required this.completed,
    required this.stars,
    required this.maxStars,
    required this.safe,
    required this.risky,
  });
  int get total => safe + risky;
  double get safeRate => total == 0 ? 0 : safe / total;
}

class _StoryBreakdownCard extends StatelessWidget {
  final Story story;
  final _StoryStats stats;
  const _StoryBreakdownCard(
      {required this.story, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Text(story.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title.en, style: AppText.headingSmall()),
                const SizedBox(height: 4),
                if (stats.completed)
                  Text(
                    '${stats.stars}/${stats.maxStars} stars  ·  ${stats.safe} safe  ·  ${stats.risky} risky',
                    style: AppText.caption(),
                  )
                else
                  Text('Not yet completed', style: AppText.caption()),
                if (stats.completed && stats.total > 0) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: stats.safeRate,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation(
                        stats.safeRate >= 0.7
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: stats.completed
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              stats.completed ? '✅ Done' : '🔒 Locked',
              style: AppText.caption().copyWith(
                color: stats.completed
                    ? AppColors.success
                    : AppColors.textLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryBarRow extends StatelessWidget {
  final Story story;
  final _StoryStats stats;
  const _StoryBarRow({required this.story, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(story.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title.en,
                    style: AppText.caption()
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: stats.safeRate,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(
                      stats.completed ? AppColors.success : AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            stats.completed
                ? '${(stats.safeRate * 100).round()}%'
                : 'N/A',
            style: AppText.caption().copyWith(
              fontWeight: FontWeight.w700,
              color: stats.completed ? AppColors.success : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rate;
  const _RatingBadge({required this.rate});

  @override
  Widget build(BuildContext context) {
    final label = rate >= 0.8
        ? 'Excellent'
        : rate >= 0.5
            ? 'Good'
            : 'Needs Support';
    final color = rate >= 0.8
        ? AppColors.success
        : rate >= 0.5
            ? AppColors.warning
            : AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: AppText.caption()
              .copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  const _KpiCard(
      {required this.icon,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color)),
              Text(label, style: AppText.caption()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;
  const _MetricRow(
      {required this.label,
      required this.value,
      required this.progress,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppText.bodyMedium()),
            Text(value,
                style: AppText.headingSmall().copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _GovStoryRow extends StatefulWidget {
  final Story story;
  const _GovStoryRow({required this.story});

  @override
  State<_GovStoryRow> createState() => _GovStoryRowState();
}

class _GovStoryRowState extends State<_GovStoryRow> {
  bool _completed = false;
  int _stars = 0;
  int _safe = 0;
  int _risky = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completed = prefs.getBool('completed_${widget.story.id}') ?? false;
      _stars = prefs.getInt('stars_${widget.story.id}') ?? 0;
      _safe = prefs.getInt('safe_${widget.story.id}') ?? 0;
      _risky = prefs.getInt('risky_${widget.story.id}') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Text(widget.story.emoji,
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.story.title.en, style: AppText.headingSmall()),
                Text(
                  _completed
                      ? '$_stars/${widget.story.decisions.length} stars · $_safe safe · $_risky risky'
                      : 'Not yet attempted',
                  style: AppText.caption(),
                ),
              ],
            ),
          ),
          Icon(
            _completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: _completed ? AppColors.success : AppColors.textLight,
            size: 22,
          ),
        ],
      ),
    );
  }
}
