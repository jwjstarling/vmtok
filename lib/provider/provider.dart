// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import '../services/content_sync.dart';
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
  ContentfulSync contentfulSync = ContentfulSync(
    spaceId: '5n0lh0o2t6d6',
    accessToken: 'Z9nJXTEddwrQXb6LrCB_NesqS9FPqtRevSgBm6PYRcE',
  );
  await contentfulSync.sync();
  return contentfulSync.getContent();
});
