import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oz/firebase_options.dart';
import 'package:oz/pages/home_page.dart';
import 'package:oz/pages/splash_page.dart';
import 'package:oz/provider/google_provider.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:oz/provider/sign_in_provider.dart';
import 'package:oz/provider/sign_up_provider.dart';
import 'package:oz/provider/time_provider.dart';
import 'package:oz/provider/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:oz/pages/sign_up_page.dart';
// import 'package:oz/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때 로그아웃
      _auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => TimeProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SignUpProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SignInProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => TokenProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => OzcardProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => GoogleProvider()),
      ],
      child: MaterialApp(
        title: 'Oz',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashPage(),

        routes:{
          // '/': (context) => HomePage(),
          '/home': (context) => HomePage(),
        }
      ),
    );
  }
}
