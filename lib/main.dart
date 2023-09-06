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
  syncManager.registerContentModel('pageContent', (data) => PageContent.fromContentful(data));

  await syncManager.initialSync();
  await localStore.printAllTables();
  //await displayVideoDetails("Collection of Vids for VM Tok App");

  runApp(ProviderScope(child: MyApp()));
}

Future<VideoCollection?> fetchVideoCollectionByTitle(String title) async {
  final results = await localStore.queryByField(
      'VideoCollection', 'videoCollectionTitle', title);
  if (results.isNotEmpty) {
    print('Results from fetchVideoCollectionByTitle: $results');
    return VideoCollection.fromMap(results.first);
  }
  return null;
}

Future<void> displayVideoDetails(String collectionTitle) async {
  final collection = await fetchVideoCollectionByTitle(collectionTitle);
  if (collection != null) {
    final videoPosts = await fetchVideoPostsForCollection(collection);
    for (var post in videoPosts) {
      // Fetch the Asset for the VideoPost
      Asset? videoAsset = await fetchAssetById(post.videoFileId);

      print('Video Description: ${post.videoDescription}');
      print('Video URL: ${videoAsset?.url}');
    }
  }
}

Future<List<VideoPost>> fetchVideoPostsForCollection(
    VideoCollection collection) async {
  final List<VideoPost> videoPosts = [];
  for (var postId in collection.videoCollectionList) {
    final results = await localStore.fetch('VideoPost');
    results.forEach((map) {
      if (map['id'] == postId) {
        videoPosts.add(VideoPost.fromMap(map));
      }
    });
  }
  print('Results from fetchVideoPostsForCollection: $videoPosts');
  return videoPosts;
}

Future<Asset?> fetchAssetById(String assetId) async {
  final results = await localStore.queryByField('Asset', 'id', assetId);
  if (results.isNotEmpty) {
    print('Results from fetchAssetById: $results');
    return Asset.fromMap(results.first);
  }
  return null;
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
