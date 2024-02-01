import 'package:flutter/material.dart';
import 'package:lab3/screens/modals/location_pick.dart';
import 'package:lab3/services/db_service.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:toastification/toastification.dart';

import '../home/kol_grid.dart';

class kol_modal extends StatefulWidget {
  const kol_modal({super.key});

  @override
  State<kol_modal> createState() => _kol_modalState();
}

class _kol_modalState extends State<kol_modal> {
  final _examNameController = TextEditingController();
  final _dbService = dbService();


  final GlobalKey<kol_gridState> _key = GlobalKey<kol_gridState>();

  DateTime? _date;
  TimeOfDay? _time;
  LatLong? _location;

  void updateLocation(LatLong newValue) {
    setState(() {
      _location = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("eve sum sega!!!");
    print(_key);
    print(_key.currentState);
    print(_key.currentContext);
    print(_key.currentWidget);

    //TODO: ova da go zavrsam
    return SizedBox(
      height: 500,
      child: Center(
        child: Form(
            child: ListView(
          children: [
            TextFormField(
              controller: _examNameController,
              decoration: const InputDecoration(
                icon: Icon(Icons.check_circle_outline_rounded),
                labelText: 'Name of exam',
              ),
            ),
            OutlinedButton(
              child: Text(dateString()),
              onPressed: () async {
                var selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 2),
                );
                setState(() {
                  if (selectedDate != null) {
                    _date = selectedDate;
                  }
                });
              },
            ),
            OutlinedButton(
              child: Text(timeString()),
              onPressed: () async {
                var selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  if (selectedTime != null) {
                    _time = selectedTime;
                  }
                });
              },
            ),
            OutlinedButton(
              child: Text( locationString()),
              onPressed: ()  {
                Navigator.push(context, _createRouteLocationPick());
              },
            ),
            ElevatedButton(
              child: const Text("Add Exam"),
              onPressed: () {
                var text = _examNameController.text;

                if (text == "" || _date == null || _time == null) {
                  toastification.show(
                    type: ToastificationType.error,
                    context: context,
                    title: Text('Please fill out the form'),
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                  return;
                }

                _dbService.addExam(text, _date!, _time!, _location!);
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "home",
                  (route) => false,
                );
              },
            ),
          ],
        )),
      ),
    );
  }

  Route _createRouteLocationPick() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LocationChoose(updateLocation),
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

  String locationString(){
    if(_location == null){
      return "Choose location";
    }
    return "${_location?.latitude} ${_location?.longitude}";
  }

  String timeString() {
    if (_time == null) {
      return "Choose time";
    }

    return "${_time!.hour}:${_time!.minute}";
  }

  String dateString() {
    if (_date == null) {
      return "Choose date";
    }

    return "${_date!.day}/${_date!.month}/${_date!.year}";
  }
}
