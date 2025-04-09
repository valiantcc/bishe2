import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../api/http.dart';
import '../provider/auth_provider.dart';
import '../provider/knowledge_provider.dart';

// 知识库页面入口
class RagPage extends StatelessWidget {
  const RagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RagScreen();
  }
}

// 知识库主界面
class RagScreen extends StatelessWidget {
  const RagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: _buildKnowledgeBaseList(context)),
          // 左侧知识库列表
          Expanded(flex: 3, child: _buildKnowledgeBaseDetail(context)),
          // 右侧知识库详情
        ],
      ),
    );
  }

  // 构建左侧知识库列表
  Widget _buildKnowledgeBaseList(BuildContext context) {
    final kbProvider = Provider.of<KnowledgeProvider>(context);
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          ListTile(
            title: const Text("新建知识库"),
            leading: const Icon(Icons.add),
            onTap: () => _showCreateDialog(context),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: kbProvider.knowledgeBases.length,
              itemBuilder: (context, index) {
                final base = kbProvider.knowledgeBases[index];
                return ListTile(
                  title: Text(base.name),
                  subtitle: Text(base.description),
                  onTap: () => kbProvider.selectKnowledgeBase(base),
                  selected: kbProvider.selectedBase?.id == base.id,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => kbProvider.removeKnowledgeBase(base.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 构建右侧知识库详情
  Widget _buildKnowledgeBaseDetail(BuildContext context) {
    final kbProvider = Provider.of<KnowledgeProvider>(context);
    final selectedBase = kbProvider.selectedBase;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          color: Colors.blue,
          child: Text(
            selectedBase?.name ?? "请选择知识库",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        Expanded(
          child:
              selectedBase == null
                  ? const Center(child: Text("请选择一个知识库"))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedBase.files.length,
                    itemBuilder: (context, index) {
                      final file = selectedBase.files[index];
                      return ListTile(
                        title: Text(file.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => kbProvider.removeFile(file.id),
                        ),
                      );
                    },
                  ),
        ),
        _buildFileUploadButton(context),
      ],
    );
  }

  // 构建文件上传按钮
  Widget _buildFileUploadButton(BuildContext context) {
    final kbProvider = Provider.of<KnowledgeProvider>(context);
    final bool isDisabled = kbProvider.selectedBase == null; // ✅ 没有选择知识库时禁用
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: isDisabled ? null : () => _pickFile(context), // ✅ 禁用按钮,
        child: const Text("上传文件"),
      ),
    );
  }

  // 选择本地文件并添加到知识库
  Future<void> _pickFile(BuildContext context) async {
    var knowledgeProvider = Provider.of<KnowledgeProvider>(
      context,
      listen: false,
    );
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Http.baseUrl}/file/addRagFile'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // ✅ pipelineId 改用 MultipartFile.fromString 发送
      request.files.add(
        http.MultipartFile.fromString(
          'pipelineId',
          knowledgeProvider.pipelineId!,
        ),
      );
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print("文件上传成功");
          // 解析响应
          var responseBody = await response.stream.bytesToString();
          var parsedResponse = jsonDecode(responseBody);
          if (parsedResponse['code'] == "000000") {
            // 上传成功后，通知 Provider 更新 UI
            knowledgeProvider.addFile(
              parsedResponse['data'], // 服务器返回的文件 ID
              result.files.single.name,
            );
          } else {
            print("文件上传失败: ${parsedResponse['message']}");
          }
        } else {
          print("服务器返回错误: ${response.statusCode}");
        }
      } catch (e) {
        print("上传文件异常: $e");
      }
    }
  }

  // 弹出创建知识库对话框
  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("新建知识库"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "输入知识库名称"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "输入描述"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // 确保 pop 的是 dialog
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  dialogContext.read<KnowledgeProvider>().addKnowledgeBase(
                    nameController.text,
                    descriptionController.text,
                    authProvider.userId!,
                  );
                  Navigator.pop(dialogContext); // 只关闭对话框，不 pop 其它页面
                }
              },
              child: const Text("创建"),
            ),
          ],
        );
      },
    );
  }
}
