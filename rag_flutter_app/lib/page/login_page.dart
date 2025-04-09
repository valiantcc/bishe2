import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rag_flutter_app/api/http.dart';
import 'package:rag_flutter_app/constants/application_constant.dart';
import 'package:rag_flutter_app/data/server_data.dart';
import 'package:rag_flutter_app/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();//用户名输入控制器
  final TextEditingController _passwordController = TextEditingController();//密码输入控制器
  bool _isRegisterMode = false; // 是否是注册模式
  String _errorMessage = '';
  String _successMessage = '';

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _errorMessage = '';
      _successMessage = '';
    });
  }

  void _handleAuth() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    setState(() => _errorMessage = '');
    setState(() => _successMessage = '');
    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = '用户名和密码不能为空');
      return;
    }

    if (_isRegisterMode) {
      Http().post(
        '/user/register',
        {'username': username, 'password': password},
        {},
        (response) => {setState(() => _successMessage = response.message)},
        (response) => {setState(() => _errorMessage = response.message)},
        Serializable.fromJson,
      );
    } else {
      Http().post<UserData>(
        '/user/login',
        {'username': username, 'password': password},
        {},
        (response) {
          // 记录一下用户信息
          setState(() => _successMessage = response.message);
          if (response.data == null) {
            throw Exception('登录失败');
          }
          Provider.of<AuthProvider>(
            context,
            listen: false,
          ).saveUserInfo(response.data!.id, response.data!.username,context);
          print('登录成功，跳转到聊天界面');
          // 跳转到聊天界面
          setState(() {
            GoRouter.of(context).go('/main/chat');
          });
        },
        (response) => {setState(() => _errorMessage = response.message)},
        UserData.fromJson,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isRegisterMode ? '注册' : '登录',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              if (_successMessage.isNotEmpty)
                Text(
                  _successMessage,
                  style: const TextStyle(color: Colors.green),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleAuth,
                child: Text(_isRegisterMode ? '注册' : '登录'),
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(_isRegisterMode ? '已有账号？登录' : '没有账号？注册'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
