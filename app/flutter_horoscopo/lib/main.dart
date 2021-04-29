import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MyApp());
}

final List<String> entries = <String>['Aries', 'Tauro', 'Geminis', 'Cancer', 'Leo',
                                      'Virgo', 'Libra', 'Escorpio', 'Sagitario',
                                        'Capricornio', 'Acuario', 'Piscis'];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF002233),
        drawer: Drawer(),
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(),
              _MainContent(),
            ],
          ),
        ),
        bottomNavigationBar: _MenuInferior(),

      ),
    );
  }
}

class _MenuInferior extends StatelessWidget {
  const _MenuInferior({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inclusive),
          label: 'More...'
        ),
      ],
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}

class _MenuPrincipal extends StatelessWidget {
  const _MenuPrincipal({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: entries.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 150,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: TextButton(
                onPressed: () => {
                  debugPrint('Prueba ${entries[index]}')
                },
               child: Text(
                 '${entries[index]}',
                 style: TextStyle(color: Colors.white),
               ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0XFF002233),
      ),
      child: Column(
        children: [
          Text(
            'Horoscopo 2021',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          _MenuPrincipal(),
        ],
      ),
    );
  }
}