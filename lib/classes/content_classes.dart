import 'dart:convert';

import 'package:contentful_sync/classes/content_model.dart';

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
