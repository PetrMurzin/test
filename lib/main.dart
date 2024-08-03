import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dert/firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I<Talker>().debug('Talker started');
  final dio = Dio();
  dio.interceptors.add(TalkerDioLogger(talker: talker));
  Bloc.observer = TalkerBlocObserver(talker: talker);

  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorObservers: [
        TalkerRouteObserver(GetIt.I<Talker>()),
      ],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(
                    talker: GetIt.I<Talker>(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.document_scanner_outlined,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            const Text(
              'You have pushed the button this many times:',
            ),
            SizedBox(height: 50),
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '$_counter',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      //add
      //add main

      //add develop
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
