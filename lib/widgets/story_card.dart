import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/story_data.dart';
import '../theme/app_theme.dart';

class StoryCard extends StatefulWidget {
  final Story story;
  final bool completed;
  final int starsEarned;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.completed,
    required this.starsEarned,
    required this.onTap,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scale;

  static const List<List<Color>> _gradients = [
    AppColors.story1,
    AppColors.story2,
    AppColors.story3,
  ];

  static const List<String> _tags = [
    'Stranger Danger',
    'Online Safety',
    'Peer Pressure',
  ];

  @override
  void initState() {
    super.initState();
    _scale = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _scale.reverse();
  void _onTapUp(TapUpDetails _) {
    _scale.forward();
    widget.onTap();
  }

  void _onTapCancel() => _scale.forward();

  int get _idx {
    final n = int.tryParse(widget.story.id.split('_').last) ?? 1;
    return (n - 1) % _gradients.length;
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _gradients[_idx];
    final tag = _tags[_idx];
    final maxStars = widget.story.decisions.length;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Big emoji in a white pill
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(widget.story.emoji,
                            style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tag chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.baloo2(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.story.title.en,
                            style: GoogleFonts.baloo2(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Bottom row: character + stars/progress
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.story.characterName}, ${widget.story.characterAge}',
                        style: GoogleFonts.baloo2(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (widget.completed)
                      Row(
                        children: [
                          for (int i = 0; i < maxStars; i++)
                            Text(
                              i < widget.starsEarned ? '⭐' : '☆',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                        ],
                      )
                    else
                      Text(
                        '$maxStars decisions',
                        style: GoogleFonts.baloo2(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
