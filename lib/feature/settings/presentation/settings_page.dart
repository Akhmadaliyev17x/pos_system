import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milliyway_pos/feature/settings/providers/settings_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            DesktopLanguagePicker(
              languages: const ['English', 'Русский', 'O‘zbekcha', 'Türkçe'],
              selectedLanguage: 'English',
              onLanguageSelected: (lang) {
                print('Selected Language: $lang');
              },
            ),


            Consumer<ThemeProvider>(
              builder: (_, controller, _) {
                return CupertinoSwitch(
                  value: controller.value,
                  onChanged: controller.changeTheme,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class DesktopLanguagePicker extends StatefulWidget {
  final List<String> languages;
  final String selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const DesktopLanguagePicker({
    super.key,
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<DesktopLanguagePicker> createState() => _DesktopLanguagePickerState();
}

class _DesktopLanguagePickerState extends State<DesktopLanguagePicker> {
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 20),
          const SizedBox(width: 8),
          Text(_currentLanguage),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down),
            onSelected: (lang) {
              setState(() {
                _currentLanguage = lang;
              });
              widget.onLanguageSelected(lang);
            },
            itemBuilder: (context) {
              return widget.languages
                  .map(
                    (lang) => PopupMenuItem<String>(
                  value: lang,
                  child: Text(lang),
                ),
              )
                  .toList();
            },
          ),
        ],
      ),
    );
  }
}
