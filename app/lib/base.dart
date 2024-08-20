//* Base settings */
import 'package:flutter/material.dart';

const settingsIcon = Icon(Icons.settings);
const addIcon = Icon(Icons.add);

class Heading extends Text {
  const Heading(
    super.data, {
    super.key,
    style = const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    textAlign = TextAlign.center,
  });
}

class Blurb extends Text {
  const Blurb(
    super.data, {
    super.key,
    textAlign = TextAlign.justify,
  });
}
