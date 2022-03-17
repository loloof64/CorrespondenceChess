import 'package:correspondence_chess/components/dialog_button.dart';
import 'package:correspondence_chess/models/user.dart';
import 'package:correspondence_chess/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _logOut() async {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: I18nText('home_screen.logout_confirmation_title'),
              content: I18nText('home_screen.logout_confirmation_message'),
              actions: [
                DialogActionButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await AuthenticationService().signOut();
                  },
                  textContent: I18nText('button.ok'),
                  backgroundColor: Colors.greenAccent,
                  textColor: Colors.white,
                ),
                DialogActionButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  textContent: I18nText('button.cancel'),
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                ),
              ],
            );
          });
    }

    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: I18nText(
          'home_screen.title',
          translationParams: {
            "nickname": user!.email,
          },
        ),
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'You are connected.',
        ),
      ),
    );
  }
}
