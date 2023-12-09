import 'package:calcript/firebase_options.dart';
import 'package:calcript/providers/notes.dart';
import 'package:calcript/screens/auth/register_screen.dart';
import 'package:calcript/screens/auth/welcome_screen.dart';
import 'package:calcript/screens/calculator/calculator.dart';
import 'package:calcript/screens/note/add_note_screen.dart';
import 'package:calcript/screens/note/read_note_screen.dart';
import 'package:calcript/utilities/intro_slider.dart';
import 'package:calcript/utilities/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await SharedPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final newBie = SharedPrefs.instance.getString("Newbie");

    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CalCript',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          "/welcomePage": (context) => const WelcomePage(),
          "/registerPage": (context) => const RegisterScreen(),
          "/calculatorPage": (context) => const Calculator(),
          "/notePage": (context) => const ReadNoteScreen(),
          "/addNotePage": (context) => const AddNoteScreen(),
        },
        home: newBie == null ? const IntroduceSlider() : const Calculator(),
      ),
    );
  }
}
