// lib/screens/calculator_screen.dart
// Root screen — composes display + button grid

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/calculator_provider.dart';
import '../widgets/calc_display.dart';
import '../widgets/button_grid.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend behind status bar for full-bleed look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Minimal app bar — just the title, very subtle
        title: Text(
          'CALC',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 4,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white24
                : Colors.black26,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Display (takes remaining space above buttons) ───────────
            Expanded(
              child: Consumer<CalculatorProvider>(
                builder: (context, calc, _) => CalcDisplay(
                  display: calc.display,
                  expression: calc.expression,
                  hasError: calc.hasError,
                ),
              ),
            ),

            // ── Divider ────────────────────────────────────────────────
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.06),
            ),

            // ── Button grid ────────────────────────────────────────────
            const ButtonGrid(),
          ],
        ),
      ),
    );
  }
}
