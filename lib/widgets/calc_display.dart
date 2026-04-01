// lib/widgets/calc_display.dart
// Animated display area — expression line + main result

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CalcDisplay extends StatelessWidget {
  const CalcDisplay({
    super.key,
    required this.display,
    required this.expression,
    required this.hasError,
  });

  final String display;
  final String expression;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // ── Expression row (smaller, muted) ──────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOut)),
                  child: child,
                ),
              );
            },
            child: Text(
              expression,
              key: ValueKey(expression),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: isDark
                    ? CalcColors.darkExprFg
                    : CalcColors.lightExprFg,
                letterSpacing: -0.3,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ── Main display (large, animated) ───────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOut)),
                  child: child,
                ),
              );
            },
            child: Text(
              display,
              key: ValueKey(display),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.dmSans(
                fontSize: _displayFontSize(display),
                fontWeight: FontWeight.w200,
                color: hasError
                    ? Colors.redAccent.shade100
                    : (isDark
                        ? CalcColors.darkDisplayFg
                        : CalcColors.lightDisplayFg),
                letterSpacing: -3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Scale font down for longer numbers
  double _displayFontSize(String value) {
    if (value.length > 12) return 32;
    if (value.length > 9) return 48;
    if (value.length > 6) return 60;
    return 72;
  }
}
