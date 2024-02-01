import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab3/screens/home/kol_grid.dart';
import 'package:lab3/screens/modals/calendar.dart';
import 'package:lab3/screens/modals/kol_add.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../localNotifications/Noti.dart';
import '../../services/auth_service.dart';
import '../modals/map.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<List<double>> locations = [];

  @override
  void initState() {
    super.initState();

    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  List<List<double>> listLocations(List<List<double>> list) {
    locations = list;
    print(locations);
    return locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AuthService.getEmailOfCurrentUser().toString()),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.pin_drop),
            onPressed: () => {
              Navigator.push(context, _createRouteMap()),
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => {Navigator.push(context, _createRouteCalendar())},
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
        child: kol_grid(listLocations),
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

  Route _createRouteMap() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => GMap.locations( locations: locations,),
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
