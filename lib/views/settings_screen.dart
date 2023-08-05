import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/provider.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: languageState,
              onChanged: (value) =>
                  ref.read(languageProvider.notifier).setLanguage(value!),
              items: [
                DropdownMenuItem(value: 'en-US', child: Text('English')),
                DropdownMenuItem(value: 'es-ES', child: Text('Spanish')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
