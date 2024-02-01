import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab3/screens/home/home.dart';
import 'package:lab3/services/db_service.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localNotifications/Noti.dart';
import '../../model/exam.dart';
import '../modals/map.dart';

class kol_grid extends StatefulWidget {
  final Function(List<List<double>>) getLocations;

  const kol_grid(this.getLocations, {super.key});

  @override
  State<kol_grid> createState() => kol_gridState();
}

class kol_gridState extends State<kol_grid> {
  final _db = dbService();
  Future<List<Exam>>? examList;
  List<Exam>? rExamList;
  List<List<double>> listLocations = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    examList = _db.getExams();

    rExamList = await _db.getExams();

    rExamList?.forEach((element) {
      print(element);
      DateTime current = DateTime(element.year, element.month, element.day,
          element.hour, element.minute);

      final event = CalendarEventData(title: element.title, date: current);
      if (!context.mounted) {
        return;
      }
      print("dodavam events vo kalendaro");
      CalendarControllerProvider.of(context).controller.add(event);

      Noti.showFutureNotif(
          element.title,
          "${element.hour} : ${element.minute}",
          element.year,
          element.month,
          element.day,
          element.hour,
          element.minute);
    });

    setupLocations();
  }

  void setupLocations() {
    rExamList?.forEach((element) {
      listLocations.add([element.lat, element.long]);
    });
    widget.getLocations(listLocations);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: examList,
        builder: (BuildContext context, AsyncSnapshot<List<Exam>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                    child: SizedBox(
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        elevation: 10.0,
                        child: Column(
                          children: [
                            Text('${snapshot.data?[index].title}',
                                style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '${snapshot.data?[index].day}/${snapshot.data?[index].month}/${snapshot.data?[index].year}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.blueGrey.shade400),
                                    ),
                                    Text(
                                      '${snapshot.data?[index].hour}:${snapshot.data?[index].minute}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.blueGrey.shade400),
                                    ),
                                    TextButton(
                                      child: Text(
                                          '${snapshot.data?[index].lat} : ${snapshot.data?[index].long}'),
                                      onPressed: () async {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) => GMap.location(lat:snapshot.data![index].lat,long:snapshot.data![index].long),
                                        //   ),
                                        // ),
                                        await GMapState.getLocation();
                                        LocationData currentPosition =GMapState.locationData;

                                        String origin =
                                            '${currentPosition.latitude},${currentPosition.longitude}';
                                        String destination =
                                            '${snapshot.data?[index].lat},${snapshot.data?[index].long}';

                                        final Uri _url = Uri.parse(
                                            'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving&dir_action=navigate');

                                        await launchUrl(
                                          _url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (1 / 0.6),
                  crossAxisCount: 1,
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
