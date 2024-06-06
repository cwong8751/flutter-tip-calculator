
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/ThemeProvider.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(onPressed: () => themeProvider.toggleTheme(), icon: themeProvider.isDarkMode ? Icon(Icons.wb_sunny) : Icon(Icons.nightlight_round));
  }
}
