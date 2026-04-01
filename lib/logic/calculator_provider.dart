// lib/logic/calculator_provider.dart
// State management layer — bridges logic and UI

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'calculator_logic.dart';

/// ChangeNotifier that holds calculator state and triggers rebuilds
class CalculatorProvider extends ChangeNotifier {
  CalculatorState _state = const CalculatorState();

  /// Current calculator state (immutable snapshot)
  CalculatorState get state => _state;

  /// Convenience getters for the UI
  String get display => _state.display;
  String get expression => _state.expression;
  bool get hasError => _state.hasError;
  bool get isResult => _state.isResult;

  /// Called by button widgets to dispatch an action
  void dispatch(CalculatorAction action) {
    _triggerHaptic(action);
    _state = CalculatorLogic.process(_state, action);
    notifyListeners();
  }

  /// Haptic feedback — light for digits, medium for operators, heavy for equals
  void _triggerHaptic(CalculatorAction action) {
    try {
      switch (action) {
        case CalculatorAction.equals:
          HapticFeedback.heavyImpact();
          break;
        case CalculatorAction.clear:
        case CalculatorAction.backspace:
          HapticFeedback.mediumImpact();
          break;
        case CalculatorAction.add:
        case CalculatorAction.subtract:
        case CalculatorAction.multiply:
        case CalculatorAction.divide:
          HapticFeedback.selectionClick();
          break;
        default:
          HapticFeedback.lightImpact();
      }
    } catch (_) {
      // Haptic not available on all platforms — silently ignore
    }
  }
}
