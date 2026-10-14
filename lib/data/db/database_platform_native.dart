import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

DatabaseFactory get appDatabaseFactory => databaseFactory;

Future<String> databasePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return join(directory.path, fileName);
}
