import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: I18nText(
          'home_screen.title',
        ),
      ),
      body: const Center(
        child: Text(
          'You are connected.',
        ),
      ),
    );
  }
}
