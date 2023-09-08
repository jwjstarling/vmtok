class RichText {
  final List<RichTextNode> content;

  RichText({required this.content});

  static RichText fromContentful(Map<String, dynamic> entry) {
    List content = entry['content'];
    return RichText(
      content: content
          .map<RichTextNode>((node) => RichTextNode.fromMap(node))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content.map((node) => node.toMap()).toList(),
    };
  }

  static RichText fromMap(Map<String, dynamic> map) {
    List content = map['content'];
    return RichText(
      content: content
          .map<RichTextNode>((node) => RichTextNode.fromMap(node))
          .toList(),
    );
  }
}

class RichTextNode {
  final String nodeType;
  final Map<String, dynamic> data;
  final List<RichTextNode>? content;
  final String? value;
  final List<RichTextMark>? marks;

  RichTextNode({
    required this.nodeType,
    required this.data,
    this.content,
    this.value,
    this.marks,
  });

  static RichTextNode fromMap(Map<String, dynamic> map) {
    return RichTextNode(
      nodeType: map['nodeType'],
      data: map['data'],
      content: map['content'] != null
          ? (map['content'] as List)
              .map((e) => RichTextNode.fromMap(e))
              .toList()
          : null,
      value: map['value'],
      marks: map['marks'] != null
          ? (map['marks'] as List).map((e) => RichTextMark.fromMap(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'data': data,
      'content': content?.map((node) => node.toMap()).toList(),
      'value': value,
      'marks': marks?.map((mark) => mark.toMap()).toList(),
    };
  }
}

class RichTextMark {
  final String type;

  RichTextMark({required this.type});

  static RichTextMark fromMap(Map<String, dynamic> map) {
    return RichTextMark(
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
    };
  }
}
