import 'dart:convert';
import 'package:calcript/screens/auth/api_key.dart';
import 'package:calcript/utilities/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmOTPScreen extends StatefulWidget {
  final String phoneNumber;
  const ConfirmOTPScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<ConfirmOTPScreen> createState() => _ConfirmOTPScreenState();
}

class _ConfirmOTPScreenState extends State<ConfirmOTPScreen> {
  TextEditingController _otpController1 = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _otpController3 = TextEditingController();
  TextEditingController _otpController4 = TextEditingController();
  TextEditingController _otpController5 = TextEditingController();
  TextEditingController _otpController6 = TextEditingController();

  @override
  void initState() {
    _otpController1 = TextEditingController();
    _otpController2 = TextEditingController();
    _otpController3 = TextEditingController();
    _otpController4 = TextEditingController();
    _otpController5 = TextEditingController();
    _otpController6 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _otpController5.dispose();
    _otpController6.dispose();
    super.dispose();
  }

  bool isLoading = false;
  Future verifyCode(String code, String number) async {
    const String url = "https://sms.arkesel.com/api/otp/verify";
    try {
      isLoading = true;
      setState(() {});
      final data = {
        "code": code,
        "number": number,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "api-key": ApiKey.secretKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        switch (int.parse(responseData["code"])) {
          case 1100:
            try {
              await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email:
                          "user${widget.phoneNumber.substring(1, widget.phoneNumber.length)}@gmail.com",
                      password: widget.phoneNumber)
                  .then((_) async {
                isLoading = false;
                setState(() {});
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/notePage", (route) => false);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("Number", widget.phoneNumber);
              });
            } on FirebaseAuthException catch (e) {
              if (e.code == "email-already-in-use") {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email:
                            "user${widget.phoneNumber.substring(1, widget.phoneNumber.length)}@gmail.com",
                        password: widget.phoneNumber)
                    .then((_) async {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/notePage", (route) => false);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("Number", widget.phoneNumber);
                });
              } else {
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Authentication error"),
                  duration: Duration(seconds: 1),
                ));
              }
            }
            break;
          case 1102:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid phone number"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1103:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid phone number"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1104:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Code incorrect!"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1105:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Code has expired"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1106:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("An internal error occured"),
              duration: Duration(seconds: 1),
            ));
            break;
          default:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Unknown error"),
              duration: Duration(seconds: 1),
            ));
            break;
        }
      } else if (response.statusCode == 422) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Code field required"),
          duration: Duration(seconds: 1),
        ));
      } else if (response.statusCode == 500) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An internal error occured"),
          duration: Duration(seconds: 1),
        ));
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            "OTP verification",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          leading: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 18),
                    children: [
                  const TextSpan(text: "An OTP code was sent to "),
                  TextSpan(
                      text: "${widget.phoneNumber}\n",
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black54)),
                  const TextSpan(text: "Enter code below"),
                ])),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                otpBox(
                  _otpController1,
                  first: true,
                  last: false,
                ),
                otpBox(
                  _otpController2,
                  first: false,
                  last: false,
                ),
                otpBox(
                  _otpController3,
                  first: false,
                  last: false,
                ),
                otpBox(
                  _otpController4,
                  first: false,
                  last: false,
                ),
                otpBox(
                  _otpController5,
                  first: false,
                  last: false,
                ),
                otpBox(_otpController6, first: false, last: true),
              ],
            ),
            isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: bcolor,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        verifyCode(
                            _otpController1.text +
                                _otpController2.text +
                                _otpController3.text +
                                _otpController4.text +
                                _otpController5.text +
                                _otpController6.text,
                            widget.phoneNumber);
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text("Verify"),
                    ),
                  )
          ]),
        ));
  }

  otpBox(TextEditingController controller, {required bool first, last}) {
    return SizedBox(
      height: 85,
      child: AspectRatio(
        aspectRatio: 0.6,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (val) {
            if (val.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            } else if (val.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          onSubmitted: (_) {
            verifyCode(
                _otpController1.text +
                    _otpController2.text +
                    _otpController3.text +
                    _otpController4.text +
                    _otpController5.text +
                    _otpController6.text,
                widget.phoneNumber);
            print(
              _otpController1.text +
                  _otpController2.text +
                  _otpController3.text +
                  _otpController4.text +
                  _otpController5.text +
                  _otpController6.text,
            );
          },
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              hintText: "0",
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Colors.black12,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.blue))),
        ),
      ),
    );
  }
}
