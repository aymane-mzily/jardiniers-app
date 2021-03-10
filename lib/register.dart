import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'utils/validator.dart';
import 'package:http/http.dart' as http;
import './widgets/loading_screen.dart';
import './utils/constants.dart';

class Register extends StatefulWidget {
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              'assets/images/default.png',
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );

    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Prénom',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
      validator: Validator.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Nom',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Mot de pass',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailSignUp(
              firstName: _firstName.text,
              lastName: _lastName.text,
              email: _email.text,
              password: _password.text,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text("S'INSCRIRE", style: TextStyle(color: Colors.white)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        "Avoir un compte? S'identifier.",
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidateMode: (_autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      lastName,
                      SizedBox(height: 24.0),
                      firstName,
                      SizedBox(height: 24.0),
                      email,
                      SizedBox(height: 24.0),
                      password,
                      SizedBox(height: 12.0),
                      signUpButton,
                      signInLabel
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible(bool visibile) async {
    setState(() {
      _loadingVisible = visibile;
    });
  }

  void _emailSignUp(
      {String firstName,
      String lastName,
      String email,
      String password,
      BuildContext context}) async {
    if (_formKey.currentState.validate()) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _changeLoadingVisible(true);
        final response = await http.post(
        Uri.http(baseApiURL, loginEndpoint),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'password': password,
          },
        );
        if (response.statusCode == 200) {
          _changeLoadingVisible(false);
          await Navigator.pushNamed(context, '/login');
        } else {
          _changeLoadingVisible(false);
          Flushbar(
            title: "Erreur",
            message: "Erreur de création de compte",
            duration: Duration(seconds: 5),
          )..show(context);
        }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}