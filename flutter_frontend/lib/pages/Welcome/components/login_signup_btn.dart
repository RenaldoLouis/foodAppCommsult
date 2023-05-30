import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';
import 'package:flutter_frontend/components/RoundedButton.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: 50,
          child: RoundedButton(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            text: "Login",
            textColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: size.width,
          height: 50,
          child: RoundedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
            backgroundColor: kPrimaryLightColor,
            text: "Sign up",
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
