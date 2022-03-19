import 'package:correspondence_chess/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../components/password_field.dart';
import '../services/authentication_service.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pseudonymController = TextEditingController();
  bool _registerMode = false;
  final _authService = AuthenticationService();
  String? _error;
  bool _loading = false;

  Future<void> _authenticateUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final pseudonym = _pseudonymController.text;

    if (pseudonym.length < 4 && _registerMode) {
      setState(() {
        _error = FlutterI18n.translate(
          context,
          'signin_screen.pseudonym_too_short',
        );
      });
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(pseudonym) && _registerMode) {
      setState(() {
        _error = FlutterI18n.translate(
          context,
          'signin_screen.pseudonym_alphanumeric_required',
        );
      });
      return;
    }

    final valuesAlreadyTaken = await AllUsersDatabaseService()
        .checkForValuesAlreadyRegistered(
            {'email': email, 'pseudonym': pseudonym});
    if (valuesAlreadyTaken.isNotEmpty && _registerMode) {
      List<String> errorsList = [];

      if (valuesAlreadyTaken.contains('email')) {
        errorsList.add(
          FlutterI18n.translate(context, 'signin_screen.email_already_taken'),
        );
      }

      if (valuesAlreadyTaken.contains('pseudonym')) {
        errorsList.add(
          FlutterI18n.translate(
              context, 'signin_screen.pseudonym_already_taken'),
        );
      }

      setState(() {
        _error = errorsList.join('\n');
      });
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    final result = _registerMode
        ? await _authService.registerWithEmailAndPassword(
            email: email,
            password: password,
            pseudonym: pseudonym,
            context: context)
        : await _authService.signInWithEmailAndPassword(
            email: email, password: password, context: context);

    /*
    In register mode we may have already have exited screen when the next setState
    calls "happen".
    */
    if (_registerMode) return;

    setState(() {
      _loading = false;
    });

    if (result is String) {
      setState(() {
        _error = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: I18nText(
          'signin_screen.title',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      I18nText('signin_screen.register_field'),
                      Switch(
                        value: _registerMode,
                        onChanged: (newValue) {
                          setState(() {
                            _registerMode = newValue;
                          });
                        },
                      )
                    ],
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(
                        context,
                        'signin_screen.email_field',
                      ),
                      hintText: FlutterI18n.translate(
                        context,
                        'signin_screen.email_hint',
                      ),
                    ),
                  ),
                  _registerMode
                      ? TextField(
                          controller: _pseudonymController,
                          decoration: InputDecoration(
                            labelText: FlutterI18n.translate(
                              context,
                              'signin_screen.pseudonym_field',
                            ),
                            hintText: FlutterI18n.translate(
                              context,
                              'signin_screen.pseudonym_hint',
                            ),
                          ),
                        )
                      : const SizedBox(),
                  PasswordField(
                    controller: _passwordController,
                    labelText: FlutterI18n.translate(
                      context,
                      'signin_screen.password_field',
                    ),
                    hintText: FlutterI18n.translate(
                      context,
                      'signin_screen.password_hint',
                    ),
                  ),
                  _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _authenticateUser,
                      child: I18nText(
                        _registerMode
                            ? 'signin_screen.register'
                            : 'signin_screen.connect',
                      ),
                    ),
                  ),
                ],
              ),
              _loading
                  ? const Center(
                      child: SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator()),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
