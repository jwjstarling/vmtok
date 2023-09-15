import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contentful_sync/contentful_sync.dart';
import 'classes/content_classes.dart';

final localStore = LocalStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final contentfulClient = ContentfulClient(
      '5n0lh0o2t6d6', 'Z9nJXTEddwrQXb6LrCB_NesqS9FPqtRevSgBm6PYRcE');

  await localStore.open(); // Open the database
  final syncManager = SynchronizationManager(contentfulClient, localStore);

  syncManager.registerContentModel(
      'videoPost', (data) => VideoPost.fromContentful(data));
  syncManager.registerContentModel(
      'videoCollection', (data) => VideoCollection.fromContentful(data));
  syncManager.registerContentModel('Asset', Asset.fromContentful);
  syncManager.registerContentModel(
      'pageContent', (data) => PageContent.fromContentful(data));
  syncManager.registerContentModel(
      'faqCollections', (data) => FAQCollections.fromContentful(data));
  syncManager.registerContentModel(
      'faqCollection', (data) => FAQCollection.fromContentful(data));
  syncManager.registerContentModel(
      'faqItem', (data) => FAQItem.fromContentful(data));
  syncManager.registerContentModel(
      'tileCollection', (data) => TileCollection.fromContentful(data));
  syncManager.registerContentModel('tile', (data) => Tile.fromContentful(data));
  syncManager.registerContentModel(
      'callToAction', (data) => CallToAction.fromContentful(data));
  syncManager.registerContentModel(
      'contentLabel', (data) => ContentLabel.fromContentful(data));

  await syncManager.initialSync();
  await localStore.printAllTables();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
