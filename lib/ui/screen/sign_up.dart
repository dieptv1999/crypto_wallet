import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:crypto_wallet/services/camera_service.dart';
import 'package:crypto_wallet/services/web3_service.dart';
import 'package:crypto_wallet/ui/screen/camera_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CameraService cameraService = CameraService();
  Web3Service web3Service = Web3Service();
  PageController controller = PageController();
  String hashImage = '';
  bool isSignUpComplete = false;

  Future<void> signUp() async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: 'email@domain.com',
        CognitoUserAttributeKey.phoneNumber: '+15559101234',
        // additional attributes as needed
      };
      final result = await Amplify.Auth.signUp(
        username: 'myusername',
        password: 'mysupersecurepassword',
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      setState(() {
        isSignUpComplete = result.isSignUpComplete;
      });
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme
          .of(context)
          .backgroundColor,
      child: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FutureBuilder<CameraDescription>(
              future: cameraService.takePhoto(), // async work
              builder: (BuildContext context,
                  AsyncSnapshot<CameraDescription> snapshot) {
                if (snapshot.hasData) {
                  return TakePictureScreen(
                    camera: snapshot.data!,
                    next: (XFile image) async {
                      String hash = await cameraService
                          .hashImage(await image.readAsBytes());
                      setState(() {
                        hashImage = hash;
                      });
                      controller.animateToPage((controller.page?.round() ?? 0) +
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            SafeArea(
              child: ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  signUp();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}