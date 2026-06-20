import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';
import '../widgets/help_button.dart';
import '../widgets/story_card.dart';
import 'story_screen.dart';
import 'badges_screen.dart';
import 'pin_gate_screen.dart';
import 'parent_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _totalStars = 0;
  int _completedCount = 0;
  Map<String, int> _storyStars = {};
  Map<String, bool> _storyCompleted = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final stars = <String, int>{};
    final completed = <String, bool>{};
    int total = 0;
    int completedCount = 0;
    for (final story in allStories) {
      final s = prefs.getInt('stars_${story.id}') ?? 0;
      stars[story.id] = s;
      final c = prefs.getBool('completed_${story.id}') ?? false;
      completed[story.id] = c;
      total += s;
      if (c) completedCount++;
    }
    setState(() {
      _storyStars = stars;
      _storyCompleted = completed;
      _totalStars = total;
      _completedCount = completedCount;
    });
  }

  void _openDashboard({
    required String title,
    required String subtitle,
    required String pinKey,
    required List<Color> gradient,
    required Widget Function(BuildContext) builder,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinGateScreen(
          title: title,
          subtitle: subtitle,
          pinKey: pinKey,
          gradient: gradient,
          destinationBuilder: builder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(context)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text('Choose your story',
                      style: AppText.headingMedium()),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final story = allStories[i];
                    return StoryCard(
                      story: story,
                      completed: _storyCompleted[story.id] ?? false,
                      starsEarned: _storyStars[story.id] ?? 0,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StoryScreen(story: story)),
                        );
                        _loadProgress();
                      },
                    );
                  },
                  childCount: allStories.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _buildBadgesCard(context),
                ),
              ),
              // Dashboards section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                  child: Row(
                    children: [
                      Text('Dashboards', style: AppText.headingMedium()),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('PIN protected',
                            style: AppText.caption()
                                .copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _DashboardCard(
                      icon: '👨‍👩‍👧',
                      title: 'Parent / Guardian',
                      subtitle: 'View your child\'s progress and choices',
                      gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                      onTap: () => _openDashboard(
                        title: 'Parent Dashboard',
                        subtitle: 'Enter your PIN to continue',
                        pinKey: 'parent_pin',
                        gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                        builder: (_) => const ParentDashboardScreen(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DashboardCard(
                      icon: '👩‍🏫',
                      title: 'Teacher',
                      subtitle: 'Track student safety awareness',
                      gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                      onTap: () => _openDashboard(
                        title: 'Teacher Dashboard',
                        subtitle: 'Enter your PIN to continue',
                        pinKey: 'teacher_pin',
                        gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                        builder: (_) => const TeacherDashboardScreen(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DashboardCard(
                      icon: '🏛️',
                      title: 'Government / Agency',
                      subtitle: 'Aggregate analytics and engagement data',
                      gradient: const [Color(0xFFF7971E), Color(0xFFFFD200)],
                      onTap: () => _openDashboard(
                        title: 'Analytics Overview',
                        subtitle: 'Enter agency PIN to continue',
                        pinKey: 'gov_pin',
                        gradient: const [Color(0xFFF7971E), Color(0xFFFFD200)],
                        builder: (_) => const GovAnalyticsScreen(),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          const HelpButton(),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final maxStars =
        allStories.fold<int>(0, (sum, s) => sum + s.decisions.length);
    final progress = maxStars == 0 ? 0.0 : _totalStars / maxStars;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
              color: Color(0x30000000), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('🛡️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'SafeSteps',
                    style: GoogleFonts.baloo2(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BadgesScreen()),
                      );
                      _loadProgress();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            '$_totalStars stars',
                            style: GoogleFonts.baloo2(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Learn to stay safe,\none story at a time.',
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _StatChip(
                      value: '$_completedCount/${allStories.length}',
                      label: 'Stories'),
                  const SizedBox(width: 10),
                  _StatChip(value: '$_totalStars', label: 'Stars'),
                  const SizedBox(width: 10),
                  _StatChip(
                      value: '${(progress * 100).round()}%',
                      label: 'Complete'),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.toDouble(),
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgesCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BadgesScreen()),
        );
        _loadProgress();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Badges', style: AppText.headingSmall()),
                  const SizedBox(height: 2),
                  Text('Tap to see what you\'ve unlocked',
                      style: AppText.caption()),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: AppColors.textMid),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dashboard card ────────────────────────────────────────────────────────

class _DashboardCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.headingSmall()),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppText.caption()),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('PIN',
                      style: AppText.caption().copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat chip ─────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.baloo2(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.baloo2(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
