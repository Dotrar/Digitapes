import 'package:flutter/material.dart';
import 'data.dart';

///***********************************************************
/// Tape Page
/// shows details about a particular tape including
/// thumbnails, and allows some media to be deleted
/// or title / description to be edited

class TapePage extends StatefulWidget {
  final Digitape tape;
  const TapePage({super.key, required this.tape});

  @override
  State<TapePage> createState() => TapePageState();
}

class TapePageState extends State<TapePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.tape.name),
        actions: [],
      ),
      body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          padding: const EdgeInsets.all(4),
          children: [
            for (var i = 1; i <= 15; i++)
              (ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.red[(100 * i).toInt()],
                    child: Text((100 * i).toString()),
                  )))
          ]),
    );
  }
}
