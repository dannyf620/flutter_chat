import 'package:flutter/material.dart';
import 'package:flutter_chat_latest/routes/routes.dart';
import 'package:flutter_chat_latest/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_ ) => AuthService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes

      ),
    );
  }
}
