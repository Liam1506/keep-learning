import 'package:hive_flutter/hive_flutter.dart';

class DataStore {
  static final DataStore _instance = DataStore._internal();
  late Box _box;

  factory DataStore() {
    return _instance;
  }

  DataStore._internal();

  /// Initializes Hive and opens the box
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('dataStore');
  }

  /// Saves a value to Hive
  Future<void> saveValue(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Retrieves a value from Hive
  dynamic getValue(String key, {dynamic defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  /// Deletes a value from Hive
  Future<void> deleteValue(String key) async {
    await _box.delete(key);
  }

  /// Clears all stored values
  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> saveRefreshDate() async {
    String dateOnly = DateTime.now().toIso8601String().split('T')[0];
    await _box.put('refreshDate', dateOnly);
  }

  /// Retrieves the last refresh date as a DateTime object (without time)
  DateTime? getLastRefreshDate() {
    String? storedDate = _box.get('refreshDate');
    return storedDate != null ? DateTime.parse(storedDate) : null;
  }

  bool isRefreshed() {
    DateTime? lastRefreshDate = getLastRefreshDate();
    if (lastRefreshDate == null) {
      saveRefreshDate();
      lastRefreshDate = getLastRefreshDate();
    }

    return DateTime.now().toIso8601String().split('T')[0] ==
        lastRefreshDate!.toIso8601String().split('T')[0];
  }
}
