import 'package:dbhs/dbhs.dart' as dt;

typedef Err = String;

void listDigitapes() {
  var digitapes = dt.digitapesInRootDirectory(dt.getRootDirectory());

  for (var digitape in digitapes) {
    print(digitape.toString());
  }
}

Err? createDigitape(String title, String description) {
  var digitape = dt.Digitape.createNew(title, description);
  if (dt.digitapeExists(digitape)) {
    return "Digitape already exists";
  }
  dt.syncDigitape(digitape);
  return null;
}

Err? addMediaToTapeByTitle(String title, String mediaPath) {
  var digitape = dt.getDigitapeByTitle(title);
  if (digitape == null) {
    return "Digitape by title '$title' Doesn't exist";
  }
  var newDigitape = dt.addMediaToTape(digitape, mediaPath);
  if (newDigitape == null) {
    return "Media file '$mediaPath' not found";
  }
  dt.syncDigitape(newDigitape);
  return null;
}

Err? changeDigitapeTitle(String oldtitle, String newtitle) {
  var digitape = dt.getDigitapeByTitle(oldtitle);
  if (digitape == null) {
    return "Cannot find digitape '$oldtitle'";
  }
  if (dt.getDigitapeByTitle(newtitle) != null) {
    return "Cannot rename '$oldtitle' to '$newtitle', because '$newtitle' already exists";
  }
  dt.renameDigitape(digitape, newtitle);
  return null;
}

Err? changeDigitapeDescription(String title, String description) {
  var digitape = dt.getDigitapeByTitle(title);
  if (digitape == null) {
    return "Cannot find digitape '$title'";
  }
  digitape.description = description;
  dt.syncDigitape(digitape);
  return null;
}

void main() {
  print("== Listing digitapes in root directory");
  listDigitapes();

  print("== Creating a dtnew tape");
  createDigitape('My First Digitape', 'This is a test digitape');

  print("== Adding media to tape");
  addMediaToTapeByTitle('My First Digitape', 'README.md');

  print("== Finished");
  print(dt.getDigitapeByTitle('My First Digitape'));
}
