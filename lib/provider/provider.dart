// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../services/content_sync.dart';
import '../services/content_hive_sync.dart';
import 'package:contentful_sync/contentful_sync.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en-US'); // Default language

  void setLanguage(String languageCode) {
    state = languageCode;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
  (ref) => LanguageNotifier(),
);

final contentProvider = FutureProvider<List<dynamic>>((ref) async {
  final stopwatch = Stopwatch()..start();
  ContentfulHiveSync contentfulSync = ContentfulHiveSync(
    spaceId: '5n0lh0o2t6d6',
    accessToken: 'Z9nJXTEddwrQXb6LrCB_NesqS9FPqtRevSgBm6PYRcE',
  );
  await contentfulSync.sync();

  List allContent = contentfulSync.getContent();
  stopwatch.stop();
  print('Hive processes - elapsed ${stopwatch.elapsedMilliseconds} ms');
  return allContent;
  //return contentfulSync.getContent();
});

final contentProviderSP = FutureProvider<List<dynamic>>((ref) async {
  // uses shared prefs for storage
  final stopwatch = Stopwatch()..start();
  ContentfulSync contentfulSync = ContentfulSync(
    spaceId: '5n0lh0o2t6d6',
    accessToken: 'Z9nJXTEddwrQXb6LrCB_NesqS9FPqtRevSgBm6PYRcE',
  );
  await contentfulSync.sync();

  List allContent = contentfulSync.getContent();
  stopwatch.stop();
  print(
      'Shared Preferences processes - elapsed ${stopwatch.elapsedMilliseconds} ms');
  return allContent;
  //return contentfulSync.getContent();
});
