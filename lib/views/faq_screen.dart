import 'package:contentful_sync/utils/logger.dart';
import 'package:flutter/material.dart';

import '../classes/content_classes.dart';
import '../services/content_services.dart';

List faqCollectionsIds = [];

Future<Map<String, dynamic>> fetchFAQCollectionsItem(String id) async {
  List<Map<String, dynamic>> results = await localStore.queryByField('faqCollections', 'id', id);
  if (results.isEmpty) {
    throw Exception('No FAQCollections item found for ID: $id');
  }
  return results.first;
}

Future<List> getFAQCollections(String pageId) async {
  try {
    // Step 1: Fetch the PageContent object using the pageId
    List<String> faqCollectionsId = await getStructuredContent(pageId,'faqCollections');
    Map<String, dynamic> faqCollectionData = await fetchFAQCollectionsItem(faqCollectionsId.first);

    FAQCollections faqCollection = FAQCollections.fromMap(faqCollectionData);
    List faqCollections = faqCollection.faqCollections;

    logger.i(faqCollectionsId.first);
    logger.i(faqCollection.collectionsTitle);
    // Step 9: Return a Structured Data
    return faqCollections;
  } catch (e) {
    print('Error fetching FAQCollections: $e');
    return [];
  }
}

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  Map<String, dynamic>? pageContent;
  Map<String, List<Map<String, dynamic>>>? contentByType;
  Map<String, String>? labels;

  @override
  void initState() {
    super.initState();
    //faqCollectionsIds = getFAQCollections('app.page.faqs');
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: faqCollectionsIds.length,
      itemBuilder: (ctx, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Hi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
          ],
        );
      },
    );
  }
}
