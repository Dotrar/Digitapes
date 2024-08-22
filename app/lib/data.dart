import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';

class Digitape {
  final String name;
  final String description;
  final ImageProvider? thumbnail;

  Digitape({
    required this.name,
    required this.description,
    required this.thumbnail,
  });
}

class DigitapesLocalProvider {
  Future<String> get _localPath async {
    if (kIsWeb) {
      return '/_webstorage';
    }

    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<Directory> get _tapeStorage async {
    final path = await _localPath;
    return Directory('$path/Tapes/').create();
  }

  Future<Digitape?> _loadTape(Directory d) async {
    final metadata = File("${d.path}/digitape.json");

    if (!await metadata.exists()) return null;

    final data = await metadata.readAsString();
    final map = jsonDecode(data);

    return Digitape(
      name: map['name'],
      description: map['description'],
      thumbnail: null,
    );
  }

  Future<List<Digitape>> readData() async {
    final tapesDir = await _tapeStorage;

    var ret = <Digitape>[];
    await for (final e in tapesDir.list(followLinks: false)) {
      final t = await _loadTape(Directory(e.path));
      if (t != null) ret.add(t);
    }
    return ret;
  }

  Future<bool> addLocalTape(String name, String description) async {
    final tapesDir = await _tapeStorage;
    final dirName = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    final dir = await Directory('${tapesDir.path}/$dirName').create();

    final jsonData = jsonEncode({
      'name': name,
      'description': description,
      'createdAt': dirName,
    });

    await File('${dir.path}/digitape.json').writeAsString(jsonData);
    return true;
  }
}
