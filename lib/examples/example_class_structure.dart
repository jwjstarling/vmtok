class ContentTypeName implements ContentModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Add other fields specific to CallToAction

  ContentTypeName({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    // Initialize other fields here
  });

  static ContentTypeName fromContentful(Map<String, dynamic> entry) {
    return ContentTypeName(
      id: entry['sys']['id'],
      createdAt: DateTime.parse(entry['sys']['createdAt']),
      updatedAt: DateTime.parse(entry['sys']['updatedAt']),
      // Extract other fields from the entry
    );
  }

  static ContentTypeName fromMap(Map<String, dynamic> map) {
    return ContentTypeName(
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