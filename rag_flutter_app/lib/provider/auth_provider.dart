import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rag_flutter_app/provider/knowledge_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_provider.dart';

//认证管理

class AuthProvider with ChangeNotifier {
  int? _userId;
  String? _username;
  bool _initialized = false;

  int? get userId => _userId;

  String? get username => _username;

  bool get isLoggedIn => _userId != null;

  bool get initialized => _initialized;

  // 保存用户信息
  Future<void> saveUserInfo(
    int userId,
    String username,
    BuildContext context,
  ) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _userId = userId;
    _username = username;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('username', username);
    chatProvider.loadChatHistory(userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(content: Text('登录成功'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    notifyListeners();
  }

  // 清除用户信息
  Future<void> logout(BuildContext context) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final knowledgeProvider = Provider.of<KnowledgeProvider>(
      context,
      listen: false,
    );
    _userId = null;
    _username = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    await chatProvider.clear();
    await knowledgeProvider.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(content: Text('已退出登录'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    notifyListeners();
  }

  // 读取存储的用户信息
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');
    _username = prefs.getString('username');
    _initialized = true;
    notifyListeners();
  }
}
