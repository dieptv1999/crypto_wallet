// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:crypto_wallet/resources/user_api_provider.dart';
import 'package:crypto_wallet/services/navigation_service.dart';
import 'package:crypto_wallet/ui/screen/profile_page.dart';
import 'package:crypto_wallet/ui/screen/sign_in.dart';
import 'package:crypto_wallet/util/constants.dart';
import 'package:flutter/material.dart';
// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _amplifyConfigured = false;
  final userRepository = UserApiProvider();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _configureAmplify() async {
    try {
      // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.addPlugin(
          AmplifyDataStore(modelProvider: ModelProvider.instance));

      // Once Plugins are added, configure Amplify
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Crypto Wallet',
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.light,
        accentColor: Colors.deepOrangeAccent,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: kPrimaryColor,
          fontFamily: 'Montserrat',
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const SignInPage(),
      // routes: <String, WidgetBuilder>{
      //   "signIn": (BuildContext context) => const SignInPage(),
      //   "profile": (BuildContext context) => const ProfileScreen(),
      // },
      // initialRoute: "signIn",
      // home: const SignInPage(),
    );
  }
}
