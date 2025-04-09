import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/chat_provider.dart';
import '../provider/knowledge_provider.dart';

class MainPage extends StatefulWidget {
  final Widget child; // ✅ 添加 child
  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // 0: 聊天, 1: 知识库

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                // ✅ 这里 context 属于 Scaffold
                tooltip: '打开菜单',
              ),
        ),
        title: Text("欢迎, ${authProvider.username ?? '用户'}"),
      ),
      drawer: _buildDrawer(),
      body: widget.child, // ✅ **这里动态显示 ChatPage 或 RagPage**
    );
  }

  Widget _buildDrawer() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "AI 知识库",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text("聊天"),
            leading: const Icon(Icons.chat),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() => _selectedIndex = 0);
              final chatProvider = Provider.of<ChatProvider>(
                context,
                listen: false,
              );
              if (authProvider.userId != null) {
                chatProvider.loadChatHistory(authProvider.userId!);
              }
              GoRouter.of(context).go('/main/chat');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("知识库"),
            leading: const Icon(Icons.book),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() => _selectedIndex = 1);
              final knowledgeProvider = Provider.of<KnowledgeProvider>(
                context,
                listen: false,
              );
              if (authProvider.userId != null) {
                knowledgeProvider.loadKnowledgeBases(authProvider.userId!);
              }
              GoRouter.of(context).go('/main/rag');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("退出登录"),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout(context);
              GoRouter.of(context).go('/'); // ✅ 退出后回到登录页面
            },
          ),
        ],
      ),
    );
  }
}
