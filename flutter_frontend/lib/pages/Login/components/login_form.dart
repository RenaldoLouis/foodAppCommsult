import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/ContainerApp.dart';
import 'package:flutter_frontend/utils/Validator.dart';
import 'package:flutter_frontend/utils/fire_auth.dart';
import 'dart:developer' as logger;

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ContainerApp(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  bool _isProcessing = true;

  bool _errorLogin = false;

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => _errorLogin
                          ? "Invalid Email / password"
                          : Validator.validateEmail(
                              email: value,
                            ),
                      onTap: () {
                        _errorLogin = false;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (email) {},
                      decoration: InputDecoration(
                        hintText: "Your email",
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        validator: (value) => _errorLogin
                            ? "Invalid Email / password"
                            : Validator.validatePassword(
                                password: value,
                              ),
                        onTap: () {
                          _errorLogin = false;
                        },
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          hintText: "Your password",
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: kPrimaryLightColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  _isProcessing
                      ? CircularProgressIndicator()
                      : Hero(
                          tag: "login_btn",
                          child: ElevatedButton(
                            onPressed: () async {
                              _focusEmail.unfocus();
                              _focusPassword.unfocus();

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });
                                User? user;
                                user = await FireAuth.signInUsingEmailPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );
                                setState(() {
                                  _isProcessing = false;
                                });

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ContainerApp(user: user),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _errorLogin = true;
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Login".toUpperCase(),
                            ),
                          ),
                        ),
                  const SizedBox(height: defaultPadding),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
