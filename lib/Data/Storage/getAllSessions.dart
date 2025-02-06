import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_learning/Data/models/session_model.dart';

List<Session> getAllSessions() {
  var box = Hive.box<Session>('sessions');
  return box.values.toList();
}
