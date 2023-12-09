import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroduceSlider extends StatefulWidget {
  const IntroduceSlider({super.key});

  @override
  State<IntroduceSlider> createState() => _IntroduceSliderState();
}

class _IntroduceSliderState extends State<IntroduceSlider> {
  List<ContentConfig> listContentConfig = [];
  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      ContentConfig(
        styleTitle: const TextStyle(color: Colors.black),
        pathImage: "assets/images/calcus.jpg",
        widthImage: 400,
        heightImage: 400,
        description: "A simple calculator for your everyday calculations",
        styleDescription: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
      ),
    );
    listContentConfig.add(ContentConfig(
      styleTitle: const TextStyle(color: Colors.black),
      pathImage: "assets/images/vaul1.jpg",
      widthImage: 400,
      heightImage: 400,
      backgroundColor: Colors.white,
      styleDescription: GoogleFonts.inter(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      description: "A vault to secure your notes on the cloud",
    ));
    listContentConfig.add(ContentConfig(
      styleTitle: const TextStyle(color: Colors.black),
      pathImage: "assets/images/tap.jpg",
      widthImage: 400,
      heightImage: 400,
      backgroundColor: Colors.white,
      styleDescription: GoogleFonts.inter(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      description: "Double tap the (.) button to access your vault",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      isScrollable: true,
      isShowPrevBtn: true,
      isShowSkipBtn: false,
      doneButtonStyle: const ButtonStyle(
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      prevButtonStyle: const ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      nextButtonStyle: const ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      onDonePress: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("Newbie", "new");
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/calculatorPage",
          (route) => false,
        );
      },
    );
  }
}
