import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/user_service.dart';
import 'package:flutter_frontend/utils/Validator.dart';
import 'package:flutter_frontend/utils/fire_auth.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _productService = UserService();
  Map<String, dynamic> userData = {
    "UID": "",
    "Role": "user",
  };

  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _nameTextController,
              focusNode: _focusName,
              validator: (value) => Validator.validateName(
                name: value,
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: "Name",
                filled: true,
                fillColor: kPrimaryLightColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: _emailTextController,
                focusNode: _focusEmail,
                validator: (value) => Validator.validateEmail(
                  email: value,
                ),
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _passwordTextController,
              focusNode: _focusPassword,
              validator: (value) => Validator.validatePassword(
                password: value,
              ),
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                filled: true,
                fillColor: kPrimaryLightColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          _isProcessing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isProcessing = true;
                    });

                    if (_registerFormKey.currentState!.validate()) {
                      User? user;

                      user = await FireAuth.registerUsingEmailPassword(
                        name: _nameTextController.text,
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );
                      setState(() {
                        _isProcessing = false;
                      });
                      userData["UID"] = user?.uid;

                      _productService.setUserRole(userData);

                      if (user != null) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          ModalRoute.withName('/'),
                        );
                      }
                    }
                  },
                  child: Text("Sign Up".toUpperCase()),
                ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
