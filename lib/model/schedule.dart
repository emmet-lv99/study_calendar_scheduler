import 'package:drift/drift.dart';

class Schedule extends Table {
  //  PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

  //  content
  TextColumn get content => text()();

  //  date
  DateTimeColumn get date => dateTime()();

  // startTime
  IntColumn get startTime => integer()();

  //  endTime
  IntColumn get endTime => integer()();

  // colorId
  IntColumn get colorId => integer()();

//  createdAt
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
