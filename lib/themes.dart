import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*import 'appbar_icon_theme_extension.dart';
import 'search_theme_extension.dart';
import 'slide_theme_extension.dart';*/
final editorHighlighterStyle = defaultHighlighterStyle.copyWith(fontSize: 13);

const defaultHighlighterStyle = TextStyle(
  height: 1.2,
  fontSize: 13,
  fontFamily: 'SourceCode',
  fontVariations: <FontVariation>[
    FontVariation('wght', 500.0),
  ],
);

const blueGrey850 = Color(0xFF2A363C);

const blueGrey950 = Color(0xFF222E34);

const blueGrey1000 = Color(0xFF1E2A30);

const blueGrey1100 = Color(0xFF192329);

final defaultDarkGradient = LinearGradient(
  colors: [Colors.blueGrey.shade900, blueGrey1100],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const defaultEditorTextStyle = TextStyle(fontSize: 16, height: 1.6);

const defaultThumbHeight = 110.0;
const defaultThumbMargin = 6;

extension BrightnessHelper on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

final lightTheme = ThemeData.localize(
  ThemeData.light(useMaterial3: true),
  Typography.englishLike2018.copyWith(
    bodyLarge: Typography.englishLike2018.bodyLarge?.copyWith(fontSize: 20),
  ),
);

final darkTheme = ThemeData.localize(
  ThemeData.dark(useMaterial3: true),
  Typography.englishLike2018.copyWith(
    bodyLarge: Typography.englishLike2018.bodyLarge?.copyWith(fontSize: 20),
  ),
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blueGrey,
  surface: Colors.blueGrey.shade100,
  onSurface: Colors.blueGrey.shade800,
  secondary: Colors.deepOrange,
);

final baseLightTheme = ThemeData.from(
  colorScheme: lightColorScheme,
  textTheme: Typography.material2021(
    platform: defaultTargetPlatform,
    colorScheme: lightColorScheme,
  ).black,
  useMaterial3: true,
);

final lightAppTheme = baseLightTheme.copyWith(
  textSelectionTheme:
      TextSelectionThemeData(selectionColor: Colors.cyan.shade50),
  dividerColor: const Color(0xFF90A4AE),
  cardColor: Colors.white,
  dialogBackgroundColor: Colors.grey.shade300,
  canvasColor: Colors.blueGrey.shade200,
  textTheme: baseLightTheme.textTheme,
  appBarTheme: lightTheme.appBarTheme.copyWith(
    backgroundColor: Colors.grey.shade100,
    elevation: 3,
    scrolledUnderElevation: 8,
    shadowColor: Colors.grey,
    surfaceTintColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.grey.shade200,
  /*extensions: <ThemeExtension<dynamic>>[],*/
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blueGrey,
  brightness: Brightness.dark,
  surface: blueGrey950,
  onSurface: Colors.blueGrey.shade200,
  primary: Colors.cyan.shade700,
  secondary: Colors.amber,
);
final baseDarkTheme = ThemeData.from(
  colorScheme: darkColorScheme,
  textTheme: Typography.material2021(
    platform: defaultTargetPlatform,
    colorScheme: darkColorScheme,
  ).white,
  useMaterial3: true,
);

final darkAppTheme = baseDarkTheme.copyWith(
  textSelectionTheme:
      TextSelectionThemeData(selectionColor: Colors.cyan.shade900),
  dividerColor: Colors.blueGrey.shade700,
  cardColor: Colors.grey.shade900,
  dialogBackgroundColor: blueGrey950,
  canvasColor: blueGrey1100,
  appBarTheme: darkTheme.appBarTheme.copyWith(
    backgroundColor: blueGrey950,
    elevation: 4,
    scrolledUnderElevation: 8,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade900),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: blueGrey1100,
    hoverColor: blueGrey850,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: blueGrey950),
  scaffoldBackgroundColor: Colors.blueGrey.shade900 /*Colors.grey.shade800*/,
  switchTheme: baseDarkTheme.switchTheme
      .copyWith(trackColor: WidgetStatePropertyAll(Colors.blueGrey.shade600)),
  /*extensions: <ThemeExtension<dynamic>>[],*/
);
