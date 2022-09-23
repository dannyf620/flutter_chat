import 'package:flutter/material.dart';
import 'package:flutter_chat_latest/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_latest/services/auth_service.dart';
import 'package:flutter_chat_latest/helpers/mostrar_alerta.dart';
import 'package:flutter_chat_latest/widgets/boton_azul.dart';
import 'package:flutter_chat_latest/widgets/custom_input.dart';
import 'package:flutter_chat_latest/widgets/labels.dart';

import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(titulo: 'Messenger'),
                  _Form(),
                  Labels(
                    ruta: 'register',
                    titulo: '¿No tienes cuenta?',
                    subTitulo: 'Crea una ahora!',
                  ),
                  Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Ingrese',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      // TODO: Conectar a nuestro socket server
                      _completeLogin();
                    } else {
                      mostrarAlerta(context, 'Login incorrecto',
                          'Ingrese las credenciales correctas');
                    }
                  },
          )
        ],
      ),
    );
  }

  _completeLogin() {
    Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => appRoutes['users']!(context)));
  }
}
