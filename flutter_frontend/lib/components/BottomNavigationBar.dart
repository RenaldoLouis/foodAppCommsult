import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/riveUtils.dart';
import 'package:rive/rive.dart';

import '../components/AnimatedBar.dart';
import '../models/RiveAssets.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  @override
  State<BottomNavigationBarCustom> createState() =>
      _BottomNavigationbarCustomState();
}

class _BottomNavigationbarCustomState extends State<BottomNavigationBarCustom> {
  RiveAsset selectedBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(left: 24, right: 25, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            bottomNavs.length,
            (index) => GestureDetector(
              onTap: () {
                bottomNavs[index].input!.change(true);
                if (bottomNavs[index] != selectedBottomNav) {
                  setState(() {
                    selectedBottomNav = bottomNavs[index];
                  });
                }
                Future.delayed(Duration(seconds: 1), () {
                  bottomNavs[index].input!.change(false);
                });
                Navigator.pushReplacementNamed(
                    context, '/${bottomNavs[index].title}');
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(isActive: bottomNavs[index] == selectedBottomNav),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        bottomNavs.first.src,
                        artboard: bottomNavs[index].artboard,
                        onInit: (artboard) {
                          StateMachineController controller =
                              RiveUtils.getRiveController(artboard,
                                  stateMachineName:
                                      bottomNavs[index].stateMachineName);
                          bottomNavs[index].input =
                              controller.findSMI("active") as SMIBool;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
