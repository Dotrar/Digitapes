import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'list.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<DigitapeCubit>(
      create: (context) {
        var c = DigitapeCubit();
        c.setFromRepo();
        return c;
      },
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListPage(title: 'Digitapes'),
    );
  }
}
