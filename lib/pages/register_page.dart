import 'package:flutter/material.dart';
import 'package:flutter_chat_latest/helpers/mostrar_alerta.dart';
import 'package:flutter_chat_latest/routes/routes.dart';
import 'package:flutter_chat_latest/services/auth_service.dart';
import 'package:flutter_chat_latest/widgets/boton_azul.dart';
import 'package:flutter_chat_latest/widgets/custom_input.dart';
import 'package:flutter_chat_latest/widgets/labels.dart';
import 'package:flutter_chat_latest/widgets/logo.dart';
import 'package:provider/provider.dart';



class RegisterPage extends StatelessWidget {

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

                Logo( titulo: 'Registro' ),

                _Form(),

                Labels( 
                  ruta: 'login',
                  titulo: '¿Ya tienes una cuenta?',
                  subTitulo: 'Ingresa ahora!',
                ),

                Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200 ),)

              ],
            ),
          ),
        ),
      )
   );
  }
}



class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: true);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50 ),
       child: Column(
         children: <Widget>[
           
           CustomInput(
             icon: Icons.perm_identity,
             placeholder: 'Nombre',
             keyboardType: TextInputType.text, 
             textController: nameCtrl,
           ),

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
             text: 'Crear Cuenta',
             onPressed: authService.autenticando? null: () async {

               print( emailCtrl.text );
               print( passCtrl.text );
               final registerOk = await authService.register(nameCtrl.text,emailCtrl.text.trim(), passCtrl.text);
               if(registerOk   == true) {
                 // ignore: use_build_context_synchronously
                 Navigator.pushReplacement<void, void>(
                     context,
                     MaterialPageRoute<void>(
                         builder: (BuildContext context) => appRoutes['users']!(context)));
               } else {
                 // ignore: use_build_context_synchronously
                 mostrarAlerta(context, 'Error de registro', registerOk);
               }
             },
           )



         ],
       ),
    );
  }
}
