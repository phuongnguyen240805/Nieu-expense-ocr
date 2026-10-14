import 'dart:convert';
import 'dart:io';

/// Compile the upstream SQLite worker and fetch WASM matching the locked package.
/// Avoids installing the separate webdev/build_runner toolchain.
Future<void> main() async {
  final configFile = File('.dart_tool/package_config.json').absolute;
  final config = jsonDecode(await configFile.readAsString()) as Map;
  final packages = config['packages'] as List;
  Uri packageRoot(String name) {
    final entry = packages.cast<Map>().firstWhere((p) => p['name'] == name);
    final root = configFile.uri.resolve(entry['rootUri'] as String);
    return root.toString().endsWith('/') ? root : Uri.parse('$root/');
  }

  final worker = packageRoot('sqflite_common_ffi_web')
      .resolve('web/sqflite_sw.dart');
  await Directory('web').create(recursive: true);
  final result = await Process.run(Platform.resolvedExecutable, [
    'compile',
    'js',
    '-O4',
    '--packages=${configFile.path}',
    '-o',
    'web/sqflite_sw.js',
    worker.toFilePath(),
  ]);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    exit(result.exitCode);
  }

  final sqlitePubspec = await File.fromUri(
    packageRoot('sqlite3').resolve('pubspec.yaml'),
  ).readAsString();
  final version = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(sqlitePubspec)!.group(1)!;
  final uri = Uri.parse(
    'https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-$version/sqlite3.wasm',
  );
  final client = HttpClient();
  try {
    final response = await (await client.getUrl(uri)).close();
    if (response.statusCode != 200) {
      throw HttpException(
        'WASM download failed: ${response.statusCode}',
        uri: uri,
      );
    }
    await response.pipe(File('web/sqlite3.wasm').openWrite());
  } finally {
    client.close();
  }
  stdout.writeln('SQLite browser assets ready ($version).');
}
