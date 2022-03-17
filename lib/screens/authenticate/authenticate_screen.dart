import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../../components/password_field.dart';
import 'package:flutter_i18n/widgets/I18nText.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _registerMode = false;
  final _authService = AuthenticationService();
  String? _error;
  bool _loading = false;

  Future<void> _authenticateUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _error = null;
      _loading = true;
    });

    final result = _registerMode
        ? await _authService.registerWithEmailAndPassword(
            email: email, password: password, context: context)
        : await _authService.signInWithEmailAndPassword(
            email: email, password: password, context: context);

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
