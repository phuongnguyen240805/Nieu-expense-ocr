import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

DatabaseFactory get appDatabaseFactory => databaseFactoryFfiWeb;

Future<String> databasePath(String fileName) async => fileName;
