import 'package:flutter/material.dart';

class ThemeProvider extends ValueNotifier<bool>{
  ThemeProvider() : super(true);

  void changeTheme(bool value) => this.value = value;
}