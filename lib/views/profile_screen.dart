import 'package:flutter/material.dart';

import '../services/content_services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? pageContent;
  Map<String, List<Map<String, dynamic>>>? contentByType;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    try {
      // Step 1 & 2: Fetch page content and extract item IDs
      List<String> itemIds =
          await extractItemIdsFromPageContent('app.profile.intro');

      // Step 3: Fetch content types and group IDs by type
      Map<String, List<String>> groupedIdsByType =
          await fetchContentTypesAndGroupIds(itemIds);

      // Step 4: Fetch content for grouped IDs
      contentByType = await fetchContentForGroupedIds(groupedIdsByType);

      // Fetch the page content separately to get the content labels
      pageContent = await fetchPageContent('app.profile.intro');

      setState(() {});
    } catch (e) {
      print('Error fetching content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pageContent == null || contentByType == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Here, you would extract the content labels and other content from pageContent and contentByType
    // and display them using appropriate Flutter widgets.

    return Scaffold(
      body: Center(child: Text('Profile')),
    );
  }
}
