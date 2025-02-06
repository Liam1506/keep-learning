import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_learning/Data/models/session_model.dart';

void saveSession(Session session) async {
  var box = Hive.box<Session>('sessions');
  await box.add(session);
}
