import 'package:contentful_sync/contentful_sync.dart';

final localStore = LocalStore();

Future<Map<String, dynamic>> fetchPageContent(String pageId) async {
  // Use the queryByField function to fetch the content for the given pageId
  List<Map<String, dynamic>> results = await localStore.queryByField('pageContent', 'pageId', pageId);

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
    itemIds = List<String>.from(pageContent['pageStructuredContentCollection']);
  } else {
    throw Exception('The pageStructuredContentCollection field is missing for page ID: $pageId');
  }

  return itemIds;
}

Future<Map<String, List<String>>> fetchContentTypesAndGroupIds(List<String> itemIds) async {
  // Map to hold the grouped IDs by content type
  Map<String, List<String>> groupedIdsByType = {};

  // Fetch content type for each ID and group them
  for (String itemId in itemIds) {
    List<Map<String, dynamic>> results = await localStore.queryByField('inventory', 'id', itemId);

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

Future<Map<String, List<Map<String, dynamic>>>> fetchContentForGroupedIds(Map<String, List<String>> groupedIdsByType) async {
  // Map to hold the content items grouped by content type
  Map<String, List<Map<String, dynamic>>> contentByType = {};

  // Loop through each content type in the map
  for (String contentType in groupedIdsByType.keys) {
    List<String> idsForType = groupedIdsByType[contentType]!;

    // Use an IN clause to fetch all rows with IDs in the list of idsForType
    String whereClause = 'id IN (${idsForType.map((_) => '?').join(', ')})';

    List<Map<String, dynamic>> results = await localStore.queryWithWhereClause(contentType, whereClause, idsForType);

    if (results.isEmpty) {
      throw Exception('No content found for content type: $contentType');
    }

    // Add the fetched content to the map
    contentByType[contentType] = results;
  }

  return contentByType;
}
