import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
// define a digitape type

String getRootDirectory() {
  // todo get from elsewhere
  var path = p.join(Directory.current.path, 'digitapes');
  return path;
}

const String digitapesFilename = 'digitape.json';

class Digitape {
  String title;
  String description;
  DateTime updatedAt;
  String path;
  List<String> mediaFiles;

  Digitape(
      {required this.title,
      required this.description,
      required this.updatedAt,
      required this.path,
      required this.mediaFiles});

  Digitape.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        updatedAt = DateTime.parse(json['updated_at']),
        path = json['path'],
        // extract the "file" from each object in mediaFiles list
        mediaFiles =
            json['media'].map<String>((e) => e['file'] as String).toList();

  Digitape.createNew(this.title, this.description)
      : updatedAt = DateTime.now(),
        path = "${getRootDirectory()}/${getPathFromTitle(title)}",
        mediaFiles = [];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'updated_at': updatedAt.toIso8601String(),
        'path': path,
        'media': mediaFiles.map((e) => {'file': e}).toList()
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}

/// Get the digitape from a directory that is assumed to be a digitape
Digitape? digitapeFromDirectory(String path) {
  var digitape = File(p.join(path, digitapesFilename));

  if (!digitape.existsSync()) {
    print("digitape file does not exist $digitape");
    return null;
  }

  var digitapeContent = json.decode(digitape.readAsStringSync());
  digitapeContent['path'] = path;

  return Digitape.fromJson(digitapeContent);
}

String getPathFromTitle(String title) {
  var encodedTitle = base64.encode(utf8.encode(title));
  return '$encodedTitle/';
}

bool digitapeExistsByTitle(String title) {
  var encodedTitle = getPathFromTitle(title);
  var path = p.join(getRootDirectory(), encodedTitle, digitapesFilename);
  return File(path).existsSync();
}

bool digitapeExists(Digitape digitape) {
  return digitapeExistsByTitle(digitape.title);
}

List<Digitape> digitapesInRootDirectory(String rootPath) {
  var dir = Directory(rootPath);
  var digitapes = <Digitape>[];

  if (!dir.existsSync()) {
    return digitapes;
  }

  for (var entity in dir.listSync()) {
    print(entity);
    if (entity is Directory) {
      var digitape = digitapeFromDirectory(entity.path);
      print(digitape);
      if (digitape != null) {
        digitapes.add(digitape);
      }
    }
  }

  return digitapes;
}

Digitape? getDigitapeByTitle(String title) {
  var encodedTitle = getPathFromTitle(title);
  var path = p.join(getRootDirectory(), encodedTitle);
  return digitapeFromDirectory(path);
}

Digitape? renameDigitape(Digitape tape, String newtitle) {
  var newPath = getPathFromTitle(newtitle);

  if (Directory(p.join(getRootDirectory(), newPath)).existsSync()) {
    return null;
  }
  // rename old digitape path
  var dir = Directory(tape.path);
  dir.renameSync(newPath);
  tape.title = newtitle;
  syncDigitape(tape);
  return tape;
}

Digitape? addMediaToTape(Digitape digitape, String mediaPath) {
  var mediaFile = File(mediaPath);
  if (!mediaFile.existsSync()) {
    return null;
  }
  if (!digitapeExists(digitape)) {
    return null;
  }
  var mediaFilename = p.basename(mediaPath);
  var newMediaPath = p.join(digitape.path, mediaFilename);

  //move media file to digitape directory
  mediaFile.copySync(newMediaPath);

  if (!digitape.mediaFiles.contains(newMediaPath)) {
    digitape.mediaFiles.add(newMediaPath);
  }
  return digitape;
}

void syncDigitape(Digitape? digitape) {
  if (digitape == null) {
    return;
  }

  var dir = Directory(digitape.path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  var file = File(p.join(digitape.path, digitapesFilename));

  digitape.updatedAt = DateTime.now();
  file.writeAsStringSync(json.encode(digitape.toJson()));
}
