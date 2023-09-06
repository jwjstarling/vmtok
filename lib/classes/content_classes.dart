import 'dart:convert';

import 'package:contentful_sync/classes/content_model.dart';

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

class ContentLabel {
  final String labelText;
  final String labelId;

  ContentLabel({
    required this.labelText,
    required this.labelId,
  });

  static ContentLabel fromContentful(Map<String, dynamic> entry) {
    return ContentLabel(
      labelText: entry['fields']['label-text']['en-US'],
      labelId: entry['fields']['label-id']['en-US'],
    );
  }

  static ContentLabel fromMap(Map<String, dynamic> map) {
    return ContentLabel(
      labelText: map['labelText'],
      labelId: map['labelId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'labelText': labelText,
      'labelId': labelId,
    };
  }
}

class PageContent implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> pageContentLabels;
  final List<String> pageStructuredContentCollection; // List of structured content IDs

  PageContent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.pageContentLabels,
    required this.pageStructuredContentCollection,
  });

  static PageContent fromContentful(Map<String, dynamic> entry) {
    return PageContent(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      pageContentLabels:
          (entry['fields']['pageContentLabelCollection']['en-US'] as List)
              .map((e) => e['sys']['id'] as String)
              .toList(),
      pageStructuredContentCollection:
          (entry['fields']['pageStructuredContentCollection']['en-US'] as List)
              .map((e) => e['sys']['id'] as String)
              .toList(),
    );
  }

  static PageContent fromMap(Map<String, dynamic> map) {
    return PageContent(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      pageContentLabels:
          List<String>.from(jsonDecode(map['pageContentLabelCollection'])),
      pageStructuredContentCollection:
          List<String>.from(jsonDecode(map['pageStructuredContentCollection'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pageContentLabelCollection': jsonEncode(pageContentLabels),
      'pageStructuredContentCollection': jsonEncode(pageStructuredContentCollection),
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
  // Add other fields specific to CallToAction

  CallToAction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    // Initialize other fields here
  });

  static CallToAction fromContentful(Map<String, dynamic> entry) {
    return CallToAction(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      // Extract other fields from the entry
    );
  }

  static CallToAction fromMap(Map<String, dynamic> map) {
    return CallToAction(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      // Extract other fields from the map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
      faqCollections:
          (entry['fields']['faqCollections']['en-US'] as List)
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
  final List<FAQItem> faqs;

  FAQCollection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.faqCollectionTitle,
    required this.faqs,
  });

  static FAQCollection fromContentful(Map<String, dynamic> entry) {
    return FAQCollection(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      faqCollectionTitle: entry['fields']['faqCollectionTitle'],
      faqs: (entry['fields']['faqs'] as List)
          .map((faq) => FAQItem.fromContentful(faq))
          .toList(),
    );
  }

  static FAQCollection fromMap(Map<String, dynamic> map) {
    return FAQCollection(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      faqCollectionTitle: map['faqCollectionTitle'],
      faqs: (map['faqs'] as List)
          .map((faq) => FAQItem.fromMap(faq))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'faqCollectionTitle': faqCollectionTitle,
      'faqs': faqs.map((faq) => faq.toMap()).toList(),
    };
  }
}

class FAQItem {
  final String faqTitle;
  final RichText faqBody;

  FAQItem({
    required this.faqTitle,
    required this.faqBody,
  });

  static FAQItem fromContentful(Map<String, dynamic> entry) {
    return FAQItem(
      faqTitle: entry['fields']['faqTitle'],
      faqBody: RichText.fromContentful(entry['fields']['faqBody']),
    );
  }

  static FAQItem fromMap(Map<String, dynamic> map) {
    return FAQItem(
      faqTitle: map['faqTitle'],
      faqBody: RichText.fromMap(map['faqBody']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'faqTitle': faqTitle,
      'faqBody': faqBody.toMap(),
    };
  }
}

abstract class RichTextNode {
  final String nodeType;
  final Map<String, dynamic> data;
  final List<RichTextNode> content;

  RichTextNode(this.nodeType, this.data, this.content);

  factory RichTextNode.fromMap(Map<String, dynamic> map) {
    switch (map['nodeType']) {
      case 'heading-1':
      case 'heading-2':
      case 'heading-3':
      case 'heading-4':
      case 'heading-5':
      case 'heading-6':
      case 'paragraph':
      case 'blockquote':
        return RichTextBlock.fromMap(map);
      case 'unordered-list':
      case 'ordered-list':
        return RichTextList.fromMap(map);
      case 'list-item':
        return RichTextListItem.fromMap(map);
      case 'hyperlink':
        return RichTextHyperlink.fromMap(map);
      case 'hr':
        return RichTextHorizontalRule.fromMap(map);
      case 'text':
        return RichTextLeaf.fromMap(map);
      default:
        throw Exception('Unknown nodeType: ${map['nodeType']}');
    }
  }

  Map<String, dynamic> toMap();
}

class RichTextBlock extends RichTextNode {
  RichTextBlock(String nodeType, Map<String, dynamic> data, List<RichTextNode> content)
      : super(nodeType, data, content);

  static RichTextBlock fromMap(Map<String, dynamic> map) {
    return RichTextBlock(
      map['nodeType'],
      map['data'],
      (map['content'] as List).map((e) => RichTextNode.fromMap(e)).toList(),
    );
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content.map((e) => e.toMap()).toList(),
    };
  }
}

class RichTextList extends RichTextNode {
  RichTextList(String nodeType, Map<String, dynamic> data, List<RichTextNode> content)
      : super(nodeType, data, content);

  static RichTextList fromMap(Map<String, dynamic> map) {
    return RichTextList(
      map['nodeType'],
      map['data'],
      (map['content'] as List).map((e) => RichTextNode.fromMap(e)).toList(),
    );
  }

    @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content.map((e) => e.toMap()).toList(),
    };
  }
}

class RichTextListItem extends RichTextNode {
  RichTextListItem(String nodeType, Map<String, dynamic> data, List<RichTextNode> content)
      : super(nodeType, data, content);

  static RichTextListItem fromMap(Map<String, dynamic> map) {
    return RichTextListItem(
      map['nodeType'],
      map['data'],
      (map['content'] as List).map((e) => RichTextNode.fromMap(e)).toList(),
    );
  }

    @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content.map((e) => e.toMap()).toList(),
    };
  }
}

class RichTextHyperlink extends RichTextNode {
  RichTextHyperlink(String nodeType, Map<String, dynamic> data, List<RichTextNode> content)
      : super(nodeType, data, content);

  static RichTextHyperlink fromMap(Map<String, dynamic> map) {
    return RichTextHyperlink(
      map['nodeType'],
      map['data'],
      (map['content'] as List).map((e) => RichTextNode.fromMap(e)).toList(),
    );
  }

    @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content.map((e) => e.toMap()).toList(),
    };
  }
}

class RichTextHorizontalRule extends RichTextNode {
  RichTextHorizontalRule(String nodeType, Map<String, dynamic> data, List<RichTextNode> content)
      : super(nodeType, data, content);

  static RichTextHorizontalRule fromMap(Map<String, dynamic> map) {
    return RichTextHorizontalRule(
      map['nodeType'],
      map['data'],
      (map['content'] as List).map((e) => RichTextNode.fromMap(e)).toList(),
    );
  }

    @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content.map((e) => e.toMap()).toList(),
    };
  }
}

class RichTextLeaf extends RichTextNode {
  final String value;
  final List<Map<String, dynamic>> marks;

  RichTextLeaf(String nodeType, Map<String, dynamic> data, List<RichTextNode> content, this.value, this.marks)
      : super(nodeType, data, content);

  static RichTextLeaf fromMap(Map<String, dynamic> map) {
    return RichTextLeaf(
      map['nodeType'],
      map['data'],
      [],
      map['value'],
      (map['marks'] as List).cast<Map<String, dynamic>>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'value': value,
      'marks': marks,
    };
  }
}

class RichText {
  final RichTextNode document;

  RichText(this.document);

  static RichText fromContentful(Map<String, dynamic> entry) {
    return RichText(
      RichTextNode.fromMap(entry['fields']['richTextField']['en-US']),
    );
  }

     static RichText fromMap(Map<String, dynamic> map) {
    return RichText(
      RichTextBlock.fromMap(map['fields']['richTextField']['en-US']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fields': {
        'richTextField': {
          'en-US': document.toMap(),
        },
      },
    };
  }
}


// You'll also need to define the RichText class and its methods if you haven't already.
