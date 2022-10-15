import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import '../providers/auth.dart';

enum AuthMode {
  singUp,
  login,
}

class AutenticatorCard extends StatefulWidget {
  // const AutenticatorCard({super.key});

  @override
  State<AutenticatorCard> createState() => _AutenticatorCardState();
}

class _AutenticatorCardState extends State<AutenticatorCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final _passWordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _Submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.login) {
        await auth.login(_authData['email'], _authData['password']);
      } else {
        await auth.signup(_authData['email'], _authData['password']);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro Inesperado');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _SwitchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.singUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _authMode == AuthMode.login ? 310 : 390,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um E-mail válido';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              // if(_authMode == AuthMode.singUp)
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                controller: _passWordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Senha tem que conter no minimo 5 caracters';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.singUp)
                TextFormField(
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: 'Confirmação de senha'),
                  validator: _authMode == AuthMode.singUp
                      ? (value) {
                          if (value != _passWordController.text) {
                            return 'Senhas não são iguais';
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  child:
                      Text(_authMode == AuthMode.login ? 'LOGIN' : 'REGISTRAR',
                          style: TextStyle(
                            fontSize: 15,
                          )),
                  onPressed: _Submit,
                ),
              FlatButton(
                child: Text(
                    _authMode == AuthMode.login
                        ? 'Registrar conta'
                        : 'Entrar em uma conta',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                onPressed: _SwitchAuthMode,
              )
            ],
          ),
        ),
      ),
    );
  }
}
