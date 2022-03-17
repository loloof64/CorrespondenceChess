import 'package:correspondence_chess/components/start_screen.dart';
import 'package:correspondence_chess/services/authentication_service.dart';

import './models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: MaterialApp(
        onGenerateTitle: (context) =>
            FlutterI18n.translate(context, 'app.title'),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              basePath: 'assets/i18n',
              useCountryCode: false,
              fallbackFile: 'en',
              decodeStrategies: [YamlDecodeStrategy()],
            ),
            missingTranslationHandler: (key, locale) {
              Logger().w(
                  "--- Missing Key: $key, languageCode: ${locale?.languageCode}");
            },
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
          Locale('es', ''),
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => const StartScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
