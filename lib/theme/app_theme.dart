import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette ───────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5B4FD9);
  static const Color primaryLight = Color(0xFF7B6FFF);
  static const Color primaryDark = Color(0xFF3D34A5);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentLight = Color(0xFFFF9A9E);

  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFFE8F8EE);
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFFF4E0);
  static const Color danger = Color(0xFFE74C3C);

  static const Color bg = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1FA);

  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMid = Color(0xFF4A4A6A);
  static const Color textLight = Color(0xFF9B9BB4);

  // Story card gradients
  static const List<Color> story1 = [Color(0xFFFF6B6B), Color(0xFFFFD93D)];
  static const List<Color> story2 = [Color(0xFF667EEA), Color(0xFF764BA2)];
  static const List<Color> story3 = [Color(0xFF43E97B), Color(0xFF38F9D7)];

  // Header gradient
  static const List<Color> headerGradient = [
    Color(0xFF5B4FD9),
    Color(0xFF9B59B6),
  ];

  static const List<Color> helpGradient = [
    Color(0xFF1A1A4E),
    Color(0xFF003F5C),
  ];
}

// ─── Text Styles ───────────────────────────────────────────────────────────
class AppText {
  AppText._();

  static TextStyle displayLarge() => GoogleFonts.baloo2(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
        height: 1.1,
      );

  static TextStyle headingLarge() => GoogleFonts.baloo2(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      );

  static TextStyle headingMedium() => GoogleFonts.baloo2(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  static TextStyle headingSmall() => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  static TextStyle bodyLarge() => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
        height: 1.65,
      );

  static TextStyle bodyMedium() => GoogleFonts.baloo2(
        fontSize: 14,
        color: AppColors.textMid,
        height: 1.5,
      );

  static TextStyle caption() => GoogleFonts.baloo2(
        fontSize: 12,
        color: AppColors.textLight,
      );

  static TextStyle buttonLabel() => GoogleFonts.baloo2(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      );
}

// ─── Shadows ───────────────────────────────────────────────────────────────
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x18000000), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(color: Color(0x30000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> fab = [
    BoxShadow(color: Color(0x44000000), blurRadius: 12, offset: Offset(0, 5)),
  ];
}

// ─── ThemeData ─────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: GoogleFonts.baloo2TextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: AppColors.textDark),
      titleTextStyle: AppText.headingMedium(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppText.buttonLabel(),
        elevation: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────

// Full-width gradient primary button.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final List<Color> gradient;
  final double height;
  final Widget? leading;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.gradient = AppColors.headerGradient,
    this.height = 56,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: onTap != null ? gradient : [Colors.grey.shade300, Colors.grey.shade400],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: onTap != null ? AppShadows.button : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(label,
                style: AppText.buttonLabel().copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// Outlined / ghost button.
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label,
              style: AppText.buttonLabel().copyWith(color: color)),
        ),
      ),
    );
  }
}

// Shared screen header with gradient background + back button.
class GradientHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Color> colors;
  final bool showBack;
  final List<Widget> actions;

  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.colors = AppColors.headerGradient,
    this.showBack = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x30000000), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              if (showBack) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.baloo2(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        )),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: GoogleFonts.baloo2(
                            fontSize: 13,
                            color: Colors.white70,
                          )),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
