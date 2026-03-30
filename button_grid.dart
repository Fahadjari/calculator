// lib/widgets/button_grid.dart
// Complete button grid — maps every button to a CalculatorAction

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/calculator_logic.dart';
import '../logic/calculator_provider.dart';
import '../theme/app_theme.dart';
import 'calc_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CalculatorProvider>();

    // Helper to dispatch an action
    void dispatch(CalculatorAction action) => provider.dispatch(action);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        children: [
          // ── Row 1: C  +/-  %  ÷ ──────────────────────────────────────
          _Row(children: [
            CalcButton(
              label: 'C',
              type: ButtonType.function,
              onTap: () => dispatch(CalculatorAction.clear),
            ),
            CalcButton(
              label: '+/−',
              type: ButtonType.function,
              onTap: () => dispatch(CalculatorAction.toggleSign),
              fontSize: 20,
            ),
            CalcButton(
              label: '%',
              type: ButtonType.function,
              onTap: () => dispatch(CalculatorAction.percent),
            ),
            CalcButton(
              label: '÷',
              type: ButtonType.operator,
              onTap: () => dispatch(CalculatorAction.divide),
            ),
          ]),

          // ── Row 2: 7  8  9  × ────────────────────────────────────────
          _Row(children: [
            CalcButton(
              label: '7',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.seven),
            ),
            CalcButton(
              label: '8',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.eight),
            ),
            CalcButton(
              label: '9',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.nine),
            ),
            CalcButton(
              label: '×',
              type: ButtonType.operator,
              onTap: () => dispatch(CalculatorAction.multiply),
            ),
          ]),

          // ── Row 3: 4  5  6  − ────────────────────────────────────────
          _Row(children: [
            CalcButton(
              label: '4',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.four),
            ),
            CalcButton(
              label: '5',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.five),
            ),
            CalcButton(
              label: '6',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.six),
            ),
            CalcButton(
              label: '−',
              type: ButtonType.operator,
              onTap: () => dispatch(CalculatorAction.subtract),
            ),
          ]),

          // ── Row 4: 1  2  3  + ────────────────────────────────────────
          _Row(children: [
            CalcButton(
              label: '1',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.one),
            ),
            CalcButton(
              label: '2',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.two),
            ),
            CalcButton(
              label: '3',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.three),
            ),
            CalcButton(
              label: '+',
              type: ButtonType.operator,
              onTap: () => dispatch(CalculatorAction.add),
            ),
          ]),

          // ── Row 5: 0(wide)  .  ⌫  = ──────────────────────────────────
          _Row(children: [
            CalcButton(
              label: '0',
              type: ButtonType.number,
              flex: 1,
              onTap: () => dispatch(CalculatorAction.zero),
            ),
            CalcButton(
              label: '.',
              type: ButtonType.number,
              onTap: () => dispatch(CalculatorAction.decimal),
            ),
            // Backspace icon button
            CalcButton(
              label: '⌫',
              type: ButtonType.function,
              onTap: () => dispatch(CalculatorAction.backspace),
              icon: const Icon(Icons.backspace_outlined, size: 22),
            ),
            CalcButton(
              label: '=',
              type: ButtonType.equals,
              onTap: () => dispatch(CalculatorAction.equals),
            ),
          ]),
        ],
      ),
    );
  }
}

/// A single row of buttons
class _Row extends StatelessWidget {
  const _Row({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
