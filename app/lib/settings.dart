import 'dart:convert';

import 'package:flutter/material.dart';
import 'base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path/path.dart' as path_lib;

class ServiceConfiguration {
  final String name;
  final Map<String, String> data;

  const ServiceConfiguration({
    required this.name,
    required this.data,
  });

  String toJsonString() {
    return jsonEncode(
      {
        'name': name,
        'data': data,
      },
    );
  }

  ServiceConfiguration fromJsonString(String data) {
    var ob = jsonDecode(data);
    return ServiceConfiguration(
      name: ob['name'],
      data: ob['data'],
    );
  }
}

typedef ServiceConfigurations = List<ServiceConfiguration>;

///***********************************************************
/// Settings page

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<ServiceConfigurations> _configuredServices;
  late Future<String> _localDirectory;

  @override
  void initState() {
    super.initState();
    _configuredServices = _prefs.then((SharedPreferences prefs) {
      return [];
    });
    _localDirectory = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('local_directory') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: ListView(children: [
        const Heading("Local Directory"),
        const Blurb("This is the local folder"),
        FutureBuilder<String>(
            future: _localDirectory,
            initialData: "",
            builder: (BuildContext c, AsyncSnapshot<String> s) {
              switch (s.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (s.hasError) {
                    return Text('Error: ${s.error}');
                  } else {
                    return Blurb(s.data ?? "");
                  }
              }
            }),
        TextButton(child: const Text("Change Folder"), onPressed: () {}),
        const Heading("Connected Services"),
        const Blurb("This is some stuff"),
        const Heading("Queue"),
      ]),
    );
  }
}   

/*
child: FutureBuilder<int>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {

              })),
*/
