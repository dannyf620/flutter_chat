import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_latest/pages/chat_page.dart';
import 'package:flutter_chat_latest/pages/loading_page.dart';
import 'package:flutter_chat_latest/pages/login_page.dart';
import 'package:flutter_chat_latest/pages/register_page.dart';
import 'package:flutter_chat_latest/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'users': ( _ ) => UsuariosPage(),
  'chat'    : ( _ ) => ChatPage(),
  'login'   : ( _ ) => LoginPage(),
  'register': ( _ ) => RegisterPage(),
  'loading' : ( _ ) => LoadingPage(),
};
