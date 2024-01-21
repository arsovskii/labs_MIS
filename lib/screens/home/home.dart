import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab3/screens/home/kol_grid.dart';
import 'package:lab3/screens/modals/calendar.dart';
import 'package:lab3/screens/modals/kol_add.dart';

import '../../services/auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AuthService.getEmailOfCurrentUser().toString()),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => {
              Navigator.push(context, _createRouteCalendar())
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return kol_modal();
                },
              )
            },
          )
        ],
      ),
      body: Container(
        child: kol_grid(),
      ),
    );
  }

  Route _createRouteCalendar() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Calendar(),
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
}
