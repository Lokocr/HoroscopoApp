import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

final annioActual = DateTime.now();

final List<String> entriesImages = <String>[
  '005-aries.png',
  '030-taurus.png',
  '012-gemini.png',
  '008-cancer.png',
  '015-leo.png',
  '032-uranus.png',
  '017-libra.png',
  '027-scorpio.png',
  '024-sagittarius.png',
  '010-capricorn.png',
  '003-aquarius.png',
  '022-pisces.png'
];

final List<String> entries = <String>[
  'Aries',
  'Taurus',
  'Geminis',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces'
];

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
        drawer: _DrawerPrincipal(),
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(),
              _MenuPrincipal(),
            ],
          ),
        ),
      ),
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
    return Expanded(
      child: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: entries.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Image(
                      image:
                          AssetImage('assets/graphics/${entriesImages[index]}'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () => {debugPrint('Prueba ${entries[index]}')},
                      child: Text(
                        '${entries[index]}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        color: const Color(0XFF002233),
      ),
      child: Column(
        children: [
          Text(
            'Horoscope ${annioActual.year}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Drawer(
          elevation: 2,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              DrawerHeader(
                // padding: EdgeInsets.all(20),
                child: Text(
                  'Horoscopo ${annioActual.year}',
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF002233),
                ),
              ),
              ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.home),
              ),
              ListTile(
                title: Text('Comming soon...'),
                leading: Icon(Icons.info_outline),
              ),
              Divider(),
              ListTile(
                title: Text('Privacy Policy'),
                leading: Icon(Icons.security),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
