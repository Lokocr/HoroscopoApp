import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_horoscopo/models/horoscope.dart';
import 'package:flutter_horoscopo/theme/custom_colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_horoscopo/helpers/adsHelper.dart';

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

Future<Horoscope> fetchDataSign_Today(String _signName) async {
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

Future<Horoscope> fetchDataSign_Yesterday(String _signName) async {
  final response = await http.post(
    Uri.https(
      'aztro.sameerkumar.website',
      '/',
      // Query Elements
      {
        "sign": "$_signName",
        "day": "yesterday",
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
  final int indice;

  StateSignView({
    Key? key,
    required this.signName,
    required this.indice,
  }) : super(key: key);

  @override
  __StateSignViewState createState() =>
      __StateSignViewState(this.signName, this.indice);
}

class __StateSignViewState extends State<StateSignView> {
  __StateSignViewState(this.signName, this.indice);

  String signName;
  int indice;

  late Future<Horoscope> futureHoroscope_today;
  late Future<Horoscope> futureHoroscope_yesterday;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;

  bool _isInterstitialAdReady = false;

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    futureHoroscope_today = fetchDataSign_Today(this.signName);
    futureHoroscope_yesterday = fetchDataSign_Yesterday(this.signName);

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundApp,
      bottomNavigationBar: SizedBox(
        height: 60.0,
        child: Container(
          child: Column(
            children: [
              if (_isBannerAdReady)
                SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_isInterstitialAdReady) {
              _interstitialAd?.show();
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: mainContent(context),
    );
  }

  Widget mainContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Hero(
          tag: 'photo_${this.indice}',
          child: Image(
            width: 200,
            image: AssetImage(
              'assets/graphics/${entriesImages[indice]}',
            ),
          ),
        ),
        Expanded(
          child: content(
            futureHoroscope_today: futureHoroscope_today,
            futureHoroscope_yesterday: futureHoroscope_yesterday,
          ),
        )
      ],
    );
  }
}

class content extends StatefulWidget {
  final Future<Horoscope> futureHoroscope_today;
  final Future<Horoscope> futureHoroscope_yesterday;

  const content({
    Key? key,
    required this.futureHoroscope_today,
    required this.futureHoroscope_yesterday,
  }) : super(key: key);

  @override
  State<content> createState() =>
      _contentState(this.futureHoroscope_today, this.futureHoroscope_yesterday);
}

class _contentState extends State<content> {
  int indexSelected = 0;
  Future<Horoscope> futureHoroscope_today;
  Future<Horoscope> futureHoroscope_yesterday;

  _contentState(this.futureHoroscope_today, this.futureHoroscope_yesterday);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // color: CustomColors.backgroundAppSecondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          margin: EdgeInsets.only(
            top: 10,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          indexSelected = 1;
                        });
                      },
                      child: Text(
                        'Yesterday',
                        style: TextStyle(
                          color: (indexSelected == 1)
                              ? Colors.white
                              : Colors.white38,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          indexSelected = 0;
                        });
                      },
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: (indexSelected == 0)
                              ? Colors.white
                              : Colors.white38,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: CustomColors.backgroundAppSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(
                        0.0,
                        0.0,
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: future_content(context,
                      indexSelected: indexSelected,
                      futureHoroscope_today: this.futureHoroscope_today,
                      futureHoroscope_yesterday:
                          this.futureHoroscope_yesterday),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget future_content(BuildContext context,
    {required int indexSelected,
    required futureHoroscope_today,
    required futureHoroscope_yesterday}) {
  return FutureBuilder<Horoscope>(
    future: (indexSelected == 0)
        ? futureHoroscope_today
        : futureHoroscope_yesterday,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Compatibility: ',
                    style: TextStyle(fontSize: 22.0, color: Colors.white)),
                Text(
                  snapshot.data!.compatibility,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Color: ',
                    style: TextStyle(fontSize: 22.0, color: Colors.white)),
                Text(
                  snapshot.data!.color,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Lucky Number: ',
                    style: TextStyle(fontSize: 22.0, color: Colors.white)),
                Text(
                  snapshot.data!.lucky_number,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Lucky Time: ',
                    style: TextStyle(fontSize: 22.0, color: Colors.white)),
                Text(
                  snapshot.data!.lucky_time,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Mood: ',
                    style: TextStyle(fontSize: 22.0, color: Colors.white)),
                Text(
                  snapshot.data!.mood,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.description,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white60,
                  ),
                ),
              ],
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
