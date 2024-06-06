import 'package:dbhs/dbhs.dart' as dt;

void listDigitapes() {
  var digitapes = dt.digitapesInRootDirectory(dt.getRootDirectory());

  for (var digitape in digitapes) {
    print(digitape.toString());
  }
}

void createDigitape(String title, String description) {
  var digitape = dt.Digitape.createNew(title, description);
  if (dt.digitapeExists(digitape)) {
    return;
  }
  dt.syncDigitape(digitape);
}

void addMediaToTapeByTitle(String title, String mediaPath) {
  var digitape = dt.getDigitapeByTitle(title);
  if (digitape == null) {
    return;
  }
  var newDigitape = dt.addMediaToTape(digitape, mediaPath);
  if (newDigitape == null) {
    return;
  }
  dt.syncDigitape(newDigitape);
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
