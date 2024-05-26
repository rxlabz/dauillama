import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final editorHighlighterStyle = defaultHighlighterStyle.copyWith(fontSize: 13);

const defaultHighlighterStyle = TextStyle(
  height: 1.2,
  fontSize: 13,
  fontFamily: 'SourceCode',
  fontVariations: <FontVariation>[
    FontVariation('wght', 500.0),
  ],
);

const blueGrey75 = Color(0xFFDFE8EC);

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
  canvasColor: Colors.blueGrey.shade100,
  textTheme: baseLightTheme.textTheme,
  appBarTheme: lightTheme.appBarTheme.copyWith(
    backgroundColor: Colors.grey.shade100,
    elevation: 3,
    scrolledUnderElevation: 8,
    shadowColor: Colors.grey,
    surfaceTintColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hoverColor: blueGrey75,
    fillColor: Color(0xFFECEFF1),
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(color: Colors.blueGrey),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.blueGrey.shade100),
  listTileTheme: ListTileThemeData(
    selectedColor: Colors.cyan.shade800,
    selectedTileColor: Colors.blueGrey.shade50,
  ),
  scaffoldBackgroundColor: Colors.grey.shade200,
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
  cardColor: Colors.blueGrey.shade800,
  canvasColor: blueGrey1100,
  dialogBackgroundColor: blueGrey950,
  dividerColor: Colors.blueGrey.shade700,
  textSelectionTheme:
      TextSelectionThemeData(selectionColor: Colors.cyan.shade900),
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  appBarTheme: darkTheme.appBarTheme.copyWith(
    backgroundColor: blueGrey950,
    elevation: 4,
    scrolledUnderElevation: 8,
    surfaceTintColor: Colors.transparent,
  ),
  listTileTheme: ListTileThemeData(
    selectedColor: Colors.cyan.shade300,
    selectedTileColor: Colors.blueGrey.shade900,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade900),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: blueGrey1000,
    hoverColor: blueGrey950,
    filled: true,
    labelStyle: TextStyle(color: Colors.blueGrey),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: blueGrey850),
  switchTheme: baseDarkTheme.switchTheme
      .copyWith(trackColor: WidgetStatePropertyAll(Colors.blueGrey.shade600)),
);
