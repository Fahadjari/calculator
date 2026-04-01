// lib/widgets/calc_button.dart
// Reusable calculator button with scale + glow press animation

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A single calculator button.
///
/// Handles its own press animation (scale down + release) and
/// exposes [onTap] for the parent to handle logic dispatch.
class CalcButton extends StatefulWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
    this.flex = 1,
    this.icon,
    this.fontSize,
  });

  /// The text shown on the button (e.g. "7", "+", "=")
  final String label;

  /// Visual category determines colours
  final ButtonType type;

  /// Callback when button is pressed
  final VoidCallback onTap;

  /// Flex factor for wide buttons (e.g. "0" is flex 2)
  final int flex;

  /// Optional icon widget instead of text
  final Widget? icon;

  /// Custom font size override
  final double? fontSize;

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    widget.onTap();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = AppTheme.buttonColors(widget.type, brightness);
    final isEquals = widget.type == ButtonType.equals;

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: GestureDetector(
            onTap: _handleTap,
            onTapDown: (_) => _controller.forward(),
            onTapCancel: () => _controller.reverse(),
            child: Container(
              height: _buttonHeight(context),
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(22),
                boxShadow: isEquals
                    ? [
                        BoxShadow(
                          color: CalcColors.darkEqBg.withOpacity(0.35),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              brightness == Brightness.dark ? 0.3 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Center(
                child: widget.icon ??
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: widget.fontSize ?? _fontSize(widget.label),
                        fontWeight: isEquals
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: colors.fg,
                        letterSpacing: -0.5,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Adaptive button height based on screen
  double _buttonHeight(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    // Give more height on bigger screens
    if (h > 900) return 82;
    if (h > 750) return 74;
    return 66;
  }

  /// Auto-size font based on label content
  double _fontSize(String label) {
    if (label.length > 1) return 22;
    switch (label) {
      case '÷':
      case '×':
        return 28;
      case '+':
      case '−':
      case '=':
        return 30;
      default:
        return 26;
    }
  }
}
