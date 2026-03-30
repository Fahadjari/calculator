// lib/main.dart
// App entry point — wires up Provider and theming

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'logic/calculator_provider.dart';
import 'screens/calculator_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait — calculators don't need landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent so our background shows through
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const CalcApp());
}

/// Root widget — sets up providers
class CalcApp extends StatefulWidget {
  const CalcApp({super.key});

  @override
  State<CalcApp> createState() => _CalcAppState();
}

class _CalcAppState extends State<CalcApp> {
  /// Start in dark mode — premium default
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculatorProvider>(
      create: (_) => CalculatorProvider(),
      child: MaterialApp(
        title: 'Calculator',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: _ThemeWrapper(
          themeMode: _themeMode,
          onToggle: _toggleTheme,
        ),
      ),
    );
  }
}

/// Wraps the screen and injects a theme-toggle FAB
class _ThemeWrapper extends StatelessWidget {
  const _ThemeWrapper({
    required this.themeMode,
    required this.onToggle,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CalculatorScreen(),

        // Floating theme toggle (top-right corner)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 16,
          child: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
              ),
              child: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black45,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
