// lib/logic/calculator_logic.dart
// Pure calculation logic — completely separated from UI

/// Represents the current state of the calculator
class CalculatorState {
  final String display;       // What's shown on the main display
  final String expression;    // The full expression (e.g. "12 + 5")
  final bool isResult;        // Whether the display is showing a result
  final bool hasError;        // Whether there's an error state

  const CalculatorState({
    this.display = '0',
    this.expression = '',
    this.isResult = false,
    this.hasError = false,
  });

  CalculatorState copyWith({
    String? display,
    String? expression,
    bool? isResult,
    bool? hasError,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      isResult: isResult ?? this.isResult,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// All possible button actions
enum CalculatorAction {
  zero, one, two, three, four, five, six, seven, eight, nine,
  decimal,
  add, subtract, multiply, divide,
  equals,
  clear,
  backspace,
  toggleSign,
  percent,
}

/// Core calculator logic — immutable, testable, side-effect-free
class CalculatorLogic {
  /// Maximum digits allowed in display
  static const int maxDigits = 12;

  /// Process an action and return the new state
  static CalculatorState process(CalculatorState state, CalculatorAction action) {
    switch (action) {
      case CalculatorAction.clear:
        return const CalculatorState();

      case CalculatorAction.backspace:
        return _handleBackspace(state);

      case CalculatorAction.equals:
        return _handleEquals(state);

      case CalculatorAction.add:
      case CalculatorAction.subtract:
      case CalculatorAction.multiply:
      case CalculatorAction.divide:
        return _handleOperator(state, action);

      case CalculatorAction.decimal:
        return _handleDecimal(state);

      case CalculatorAction.toggleSign:
        return _handleToggleSign(state);

      case CalculatorAction.percent:
        return _handlePercent(state);

      default:
        return _handleDigit(state, _actionToDigit(action));
    }
  }

  // ─── Digit Input ──────────────────────────────────────────────────────────

  static CalculatorState _handleDigit(CalculatorState state, String digit) {
    if (state.hasError) {
      return CalculatorState(display: digit, expression: digit);
    }

    // After showing a result, a digit starts a fresh expression.
    if (state.isResult) {
      return CalculatorState(display: digit, expression: digit, isResult: false);
    }

    // If user just tapped an operator, start a new operand.
    if (_endsWithOperator(state.expression)) {
      final expr = '${state.expression.trimRight()} $digit';
      return state.copyWith(display: digit, expression: expr, isResult: false);
    }

    // Prevent leading zeros (but allow "0.")
    if (state.display == '0' && digit != '.') {
      return state.copyWith(
        display: digit,
        expression: _replaceLastNumber(state.expression, digit),
      );
    }

    // Enforce max digit limit
    final rawDigits = state.display.replaceAll('-', '').replaceAll('.', '');
    if (rawDigits.length >= maxDigits) return state;

    final newDisplay = state.display + digit;
    return state.copyWith(
      display: newDisplay,
      expression: _replaceLastNumber(state.expression, newDisplay),
    );
  }

  // ─── Decimal Point ────────────────────────────────────────────────────────

  static CalculatorState _handleDecimal(CalculatorState state) {
    if (state.isResult) {
      return CalculatorState(display: '0.', expression: '0.');
    }
    if (state.hasError) {
      return const CalculatorState(display: '0.', expression: '0.');
    }
    if (_endsWithOperator(state.expression)) {
      final expr = '${state.expression.trimRight()} 0.';
      return state.copyWith(display: '0.', expression: expr);
    }
    // Don't add a second decimal point
    if (state.display.contains('.')) return state;

    final newDisplay = '${state.display}.';
    return state.copyWith(
      display: newDisplay,
      expression: state.expression.isEmpty
          ? newDisplay
          : _replaceLastNumber(state.expression, newDisplay),
    );
  }

  // ─── Operator ─────────────────────────────────────────────────────────────

  static CalculatorState _handleOperator(
      CalculatorState state, CalculatorAction action) {
    final opSymbol = _actionToOperator(action);
    if (state.hasError) return state;

    // If current display is a previous result, continue from that value.
    if (state.isResult) {
      return CalculatorState(
        display: state.display,
        expression: '${state.display} $opSymbol',
        isResult: false,
      );
    }

    // If there's already a pending complete expression, evaluate it first
    if (!state.isResult && _canEvaluate(state.expression)) {
      final evaluated = _evaluate(state.expression);
      if (evaluated == null) {
        return state.copyWith(display: 'Error', hasError: true);
      }
      final resultStr = _formatNumber(evaluated);
      return CalculatorState(
        display: resultStr,
        expression: '$resultStr $opSymbol',
        isResult: false,
      );
    }

    // Replace trailing operator if present
    final trimmed = state.expression.trimRight();
    if (_endsWithOperator(trimmed)) {
      final newExpr = '${trimmed.substring(0, trimmed.length - 1).trimRight()} $opSymbol';
      return state.copyWith(expression: newExpr, isResult: false);
    }

    // Append operator to current display/expression
    final currentNum = state.isResult ? state.display : state.display;
    final newExpr = state.expression.isEmpty
        ? '$currentNum $opSymbol'
        : '${state.expression} $opSymbol';

    return state.copyWith(
      expression: newExpr,
      isResult: false,
    );
  }

  // ─── Equals ───────────────────────────────────────────────────────────────

  static CalculatorState _handleEquals(CalculatorState state) {
    if (state.expression.isEmpty || state.hasError) return state;

    // Build the full expression (append current display if it's not already there)
    String fullExpr = state.expression;
    if (_endsWithOperator(fullExpr.trimRight())) {
      // Repeat last number (like real calculators)
      fullExpr = '$fullExpr ${state.display}';
    }

    if (!_canEvaluate(fullExpr)) return state;

    final result = _evaluate(fullExpr);
    if (result == null) {
      return const CalculatorState(display: 'Error', hasError: true);
    }

    final resultStr = _formatNumber(result);
    return CalculatorState(
      display: resultStr,
      expression: '$fullExpr =',
      isResult: true,
    );
  }

  // ─── Backspace ────────────────────────────────────────────────────────────

  static CalculatorState _handleBackspace(CalculatorState state) {
    if (state.isResult || state.hasError) {
      return const CalculatorState();
    }
    if (state.display.length <= 1 || state.display == '0') {
      return state.copyWith(
        display: '0',
        expression: _replaceLastNumber(state.expression, ''),
      );
    }
    final newDisplay = state.display.substring(0, state.display.length - 1);
    return state.copyWith(
      display: newDisplay,
      expression: _replaceLastNumber(state.expression, newDisplay),
    );
  }

  // ─── Toggle Sign ──────────────────────────────────────────────────────────

  static CalculatorState _handleToggleSign(CalculatorState state) {
    if (state.display == '0' || state.hasError) return state;
    final val = double.tryParse(state.display);
    if (val == null) return state;
    final newDisplay = _formatNumber(-val);
    return state.copyWith(
      display: newDisplay,
      expression: _replaceLastNumber(state.expression, newDisplay),
    );
  }

  // ─── Percent ──────────────────────────────────────────────────────────────

  static CalculatorState _handlePercent(CalculatorState state) {
    final val = double.tryParse(state.display);
    if (val == null) return state;
    final newDisplay = _formatNumber(val / 100);
    return state.copyWith(
      display: newDisplay,
      expression: _replaceLastNumber(state.expression, newDisplay),
    );
  }

  // ─── Evaluation Engine ────────────────────────────────────────────────────

  /// Parses and evaluates a simple infix expression like "12.5 + 3 × 4"
  static double? _evaluate(String expression) {
    try {
      // Normalise expression: remove trailing operator and "="
      String expr = expression
          .replaceAll('=', '')
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .trim();

      // Tokenise
      final tokens = _tokenise(expr);
      if (tokens == null || tokens.isEmpty) return null;

      // Evaluate using proper operator precedence (× and ÷ before + and -)
      return _evalTokens(tokens);
    } catch (_) {
      return null;
    }
  }

  static List<String>? _tokenise(String expr) {
    final regex = RegExp(r'(-?\d+\.?\d*)|([+\-*/])');
    final matches = regex.allMatches(expr);
    final tokens = matches.map((m) => m.group(0)!).toList();
    return tokens.isEmpty ? null : tokens;
  }

  /// Evaluate token list with precedence: *, / before +, -
  static double _evalTokens(List<String> tokens) {
    // First pass: resolve * and /
    final pass1 = <String>[...tokens];
    int i = 0;
    while (i < pass1.length) {
      if (pass1[i] == '*' || pass1[i] == '/') {
        final left = double.parse(pass1[i - 1]);
        final right = double.parse(pass1[i + 1]);
        final result = pass1[i] == '*' ? left * right : left / right;
        pass1.replaceRange(i - 1, i + 2, [result.toString()]);
        i = 0; // restart
      } else {
        i++;
      }
    }

    // Second pass: resolve + and -
    double result = double.parse(pass1[0]);
    int j = 1;
    while (j < pass1.length) {
      final op = pass1[j];
      final operand = double.parse(pass1[j + 1]);
      if (op == '+') {
        result += operand;
      } else if (op == '-') {
        result -= operand;
      }
      j += 2;
    }
    return result;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Format a double for display — remove unnecessary decimals
  static String _formatNumber(double value) {
    if (value.isInfinite) return 'Error';
    if (value.isNaN) return 'Error';

    // Check if it's a whole number
    if (value == value.truncateToDouble() && value.abs() < 1e12) {
      return value.toInt().toString();
    }

    // Use exponential for very large/small numbers
    if (value.abs() >= 1e12 || (value.abs() < 1e-6 && value != 0)) {
      return value.toStringAsExponential(4);
    }

    // Remove trailing zeros
    String str = value.toStringAsFixed(10);
    str = str.replaceAll(RegExp(r'0+$'), '');
    str = str.replaceAll(RegExp(r'\.$'), '');
    return str;
  }

  static bool _canEvaluate(String expr) {
    final trimmed = expr.replaceAll('=', '').trim();
    return RegExp(r'\d+\.?\d*\s*[+\-×÷*/]\s*\d+\.?\d*').hasMatch(trimmed);
  }

  static bool _endsWithOperator(String expr) {
    return RegExp(r'[+\-×÷*/]\s*$').hasMatch(expr.trimRight());
  }

  static String? _lastOperator(String expr) {
    final match = RegExp(r'[+\-×÷*/]').allMatches(expr);
    return match.isEmpty ? null : match.last.group(0);
  }

  /// Replace the last number in the expression string
  static String _replaceLastNumber(String expr, String newNum) {
    if (expr.isEmpty) return newNum;
    // Find last number (including sign if preceded by operator)
    final match = RegExp(r'-?\d*\.?\d*$').firstMatch(expr);
    if (match == null) return '$expr$newNum';
    return expr.substring(0, match.start) + newNum;
  }

  static String _actionToDigit(CalculatorAction action) {
    const map = {
      CalculatorAction.zero: '0',
      CalculatorAction.one: '1',
      CalculatorAction.two: '2',
      CalculatorAction.three: '3',
      CalculatorAction.four: '4',
      CalculatorAction.five: '5',
      CalculatorAction.six: '6',
      CalculatorAction.seven: '7',
      CalculatorAction.eight: '8',
      CalculatorAction.nine: '9',
    };
    return map[action] ?? '';
  }

  static String _actionToOperator(CalculatorAction action) {
    const map = {
      CalculatorAction.add: '+',
      CalculatorAction.subtract: '-',
      CalculatorAction.multiply: '×',
      CalculatorAction.divide: '÷',
    };
    return map[action] ?? '';
  }
}
