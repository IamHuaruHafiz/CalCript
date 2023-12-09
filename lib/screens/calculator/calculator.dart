import 'package:calcript/screens/auth/welcome_screen.dart';
import 'package:calcript/screens/note/read_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        equation = "0";
        result = "0";
      } else if (buttonText == "Z") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        expression = equation;
        expression = expression.replaceAll("x", "*");
        expression = expression.replaceAll("÷", "/");

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = "${exp.evaluate(EvaluationType.REAL, cm)}";
        } catch (e) {
          result = "invalid";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(
    String buttonText,
    double buttonHeight,
    Color buttonColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => buttonPressed(buttonText),
      child: Container(
        margin: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: buttonColor,
            border: Border.all(color: Colors.white)),
        height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 38, 47, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                equation,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.white, fontSize: equationFontSize),
              )),
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Text(
                result,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(color: Colors.white, fontSize: resultFontSize),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton(
                          "C",
                          1,
                          const Color.fromRGBO(255, 155, 15, 1),
                        ),
                        buildButton(
                            "Z", 1, const Color.fromRGBO(255, 155, 15, 1)),
                        buildButton(
                            "÷", 1, const Color.fromRGBO(255, 155, 15, 1)),
                      ]),
                      TableRow(children: [
                        buildButton("7", 1, Colors.white12),
                        buildButton("8", 1, Colors.white12),
                        buildButton("9", 1, Colors.white12),
                      ]),
                      TableRow(children: [
                        buildButton("4", 1, Colors.white12),
                        buildButton("5", 1, Colors.white12),
                        buildButton("6", 1, Colors.white12),
                      ]),
                      TableRow(children: [
                        buildButton("1", 1, Colors.white12),
                        buildButton("2", 1, Colors.white12),
                        buildButton("3", 1, Colors.white12),
                      ]),
                      TableRow(children: [
                        InkWell(
                            onDoubleTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var number = prefs.getString("Number");
                              number == null
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WelcomePage()))
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ReadNoteScreen()));
                            },
                            child: buildButton(".", 1, Colors.white12)),
                        buildButton("0", 1, Colors.white12),
                        buildButton("00", 1, Colors.white12),
                      ])
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(
                    children: [
                      TableRow(children: [
                        buildButton(
                            "x", 1, const Color.fromRGBO(255, 155, 15, 1)),
                      ]),
                      TableRow(children: [
                        buildButton(
                            "-", 1, const Color.fromRGBO(255, 155, 15, 1)),
                      ]),
                      TableRow(children: [
                        buildButton(
                            "+", 1, const Color.fromRGBO(255, 155, 15, 1)),
                      ]),
                      TableRow(children: [
                        buildButton(
                          "=",
                          2,
                          const Color.fromRGBO(255, 155, 15, 1),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
