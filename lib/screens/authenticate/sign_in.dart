import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/authenticate/sign_up.dart';
import 'package:lab3/services/auth_service.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          title: const Text('Sign in'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email_outlined),
                    labelText: 'Email',
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
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      var email = _emailController.text;
                      var password = _passwordController.text;

                      print(email);
                      print(password);
                      if (email != "" && password != "") {
                        try {
                          dynamic result = await _authService.signInWithMail(
                              context, email, password);
                          print(result);
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'home',
                                (route) => false,
                          );
                        }
                        catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Unsucessful Login"),
                          ));

                        }
                      }
                    }),
                TextButton(
                    onPressed: () => {Navigator.push(context, _createRoute())},
                    child: Text("Don't have an account? Create one now!"))
              ],
            ),
          )),
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
