import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/rescue_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ResQCoreApp());
}

/// Custom scroll behavior that removes all scrollbars and overscroll glows
class NoScrollbarBehavior extends MaterialScrollBehavior {
  const NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class ResQCoreApp extends StatelessWidget {
  const ResQCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RescueProvider(),
      child: Consumer<RescueProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'ResQCore | Citizen Emergency App',
            debugShowCheckedModeBanner: false,
            scrollBehavior: const NoScrollbarBehavior(),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            builder: (context, child) {
              return ResponsiveMobileFrame(
                isDark: provider.isDarkMode,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}

/// Provides a centered tactical mobile viewport on desktop/web viewports,
/// and full-screen layout on native mobile screens.
class ResponsiveMobileFrame extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const ResponsiveMobileFrame({
    super.key,
    required this.child,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 520) {
          // Centered phone container on desktop/tablet
          return Scaffold(
            backgroundColor: const Color(0xFF070B12),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 412,
                  maxHeight: 880,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.strokeBorder,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 36,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: child,
                ),
              ),
            ),
          );
        }

        // Native mobile phone screen
        return child;
      },
    );
  }
}
