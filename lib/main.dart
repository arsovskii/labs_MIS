import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab3/screens/authenticate/authenticate.dart';
import 'package:lab3/screens/entryWrapper.dart';
import 'package:lab3/screens/home/home.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        home: const Wrapper(),
        routes: {
          'home': (context) => Home(),
        },

      ),
    );
  }
}
