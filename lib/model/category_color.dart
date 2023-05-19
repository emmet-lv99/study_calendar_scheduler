import 'package:drift/drift.dart';

class CategoryColor extends Table {
//  PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();

// hexCode
  TextColumn get hexCode => text()();
}
