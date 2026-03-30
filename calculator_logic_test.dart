// test/calculator_logic_test.dart
// Unit tests for the core calculation engine

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator/logic/calculator_logic.dart';

void main() {
  // Helper to run a sequence of actions from an initial state
  CalculatorState run(List<CalculatorAction> actions) {
    var state = const CalculatorState();
    for (final action in actions) {
      state = CalculatorLogic.process(state, action);
    }
    return state;
  }

  group('Digit input', () {
    test('Single digit', () {
      final s = run([CalculatorAction.five]);
      expect(s.display, '5');
    });

    test('Multi-digit', () {
      final s = run([
        CalculatorAction.one,
        CalculatorAction.two,
        CalculatorAction.three,
      ]);
      expect(s.display, '123');
    });

    test('Leading zero replaced', () {
      final s = run([CalculatorAction.zero, CalculatorAction.five]);
      expect(s.display, '5');
    });
  });

  group('Basic arithmetic', () {
    test('Addition: 3 + 4 = 7', () {
      final s = run([
        CalculatorAction.three,
        CalculatorAction.add,
        CalculatorAction.four,
        CalculatorAction.equals,
      ]);
      expect(s.display, '7');
    });

    test('Subtraction: 10 − 3 = 7', () {
      final s = run([
        CalculatorAction.one,
        CalculatorAction.zero,
        CalculatorAction.subtract,
        CalculatorAction.three,
        CalculatorAction.equals,
      ]);
      expect(s.display, '7');
    });

    test('Multiplication: 6 × 7 = 42', () {
      final s = run([
        CalculatorAction.six,
        CalculatorAction.multiply,
        CalculatorAction.seven,
        CalculatorAction.equals,
      ]);
      expect(s.display, '42');
    });

    test('Division: 8 ÷ 2 = 4', () {
      final s = run([
        CalculatorAction.eight,
        CalculatorAction.divide,
        CalculatorAction.two,
        CalculatorAction.equals,
      ]);
      expect(s.display, '4');
    });
  });

  group('Edge cases', () {
    test('Division by zero returns Error', () {
      final s = run([
        CalculatorAction.five,
        CalculatorAction.divide,
        CalculatorAction.zero,
        CalculatorAction.equals,
      ]);
      expect(s.display, 'Error');
    });

    test('Decimal input: 1.5 + 1.5 = 3', () {
      final s = run([
        CalculatorAction.one,
        CalculatorAction.decimal,
        CalculatorAction.five,
        CalculatorAction.add,
        CalculatorAction.one,
        CalculatorAction.decimal,
        CalculatorAction.five,
        CalculatorAction.equals,
      ]);
      expect(s.display, '3');
    });

    test('Clear resets state', () {
      final s = run([
        CalculatorAction.nine,
        CalculatorAction.add,
        CalculatorAction.one,
        CalculatorAction.clear,
      ]);
      expect(s.display, '0');
      expect(s.expression, '');
    });

    test('Backspace removes last digit', () {
      final s = run([
        CalculatorAction.one,
        CalculatorAction.two,
        CalculatorAction.three,
        CalculatorAction.backspace,
      ]);
      expect(s.display, '12');
    });

    test('Toggle sign: 5 → −5', () {
      final s = run([
        CalculatorAction.five,
        CalculatorAction.toggleSign,
      ]);
      expect(s.display, '-5');
    });

    test('Percent: 50% = 0.5', () {
      final s = run([
        CalculatorAction.five,
        CalculatorAction.zero,
        CalculatorAction.percent,
      ]);
      expect(s.display, '0.5');
    });
  });
}
