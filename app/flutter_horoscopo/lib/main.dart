import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_horoscopo/views/signView.dart';

import 'package:flutter_horoscopo/helpers/adsHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

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
          title: Text('Horoscope ${annioActual.year}'),
          centerTitle: true,
          backgroundColor: const Color(0xFF002233),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // _AppBar(),
              _MenuPrincipal(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuPrincipal extends StatefulWidget {
  const _MenuPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  State<_MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<_MenuPrincipal> {
  InterstitialAd? _interstitialAd;

  bool _isInterstitialAdReady = false;

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
            return GestureDetector(
              onTap: () {
                _loadInterstitialAd();
                if (_isInterstitialAdReady) {
                  _interstitialAd?.show();
                }

                callSignView(context, index);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage(
                            'assets/graphics/${entriesImages[index]}'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> callSignView(BuildContext context, int index) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StateSignView(
          signName: entries[index],
        ),
      ),
    );
  }
}
