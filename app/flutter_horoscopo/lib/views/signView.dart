import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_horoscopo/models/horoscope.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_horoscopo/helpers/adsHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<Horoscope> fetchDataSign(String _signName) async {
  final response = await http.post(
    Uri.https(
      'aztro.sameerkumar.website',
      '/',
      // Query Elements
      {
        "sign": "$_signName",
        "day": "today",
      },
    ),
  );

  // Validate if the response is OK.
  if (response.statusCode == 200) {
    Horoscope _respose = Horoscope.fromJson(jsonDecode(response.body));
    _respose.sign = _signName;
    return _respose;
  } else {
    throw Exception('Failed to load data from API.');
  }
}

class StateSignView extends StatefulWidget {
  final String signName;

  StateSignView({Key key, @required this.signName}) : super(key: key);

  @override
  __StateSignViewState createState() => __StateSignViewState(this.signName);
}

class __StateSignViewState extends State<StateSignView> {
  Future<Horoscope> futureHoroscope;
  final String signName;

  __StateSignViewState(this.signName);

  static final _kAdIndex = 4;
  BannerAd _ad;
  bool _isAdLoaded = false;

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  void initState() {
    super.initState();
    futureHoroscope = fetchDataSign(this.signName);

    // Creamos el Banner
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(futureHoroscope.asStream().toString());

    return Scaffold(
      backgroundColor: const Color(0xFF002233),
      appBar: AppBar(
        title: Text('Horoscope ${this.signName}'),
        centerTitle: true,
        backgroundColor: const Color(0xFF002233),
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            width: _ad.size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
            child: AdWidget(
              ad: _ad,
            ),
          ),
          preferredSize: Size.fromHeight(80.0),
        ),
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
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  left: 30,
                                  bottom: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade200.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Date: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  right: 30,
                                  bottom: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      snapshot.data.current_date,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  left: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade200.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Number: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  right: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      snapshot.data.lucky_number,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            right: 30,
                            top: 20,
                            bottom: 20,
                            left: 30,
                          ),
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.9),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            snapshot.data.description,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  left: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade200.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Color: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  right: 30,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                    color:
                                        Colors.grey.shade200.withOpacity(0.9),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      snapshot.data.color,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.toString()}");
        }

        return LinearProgressIndicator();
      },
    );
  }
}
