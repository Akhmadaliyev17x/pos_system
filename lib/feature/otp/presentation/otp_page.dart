import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:milliyway_pos/core/router/route_names.dart';
import 'package:milliyway_pos/feature/home/widgets/timer.dart';

import '../widgets/otp_component.dart';

class OtpPage extends StatelessWidget {
  static const url = "/";

  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: const Alignment(0, -0.9),
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 700,
                      width: 700,
                      child: Image.asset("assets/images/logo.png" , fit: BoxFit.contain,),
                    ),
                  ),
                ),
                Expanded(
                  child: OtpComponent(
                    correctCode: "123456",
                    onSubmit: (a) {
                      if(a){
                        context.go(Routes.home);
                      }
                    },
                  ),
                ),
              ],
            ),
            const TimerWidget()
          ],
        ),
      ),
    );
  }
}
