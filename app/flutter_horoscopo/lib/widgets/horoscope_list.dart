import 'package:flutter/material.dart';
import 'package:flutter_horoscopo/views/signView.dart';

final List<String> entriesImages = <String>[
  'Aries.png',
  'Taurus.png',
  'Geminis.png',
  'Cancer.png',
  'Leo.png',
  'Virgo.png',
  'Libra.png',
  'Scorpio.png',
  'Sagitarius.png',
  'Capricornio.png',
  'Aquarius.png',
  'Pisces.png'
];

final List<String> entries = <String>[
  'Aries',
  'Taurus',
  'Gemini',
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

Widget MenuPrincipal(BuildContext context) {
  return Container(
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: entries.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            callSignView(context, index);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Hero(
                tag: 'photo_$index',
                child: Image(
                  image: AssetImage('assets/graphics/${entriesImages[index]}'),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Future<dynamic> callSignView(BuildContext context, int index) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StateSignView(
        signName: entries[index],
        indice: index,
      ),
    ),
  );
}
