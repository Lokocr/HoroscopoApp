import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_horoscopo/models/horoscope.dart';
import 'package:http/http.dart' as http;

Future<Horoscope> fetchDataSign() async {
  final response = await http.get(
    Uri.https('ohmanda.com', 'api/horoscope/aquarius'),
  );

  // Validate if the response is OK.
  if (response.statusCode == 200) {
    return Horoscope.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data from API.');
  }
}

class StateSignView extends StatefulWidget {
  final String signName;

  StateSignView({Key key, @required this.signName}) : super(key: key);

  @override
  __StateSignViewState createState() => __StateSignViewState();
}

class __StateSignViewState extends State<StateSignView> {
  Future<Horoscope> futureHoroscope;

  @override
  void initState() {
    super.initState();
    futureHoroscope = fetchDataSign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002233),
      appBar: AppBar(
        title: Text('Horoscope'),
        centerTitle: true,
        backgroundColor: const Color(0xFF002233),
        elevation: 0,
      ),
      body: _MainContent(
        horoscope: futureHoroscope,
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final Future<Horoscope> horoscope;

  const _MainContent({
    Key key,
    @required this.horoscope,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Horoscope>(
      future: horoscope,
      builder: (context, snapshot) {
        debugPrint('Data: $horoscope');

        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.9),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Text('Information about sign: ${snapshot.data.sign}'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 30,
                            ),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                              right: 30,
                              top: 20,
                            ),
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(snapshot.data.horoscope),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 30,
                              top: 20,
                            ),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          // Este sera para anuncios.
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.9),
                            ),
                            child: Center(
                              child: Text('Cuadro de anuncios.'),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}
