import 'dart:convert';

import 'package:contentful_sync/contentful_sync.dart';
import 'package:contentful_sync/utils/logger.dart';
import '../classes/content_classes.dart';

final localStore = LocalStore();

Future<Map<String, dynamic>> fetchPageData(String pageId) async {
  // 1. Fetch the page content using the page ID.
  Map<String, dynamic> pageContent = await fetchPageContent(pageId);

  // 2. Extract the list of item IDs.
  List<String> itemIds = await extractItemIdsFromPageContent(pageId);

  // 3. Fetch content types for these item IDs and group them by content type.
  Map<String, List<String>> groupedIdsByType =
      await fetchContentTypesAndGroupIds(itemIds);

  // 4. Query the appropriate tables for each content type and fetch the content items.
  Map<String, List<Map<String, dynamic>>> contentData =
      await fetchContentForGroupedIds(groupedIdsByType);

  // Combine the page content and the fetched content items into a single map and return.
  pageContent['contentItems'] = contentData;
  return pageContent;
}

Future<List<String>> getStructuredContent(String pageId, String contentType) async {
  try {
    List<String> itemIds = await extractItemIdsFromPageContent(pageId);
    List<String> filteredItemIds = await fetchContentIdsByType(itemIds,contentType);
    logger.i("Returning IDs: $filteredItemIds");
    return filteredItemIds;
  } catch (e) {
    print('Error fetching structured content: $e');
    return [];
  }
}

Future<Map<String, dynamic>> fetchPageContent(String pageId) async {
  await localStore.open();
  localStore.printTableContents('inventory');
  // Use the queryByField function to fetch the content for the given pageId
  logger.i("+++ Querying content of page ID $pageId +++");
  List<Map<String, dynamic>> results =
      await localStore.queryByField('pageContent', 'pageId', pageId);

  // Check if any results were returned
  if (results.isEmpty) {
    throw Exception('Page not found for ID: $pageId');
  }
  // Since IDs are unique, we expect only one result for the given pageId
  Map<String, dynamic> pageContent = results.first;

  return pageContent;
}

Future<List<String>> extractItemIdsFromPageContent(String pageId) async {
  // First, fetch the content for the given pageId
  Map<String, dynamic> pageContent = await fetchPageContent(pageId);

  // Extract the list of item IDs from the 'pageStructuredContentCollection' field
  List<String> itemIds;
  if (pageContent.containsKey('pageStructuredContentCollection')) {

    itemIds = List<String>.from(jsonDecode(pageContent['pageStructuredContentCollection']));
 
  } else {
    throw Exception(
        'The pageStructuredContentCollection field is missing for page ID: $pageId');
  }
  return itemIds;
}

Future<List<String>> fetchContentIdsByType(
    List<String> itemIds, String contentType) async {
  // List to hold the filtered IDs that match the specified content type
  List<String> filteredIds = [];

  // Fetch content type for each ID and add to the list if it matches the specified content type
  for (String itemId in itemIds) {
    List<Map<String, dynamic>> results =
        await localStore.queryByField('inventory', 'id', itemId);

    if (results.isEmpty) {
      throw Exception('Content type not found for ID: $itemId');
    }

    String currentContentType = results.first['contentType'];

    // If the content type matches the specified content type, add the ID to the list
    if (currentContentType == contentType) {
      filteredIds.add(itemId);
    }
  }

  return filteredIds;
}

Future<Map<String, List<String>>> fetchContentTypesAndGroupIds(
    List<String> itemIds) async {
  // Map to hold the grouped IDs by content type
  Map<String, List<String>> groupedIdsByType = {};

  // Fetch content type for each ID and group them
  for (String itemId in itemIds) {
    List<Map<String, dynamic>> results =
        await localStore.queryByField('inventory', 'id', itemId);

    if (results.isEmpty) {
      throw Exception('Content type not found for ID: $itemId');
    }

    String contentType = results.first['contentType'];

    // If the content type is not in the map, add it with an empty list
    if (!groupedIdsByType.containsKey(contentType)) {
      groupedIdsByType[contentType] = [];
    }

    // Add the ID to the list of IDs for its content type
    groupedIdsByType[contentType]?.add(itemId);
  }

  return groupedIdsByType;
}

Future<Map<String, List<Map<String, dynamic>>>> fetchContentForGroupedIds(
    Map<String, List<String>> groupedIdsByType) async {
  // Map to hold the content items grouped by content type
  Map<String, List<Map<String, dynamic>>> contentByType = {};

  // Loop through each content type in the map
  for (String contentType in groupedIdsByType.keys) {

    logger.i("+++ Grouped Content Type: $contentType");

    List<String> idsForType = groupedIdsByType[contentType]!;

    // Use an IN clause to fetch all rows with IDs in the list of idsForType
    String whereClause = 'id IN (${idsForType.map((_) => '?').join(', ')})';

    List<Map<String, dynamic>> results = await localStore.queryWithWhereClause(
        contentType, whereClause, idsForType);

    if (results.isEmpty) {
      throw Exception('No content found for content type: $contentType');
    }

    // Add the fetched content to the map
    contentByType[contentType] = results;
  }
 logger.i("+++ Content By Type: $contentByType");
  return contentByType;
}

Future<Map<String, String>> getContentLabels(String pageId) async {
  try {
    
    // Step 1: Fetch the PageContent object using the pageId
    Map<String, dynamic> pageContentMap = await fetchPageContent(pageId);
    PageContent pageContent = PageContent.fromMap(pageContentMap);

    // Step 2: Retrieve the list of content label IDs
    List<String> contentLabelIds = pageContent.pageContentLabels;

    // Step 3: Create a where clause to match any ID in the list of contentLabelIds
    String whereClause = 'id IN (${contentLabelIds.map((_) => '?').join(', ')})';

    // Step 4: Query the database to get all content labels with IDs in contentLabelIds
    LocalStore localStore = LocalStore();
    await localStore.open();
    List<Map<String, dynamic>> maps = await localStore.queryWithWhereClause('contentLabel', whereClause, contentLabelIds);

    // Step 5: Create a map with labelId as key and labelText as value
    Map<String, String> labels = {};
    for (var map in maps) {
      ContentLabel contentLabel = ContentLabel.fromMap(map);
      labels[contentLabel.labelId] = contentLabel.labelText;
    }

    // Step 6: Return the map of labels
    return labels;
  } catch (e) {
    print('Error fetching content labels: $e');
    return {};
  }
}

Future<VideoCollection?> fetchVideoCollectionByTitle(String title) async {
  print("fetch Videos");
  final results = await localStore.queryByField(
      'videoCollection', 'videoCollectionTitle', title);
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

