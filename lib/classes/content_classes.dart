import 'dart:convert';

import 'package:contentful_sync/classes/content_model.dart';
import 'package:contentful_sync/utils/logger.dart';
import 'rich_content_classes.dart';

class PageContentLabelCollection implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<ContentLabel> contentLabels; // List of ContentLabel objects

  PageContentLabelCollection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.contentLabels,
  });

  static PageContentLabelCollection fromContentful(Map<String, dynamic> entry) {
    return PageContentLabelCollection(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      contentLabels: (entry['fields']['contentLabels']['en-US'] as List)
          .map((e) => ContentLabel.fromContentful(e))
          .toList(),
    );
  }

  static PageContentLabelCollection fromMap(Map<String, dynamic> map) {
    return PageContentLabelCollection(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      contentLabels: (jsonDecode(map['contentLabels']) as List)
          .map((e) => ContentLabel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'contentLabels': jsonEncode(contentLabels.map((e) => e.toMap()).toList()),
    };
  }
}

class ContentLabel implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String labelText;
  final String labelId;

  ContentLabel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.labelText,
    required this.labelId,
  });

  static ContentLabel fromContentful(Map<String, dynamic> entry) {
    return ContentLabel(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      labelText: entry['fields']['labelText']['en-US'],
      labelId: entry['fields']['labelId']['en-US'],
    );
  }

  static ContentLabel fromMap(Map<String, dynamic> map) {
    return ContentLabel(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      labelText: map['labelText'],
      labelId: map['labelId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'labelText': labelText,
      'labelId': labelId,
    };
  }
}

class PageContent implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String pageId;
  final List<String> pageContentLabels;
  final List<String>
      pageStructuredContentCollection; // List of structured content IDs

  PageContent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.pageId,
    required this.pageContentLabels,
    required this.pageStructuredContentCollection,
  });

  static PageContent fromContentful(Map<String, dynamic> entry) {
    return PageContent(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      pageId: entry['fields']['pageId']['en-US'],
      pageContentLabels: 
        (entry['fields']['pageContentLabelCollection']?['en-US'] as List?)
            ?.map((e) => e['sys']['id'] as String)
            .toList() ?? 
        [], // Provide a default empty list if the field is null
      pageStructuredContentCollection: 
        (entry['fields']['pageStructuredContentCollection']?['en-US'] as List?)
            ?.map((e) => e['sys']['id'] as String)
            .toList() ?? 
        [], // Provide a default empty list if the field is null
    );
  }

  static PageContent fromMap(Map<String, dynamic> map) {

    logger.i('pageContentLabelCollection: ${map['pageContentLabelCollection']}');
    logger.i('pageStructuredContentCollection: ${map['pageStructuredContentCollection']}');

    return PageContent(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      pageId: map['pageId'],
      pageContentLabels: 
        (jsonDecode(map['pageContentLabelCollection'] ?? '[]') as List)
            .map((e) => e as String)
            .toList(), // Provide a default empty JSON array string if the field is null
    pageStructuredContentCollection: 
        (jsonDecode(map['pageStructuredContentCollection'] ?? '[]') as List)
            .map((e) => e as String)
            .toList(), // Provide a default empty JSON array string if the field is null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pageId': pageId,
      'pageContentLabelCollection': jsonEncode(pageContentLabels),
      'pageStructuredContentCollection':
          jsonEncode(pageStructuredContentCollection),
    };
  }
}

class VideoCollection implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String videoCollectionTitle;
  final List<String> videoCollectionList; // List of VideoPost IDs

  VideoCollection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.videoCollectionTitle,
    required this.videoCollectionList,
  });

  static VideoCollection fromContentful(Map<String, dynamic> entry) {
    return VideoCollection(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      videoCollectionTitle: entry['fields']['videoCollectionTitle']['en-US'],
      videoCollectionList:
          (entry['fields']['videoCollectionList']['en-US'] as List)
              .map((e) => e['sys']['id'] as String)
              .toList(),
    );
  }

  static VideoCollection fromMap(Map<String, dynamic> map) {
    return VideoCollection(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      videoCollectionTitle: map['videoCollectionTitle'],
      videoCollectionList:
          List<String>.from(jsonDecode(map['videoCollectionList'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'videoCollectionTitle': videoCollectionTitle,
      'videoCollectionList': jsonEncode(videoCollectionList),
    };
  }
}

class CallToAction implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String callToActionText;
  final String callToActionId;
  final List<String> callToActionStyle;

  CallToAction(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.callToActionText,
      required this.callToActionId,
      required this.callToActionStyle});

  static CallToAction fromContentful(Map<String, dynamic> entry) {
    return CallToAction(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      callToActionText: entry['fields']['callToActionText']['en-US'],
      callToActionId: entry['fields']['callToActionId']['en-US'],
      callToActionStyle: List<String>.from(entry['fields']['callToActionStyle']
          ['en-US']), // Assuming there's a link field

      // Extract other fields from the entry
    );
  }

  static CallToAction fromMap(Map<String, dynamic> map) {
    return CallToAction(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      callToActionText: map['callToActionText'],
      callToActionId: map['callToActionId'],
      callToActionStyle:
          List<String>.from(jsonDecode(map['callToActionStyle'])),
      // Extract other fields from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'callToActionText': callToActionText,
      'callToActionId': callToActionId,
      'callToActionStyle': jsonEncode(callToActionStyle),
      // Add other fields to the map
    };
  }
}

class VideoPost implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String videoTitle;
  final String videoFileId; // ID of the linked Asset
  final String videoDescription;

  VideoPost({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.videoTitle,
    required this.videoFileId,
    required this.videoDescription,
  });

  static VideoPost fromContentful(Map<String, dynamic> entry) {
    return VideoPost(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      videoTitle: entry['fields']['videoTitle']['en-US'],
      videoFileId: entry['fields']['videoFile']['en-US']['sys']['id'],
      videoDescription: entry['fields']['videoDescription']['en-US'],
    );
  }

  static VideoPost fromMap(Map<String, dynamic> map) {
    return VideoPost(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      videoTitle: map['videoTitle'],
      videoFileId: map['videoFileId'],
      videoDescription: map['videoDescription'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'videoTitle': videoTitle,
      'videoFileId': videoFileId,
      'videoDescription': videoDescription,
    };
  }
}

class Asset implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String url;

  Asset({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.url,
  });

  static Asset fromContentful(Map<String, dynamic> entry) {
    return Asset(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      title: entry['fields']['title']['en-US'],
      url: 'https:${entry['fields']['file']['en-US']['url']}',
    );
  }

  static Asset fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      title: map['title'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'url': url,
    };
  }
}

class FAQCollections implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String collectionsTitle;
  final String collectionsId;
  final List<String> faqCollections; // List of FAQCollection IDs

  FAQCollections({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.collectionsTitle,
    required this.collectionsId,
    required this.faqCollections,
  });

  static FAQCollections fromContentful(Map<String, dynamic> entry) {
    return FAQCollections(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      collectionsTitle: entry['fields']['collectionsTitle']['en-US'],
      collectionsId: entry['fields']['collectionsId']['en-US'],
      faqCollections: (entry['fields']['faqCollections']['en-US'] as List)
          .map((e) => e['sys']['id'] as String)
          .toList(),
    );
  }

  static FAQCollections fromMap(Map<String, dynamic> map) {
    return FAQCollections(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      collectionsTitle: map['collectionsTitle'],
      collectionsId: map['collectionsId'],
      faqCollections: List<String>.from(jsonDecode(map['faqCollections'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'collectionsTitle': collectionsTitle,
      'collectionsId': collectionsId,
      'faqCollections': jsonEncode(faqCollections),
    };
  }
}

class FAQCollection implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String faqCollectionTitle;
  final List<String> faqIds; // List of FAQItem IDs

  FAQCollection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.faqCollectionTitle,
    required this.faqIds,
  });

  static FAQCollection fromContentful(Map<String, dynamic> entry) {
    return FAQCollection(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      faqCollectionTitle: entry['fields']['faqCollectionTitle']['en-US'],
      faqIds: (entry['fields']['faqs']['en-US'] as List)
          .map((e) => e['sys']['id'] as String)
          .toList(),
    );
  }

  static FAQCollection fromMap(Map<String, dynamic> map) {
    return FAQCollection(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      faqCollectionTitle: map['faqCollectionTitle'],
      faqIds: List<String>.from(jsonDecode(map['faqIds'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'faqCollectionTitle': faqCollectionTitle,
      'faqIds': jsonEncode(faqIds),
    };
  }
}

class FAQItem implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String faqTitle;
  final RichText faqBody;

  FAQItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.faqTitle,
    required this.faqBody,
  });

  static FAQItem fromContentful(Map<String, dynamic> entry) {
    return FAQItem(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      faqTitle: entry['fields']['faqTitle']['en-US'],
      faqBody: RichText.fromContentful(entry['fields']['faqBody']['en-US']),
    );
  }

  static FAQItem fromMap(Map<String, dynamic> map) {
    return FAQItem(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      faqTitle: map['faqTitle'],
      faqBody: RichText.fromMap(jsonDecode(map['faqBody'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'faqTitle': faqTitle,
      'faqBody': jsonEncode(faqBody.toMap()),
    };
  }
}

class TileCollection implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String collectionTitle;
  final List<String> collectionContent; // List of Tile IDs

  TileCollection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.collectionTitle,
    required this.collectionContent,
  });

  static TileCollection fromContentful(Map<String, dynamic> entry) {
    return TileCollection(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      collectionTitle: entry['fields']['collectionTitle']['en-US'],
      collectionContent: (entry['fields']['collectionContent']['en-US'] as List)
          .map((e) => e['sys']['id'] as String)
          .toList(),
    );
  }

  static TileCollection fromMap(Map<String, dynamic> map) {
    return TileCollection(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      collectionTitle: map['collectionTitle'],
      collectionContent:
          List<String>.from(jsonDecode(map['collectionContent'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'collectionTitle': collectionTitle,
      'collectionContent': jsonEncode(collectionContent),
    };
  }
}

class Tile implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String tileHeadline;
  final String tileSubBody;

  Tile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.tileHeadline,
    required this.tileSubBody,
  });

  static Tile fromContentful(Map<String, dynamic> entry) {
    return Tile(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      tileHeadline: entry['fields']['tileHeadline']['en-US'],
      tileSubBody: entry['fields']['tileSubBody']['en-US'],
    );
  }

  static Tile fromMap(Map<String, dynamic> map) {
    return Tile(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      tileHeadline: map['tileHeadline'],
      tileSubBody: map['tileSubBody'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tileHeadline': tileHeadline,
      'tileSubBody': tileSubBody,
    };
  }
}
