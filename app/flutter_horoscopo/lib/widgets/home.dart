import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_horoscopo/helpers/import_widgets.dart';
import 'package:flutter_horoscopo/theme/custom_theme.dart';

class home extends StatelessWidget {
  const home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF050A21),
      appBar: AppBar(
        title: Text('Horoscope'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: MenuPrincipal(context),
      ),
    );
  }
}
