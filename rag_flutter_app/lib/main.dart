import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rag_flutter_app/provider/auth_provider.dart';
import 'package:rag_flutter_app/provider/chat_provider.dart';
import 'package:rag_flutter_app/provider/global_provider.dart';
import 'package:rag_flutter_app/provider/knowledge_provider.dart';
import 'package:rag_flutter_app/router/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 确保初始化完成
  await Permission.microphone.request(); // ✅ 请求录音权限
  final authProvider = AuthProvider();
  await authProvider.loadUser(); // ✅ 先加载用户数据
  final chatProvider = ChatProvider();
  if (authProvider.userId != null) {
    await chatProvider.loadChatHistory(authProvider.userId!);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        // ✅ 预加载数据
        ChangeNotifierProvider(create: (context) => chatProvider),
        // ✅ 预加载数据
        ChangeNotifierProvider(create: (context) => KnowledgeProvider()),
        // ✅ 预加载数据
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
      ],
      child: const MyApp(), // ✅ 预加载数据)
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'yahei'),
    );
  }
}
