import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../page/chat_page.dart';
import '../page/loading_page.dart';
import '../page/login_page.dart';
import '../page/rag_page.dart';
import '../page/main_page.dart';
import '../provider/auth_provider.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(name: 'login', path: '/', builder: (context, state) => LoginPage()),
    GoRoute(name: 'loading', path: '/loading', builder: (context, state) => LoadingPage()),

    // ✅ `ShellRoute` 确保 `MainPage` 始终在根部
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(name: 'chat', path: '/main/chat', builder: (context, state) => const ChatPage()),
        GoRoute(name: 'rag', path: '/main/rag', builder: (context, state) => const RagPage()),
      ],
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isInitialized = authProvider.initialized;
    final isLoggedIn = authProvider.isLoggedIn;
    final isGoingToLogin = state.matchedLocation == '/';

    if (!isInitialized) {
      return '/loading';
    }

    if (isLoggedIn && (isGoingToLogin || state.matchedLocation == '/loading')) {
      return '/main/chat'; // ✅ 默认进入聊天页面
    }

    if (!isLoggedIn && !isGoingToLogin) {
      return '/';
    }

    return null;
  },
);
