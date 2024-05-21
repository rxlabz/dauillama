import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes.dart';

/*final _darkThemeBase = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.cyan.shade700,
    brightness: Brightness.dark,
    primary: Colors.cyan.shade700,
  ),
);

final darkTheme = _darkThemeBase.copyWith(
  iconButtonTheme: IconButtonThemeData(
    style: _darkThemeBase.iconButtonTheme.style?.copyWith(
      iconColor: const MaterialStatePropertyAll(Colors.teal),
      foregroundColor: const MaterialStatePropertyAll(Colors.teal),
      backgroundColor: const MaterialStatePropertyAll(Colors.teal),
    ),
  ),
);

final lightThemeBase = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
);
*/

extension on Brightness {
  bool get isDark => this == Brightness.dark;
}

class ThemeController extends ValueNotifier<Brightness> {
  ThemeController(super.brightness);

  ThemeData get theme => value.isDark ? darkAppTheme : lightAppTheme;

  void toggle() => value = value.isDark ? Brightness.light : Brightness.dark;
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final icon =
        themeController.value.isDark ? Icons.light_mode : Icons.dark_mode;

    return IconButton(onPressed: themeController.toggle, icon: Icon(icon));
  }
}
