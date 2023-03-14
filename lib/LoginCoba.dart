import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class LoginCoba extends StatefulWidget {
  @override
  _LoginCobaState createState() => _LoginCobaState();
}

class _LoginCobaState extends State<LoginCoba> {
  bool _isBusy = false;
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  String? _codeVerifier;
  String? _authorizationCode;
  String? _refreshToken;
  String? _accessToken;
  String? _idToken;

  final TextEditingController _authorizationCodeTextController =
  TextEditingController();
  final TextEditingController _accessTokenTextController =
  TextEditingController();
  final TextEditingController _accessTokenExpirationTextController =
  TextEditingController();

  final TextEditingController _idTokenTextController = TextEditingController();
  final TextEditingController _refreshTokenTextController =
  TextEditingController();
  String? _userInfo;

  final String _clientId = 'flutter';
  // final String _redirectUrl = 'https://corla.krakatautirta.co.id/';
  final String _redirectUrl = 'http://localhost:3000/';
//  final String _redirectUrl = 'http://localhost:6328/';
  final String _issuer = 'https://192.168.0.27:8443/auth/realms/kti';
  final String _discoveryUrl = 'https://192.168.0.27:8443/auth/realms/kti/protocol/openid-connect/auth';
  final String _postLogoutRedirectUrl = 'http://localhost:63287/*';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'offline_access',
    'email',
    'name'
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration =
  const AuthorizationServiceConfiguration(
    authorizationEndpoint: 'https://192.168.0.27:8443/auth/realms/kti/protocol/openid-connect/auth',
    tokenEndpoint: 'https://192.168.0.27:8443/auth/realms/kti/protocol/openid-connect/token',
    endSessionEndpoint: 'https://192.168.0.27:8443/auth/realms/kti/protocol/openid-connect/logout',
  );

  Future<void> _endSession() async {
    try {
      _setBusyState();
      await _appAuth.endSession(EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: _postLogoutRedirectUrl,
          serviceConfiguration: _serviceConfiguration));
      _clearSessionInfo();
    } catch (_) {}
    _clearBusyState();
  }

  void _clearSessionInfo() {
    setState(() {
      _codeVerifier = null;
      _authorizationCode = null;
      _authorizationCodeTextController.clear();
      _accessToken = null;
      _accessTokenTextController.clear();
      _idToken = null;
      _idTokenTextController.clear();
      _refreshToken = null;
      _refreshTokenTextController.clear();
      _accessTokenExpirationTextController.clear();
      _userInfo = null;
    });
  }

  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      print("Sign in with Auto code exchange");

      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: _scopes,
          preferEphemeralSession: preferEphemeralSession,
          allowInsecureConnections: true,
        ),
      );

      print("Result : $result");
      if (result != null) {
        _processAuthTokenResponse(result);
        //await _testApi(result);
      }
    } catch (e) {
      print("Error occured: $e");
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    setState(() {
      print(response);
      _accessToken = _accessTokenTextController.text = response.accessToken!;
      _idToken = _idTokenTextController.text = response.idToken!;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken!;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime!.toIso8601String();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: _isBusy,
                child: const LinearProgressIndicator(),
            ),
            const Text('Langsung masuk kehalaman webview'),
            const Text('yang tertuju diredirect url'),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () => _signInWithAutoCodeExchange(),
            ),
            if (Platform.isIOS)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  child: const Text(
                    'Sign in with auto code exchange using ephemeral session (iOS only)',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => _signInWithAutoCodeExchange(
                      preferEphemeralSession: true),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
