import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  final String title;
  final String user;
  final int day;
  final int month;
  final int year;
  final int hour;
  final int minute;

  Exam(this.title, this.user, this.day, this.month, this.year, this.hour,
      this.minute);

  factory Exam.fromDocument(DocumentSnapshot document) {
    print(document.id);
    return Exam(
      document['title'],
      document['user'],
      document['day'],
      document['month'],
      document['year'],
      document['hour'],
      document['minute'],
    );
  }

  Map<String, dynamic> asMap() =>{
    'title':title,
    'user':user,
    'day':day,
    'month':month,
    'year':year,
    'hour':hour,
    'minute':minute,

  };
}
