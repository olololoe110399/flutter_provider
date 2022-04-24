import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_sample/pages/home_page.dart';
import 'package:provider_sample/providers/store.dart';

void main() {
  runApp(
    ChangeNotifierProvider<Store>(
      create: (_) => Store(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
