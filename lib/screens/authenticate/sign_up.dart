import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/authenticate/sign_in.dart';
import 'package:lab3/services/auth_service.dart';
import 'package:toastification/toastification.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _authService = AuthService();

  final _emailController1 = TextEditingController();
  final _emailController2 = TextEditingController();

  final _passwordController = TextEditingController();
  final _error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          title: const Text('Sign Up'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController1,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                  ),
                  validator: (String? value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                ),
                TextFormField(
                  controller: _emailController2,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email_outlined),
                    labelText: 'Repeat Email',
                  ),
                  validator: (String? value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                ),
                TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (String? value) => null),
                ElevatedButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      var email1 = _emailController1.text;
                      var email2 = _emailController2.text;

                      var password = _passwordController.text;

                      print(password);
                      if (email1 != "" && email1 == email2 && password != "") {
                        dynamic result = await _authService
                            .signUpWithMail(context, email1, password)
                            .then((value) => {
                                  if (value != null)
                                    {
                                      toastification.show(
                                        type: ToastificationType.info,
                                        context: context,
                                        title: 'Please verify your email address!',
                                        autoCloseDuration:
                                            const Duration(seconds: 5),
                                      ),
                                      Navigator.pop(context, _createRoute()),
                                    }
                                });
                      }
                    }),
                TextButton(
                    onPressed: () => {Navigator.pop(context, _createRoute())},
                    child: const Text("Already have an account? Log In!"))
              ],
            ),
          )),
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController1.dispose();
    _emailController2.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
