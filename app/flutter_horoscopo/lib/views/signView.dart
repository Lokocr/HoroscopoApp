import 'package:flutter/material.dart';

class SignView extends StatelessWidget {
  final String signName;

  SignView({Key key, @required this.signName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002233),
      appBar: AppBar(
        title: Text('Horoscope $signName'),
        centerTitle: true,
        backgroundColor: const Color(0xFF002233),
        elevation: 0,
      ),
      body: _MainContent(
        signName: this.signName,
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final String signName;

  const _MainContent({
    Key key,
    @required this.signName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Text('Information about sign: $signName'),
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
                      margin: EdgeInsets.only(
                        right: 30,
                        top: 20,
                      ),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
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
  }
}
