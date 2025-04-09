// 文件模型，包含文件 ID 和文件名
import 'package:flutter/cupertino.dart';
import 'package:rag_flutter_app/data/server_data.dart';

import '../api/http.dart';

class FileItem {
  final String id;
  final String name;

  FileItem({required this.id, required this.name});
}

// 知识库模型，包含唯一 ID、名称、描述和文件列表
class KnowledgeBase {
  final String id;
  final String name;
  final String description;
  final List<FileItem> files;

  KnowledgeBase({
    required this.id,
    required this.name,
    required this.description,
    required this.files,
  });
}

// Provider 管理知识库的状态，支持增删改查操作
class KnowledgeProvider with ChangeNotifier {
  List<KnowledgeBase> knowledgeBases = [];

  // 当前选中的知识库
  KnowledgeBase? selectedBase;
  String? pipelineId;

  Future<void> clear() async {
    knowledgeBases.clear();
    selectedBase = null;
    pipelineId = null;
    notifyListeners();
  }
  Future<void> loadKnowledgeBases(int userId) async {
    // 从服务器获取用户的知识库列表
    await Http().get<List<KnowledgeBaseListDto>>(
      '/rag/list/$userId',
      {},
      {},
      (response) {
        knowledgeBases.clear();
        for (var value in response.data!) {
          knowledgeBases.add(
            KnowledgeBase(
              id: value.id,
              name: value.name,
              description: value.description,
              files: [],
            ),
          );
        }
        notifyListeners();
      },
      (response) {
        print(response.data);
      },
      (json) {
        return Serializable.fromJsonList(json, KnowledgeBaseListDto.fromJson);
      },
    );
  }

  // 选择知识库并通知 UI 更新
  void selectKnowledgeBase(KnowledgeBase base) async {
    selectedBase = base;
    if (pipelineId == base.id) {
      return;
    } else {
      // 重新加载知识库文件列表
      base.files.clear();
    }
    pipelineId = base.id;
    // 加载知识库文件列表
    await loadFiles(base.id);
    notifyListeners();
  }

  Future<void> loadFiles(String baseId) async {
    // 从服务器获取知识库文件列表
    await Http().get<List<FileListItemDto>>(
      '/file/listRagFile/$baseId',
      {},
      {},
      (response) {
        for (var value in response.data!) {
          selectedBase!.files.add(
            FileItem(id: value.fileId, name: value.fileName),
          );
        }
        notifyListeners();
      },
      (response) {
        print(response.data);
      },
      (json) {
        return Serializable.fromJsonList(json, FileListItemDto.fromJson);
      },
    );
  }

  // 添加新知识库，并触发 UI 刷新
  void addKnowledgeBase(String name, String description, int userId) async {
    await Http().post<String>(
      '/rag/save',
      {'ragName': name, 'userId': userId, 'description': description},
      {},
      (response) {
        print(response.data);
        final newBase = KnowledgeBase(
          id: response.data!,
          name: name,
          description: description,
          files: [],
        );
        knowledgeBases.add(newBase);
        notifyListeners();
      },
      (response) {
        print(response.data);
      },
      (json) {
        return json;
      },
    );
  }

  // 根据 ID 删除知识库，并处理当前选中的知识库
  void removeKnowledgeBase(String id) {
    knowledgeBases.removeWhere((base) => base.id == id);
    if (selectedBase?.id == id) {
      selectedBase = null;
    }
    Http().delete(
      '/rag/delete/$id',
      {},
      {},
      (response) {},
      (response) {},
      (json) {},
    );
    notifyListeners();
  }

  // 添加文件到当前选中的知识库
  void addFile(String fileId, String fileName) {
    if (selectedBase == null) return;
    selectedBase!.files.add(FileItem(id: fileId, name: fileName));
    notifyListeners();
  }

  // 从当前选中的知识库删除文件
  void removeFile(String fileId) {
    if (selectedBase == null) return;
    selectedBase!.files.removeWhere((file) => file.id == fileId);
    Http().delete(
      '/file/deleteRagFile/$fileId',
      {},
      {},
      (response) {},
      (response) {},
      (json) {},
    );
    notifyListeners();
  }
}
