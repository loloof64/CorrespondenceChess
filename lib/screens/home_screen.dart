import 'package:correspondence_chess/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: I18nText(
          'home_screen.title',
          translationParams: {
            "nickname": user!.email,
          },
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
