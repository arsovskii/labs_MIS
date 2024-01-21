import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:lab3/services/db_service.dart';

import '../../model/exam.dart';

class kol_grid extends StatefulWidget {
  const kol_grid({super.key});

  @override
  State<kol_grid> createState() => kol_gridState();
}

class kol_gridState extends State<kol_grid> {
  final _db = dbService();
  Future<List<Exam>>? examList;
  List<Exam>? rExamList;

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
      CalendarControllerProvider.of(context).controller.add(event);


    });
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
                        margin: const EdgeInsets.all(20.0),
                        elevation: 10.0,
                        child: Column(
                          children: [
                            Text('${snapshot.data?[index].title}',
                                style: const TextStyle(
                                    fontSize: 64,
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
                                          fontSize: 30,
                                          color: Colors.blueGrey.shade400),
                                    ),
                                    Text(
                                      '${snapshot.data?[index].hour}:${snapshot.data?[index].minute}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.blueGrey.shade400),
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
