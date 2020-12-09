import 'dart:io';

import 'package:auth0_native/auth0_native.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({
    Key key,
    @required this.audience,
    @required this.scheme,
    @required this.connections,
    @required this.emailConnection,
    @required this.smsConnection,
    this.initialEmail,
    this.initialPhone,

  }) : super(key: key);

  final String audience;
  final String scheme;

  final List<String> connections;
  final String emailConnection;
  final String smsConnection;
  final String initialEmail;
  final String initialPhone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[

          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.orange,
            ),
            onPressed: () {
              Auth0Native().hasCredentials().then((value) {
                if (value) {
                  Auth0Native().logout(
                    scheme: scheme,

                  );
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onPressed: () {
              Auth0Native().hasCredentials().then((value) {
                if (value) {
                  Auth0Native().logout(
                    scheme: scheme,

                  );
                }
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Regular Web Login',
                style: Theme.of(context).textTheme.headline6,
              ),
              RaisedButton(
                child: Text('Login'),
                onPressed: _login,
              ),
              if (Platform.isIOS) ...[
                Divider(),
                RaisedButton(
                  child: Text('Sign in With Apple'),
                  onPressed: () {
                    Auth0Native().signInWithApple(
                      audience: audience,
                    );
                  },
                ),
              ],
              Divider(),
              Text(
                'Social',
                style: Theme.of(context).textTheme.headline6,
              ),
              Wrap(
                spacing: 5,
                children: connections.map((e) => _mapConnection(e)).toList(),
              ),

              Text(
                'Response',
                style: Theme.of(context).textTheme.headline6,
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: Auth0Native().observeCredentials,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Text('-');
                  } else {
                    final response = snapshot.data;
                    return Column(
                        children: response.keys.map((e) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                e,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                '${response[e]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .apply(fontFamily: 'monospace'),
                              ),
                              SizedBox(height: 8)
                            ],
                          );
                        }).toList());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapConnection(String name) {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('$name'),
        ],
      ),
      onPressed: () {
        _login(name);
      },
    );
  }
 /* void loginWithGoogle() async {
    try {
      var response = await auth.webAuth.authorize({
        AppStrings.keyAudience: AppStrings.valueAudience,
        AppStrings.keyConnection: AppStrings.valueGoogleAuth,
        AppStrings.keyScope: AppStrings.valueScope
      });
      String accessToken = response[AppStrings.keyAccessToken];
      AppHelper.addTokenToSF(accessToken);
      login(accessToken);
    } catch (e) {
      logger.e(e);
    }
  }*/

  void _login([String connection]) async {
    Auth0Native()
        .login(audience: audience, connection: connection, scheme: scheme)
        .catchError((e) {
      print('e: $e');
      return null;
    }).then((response) {
      // only print it as the credentials event stream will output the details.
      print('response: $response');
    });
  }
}
