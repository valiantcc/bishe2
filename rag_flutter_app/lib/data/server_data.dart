// 定义序列化接口

import 'dart:ffi';

abstract class Serializable {
  dynamic toJson();

  factory Serializable.fromJson(dynamic json) => throw UnimplementedError();

  // 新增静态方法，用于支持 List 的反序列化
  static List<T> fromJsonList<T extends Serializable>(
    dynamic jsonList,
    T Function(dynamic)? fromJson,
  ) {
    if (jsonList is List) {
      return jsonList.map((json) => fromJson!(json)).toList();
    }
    return [];
  }
}

class UserData implements Serializable {
  final int id;
  final String username;

  UserData.fromJson(dynamic json)
    : id = json['id'],
      username = json['username'];

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username};
  }
}

// ChatContentDto 类
class ChatContentDto implements Serializable {
  final String content;
  final bool isUser;

  ChatContentDto({required this.content, required this.isUser});

  @override
  Map<String, dynamic> toJson() {
    return {'content': content, 'isUser': isUser};
  }

  factory ChatContentDto.fromJson(dynamic json) {
    return ChatContentDto(content: json['content'], isUser: json['isUser']);
  }
}

// ChatContentAddDto 类
class ChatContentAddDto implements Serializable {
  final String content;
  final bool isUser;
  final String sessionId;

  ChatContentAddDto({
    required this.content,
    required this.isUser,
    required this.sessionId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'content': content, 'isUser': isUser, 'sessionId': sessionId};
  }

  factory ChatContentAddDto.fromJson(dynamic json) {
    return ChatContentAddDto(
      content: json['content'],
      isUser: json['isUser'],
      sessionId: json['sessionId'],
    );
  }
}

// ChatSessionSaveDto 类
class ChatSessionSaveDto implements Serializable {
  final int userId;
  final String name;
  final String sessionId;
  final List<ChatContentDto> chatContents;

  ChatSessionSaveDto({
    required this.userId,
    required this.name,
    required this.sessionId,
    required this.chatContents,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'sessionId': sessionId,
      'chatContents': chatContents.map((content) => content.toJson()).toList(),
    };
  }

  factory ChatSessionSaveDto.fromJson(dynamic json) {
    return ChatSessionSaveDto(
      userId: json['userId'],
      name: json['name'],
      sessionId: json['sessionId'],
      chatContents:
          (json['chatContents'] as List)
              .map((content) => ChatContentDto.fromJson(content))
              .toList(),
    );
  }
}

// ChatSessionDto 类
class ChatSessionDto implements Serializable {
  final String name;
  final String sessionId;

  ChatSessionDto({required this.name, required this.sessionId});

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'sessionId': sessionId};
  }

  factory ChatSessionDto.fromJson(dynamic json) {
    return ChatSessionDto(name: json['name'], sessionId: json['sessionId']);
  }
}

class KnowledgeBaseListDto implements Serializable {
  final String id;
  final String name;
  final String description;

  KnowledgeBaseListDto({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory KnowledgeBaseListDto.fromJson(dynamic json) {
    return KnowledgeBaseListDto(
      id: json['pipelineId'],
      name: json['ragName'],
      description: json['description'],
    );
  }
}
class FileListItemDto implements Serializable {
  final String fileId;
  final String fileName;

  FileListItemDto({required this.fileId, required this.fileName});

  @override
  toJson() {
    return {'fileId': fileId, 'fileName': fileName};
  }
  factory FileListItemDto.fromJson(dynamic json) {
    return FileListItemDto(
      fileId: json['fileId'],
      fileName: json['fileName'],
    );
  }
}
class KnowledgeBaseAddDto implements Serializable {
  final Long userId;
  final String ragName;
  final String description;

  KnowledgeBaseAddDto({
    required this.userId,
    required this.ragName,
    required this.description,
  });

  @override
  toJson() {
   return {'userId': userId, 'ragName': ragName, 'description': description};
  }

 factory KnowledgeBaseAddDto.fromJson(dynamic json) {
    return KnowledgeBaseAddDto(
      userId: json['userId'],
      ragName: json['ragName'],
      description: json['description'],
    );
 }
}