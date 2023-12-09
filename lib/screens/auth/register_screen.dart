import 'dart:convert';
import 'package:calcript/screens/auth/api_key.dart';
import 'package:calcript/screens/auth/confirm_otp_screen.dart';
import 'package:calcript/utilities/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _phoneController = TextEditingController();
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  String phoneNumber = "";

  sendRequest(String number) async {
    const String url = "https://sms.arkesel.com/api/otp/generate";
    final data = {
      "expiry": 3,
      "length": 6,
      "medium": "sms",
      "message":
          "This is OTP from CalCript, %otp_code%. Code expires in %expiry% minutes",
      "number": number,
      "sender_id": "CalCript",
      "type": "numeric",
    };

    try {
      isLoading = true;
      setState(() {});
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
          case 1005:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid phone number"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1000:
            isLoading = false;
            setState(() {});
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ConfirmOTPScreen(phoneNumber: phoneNumber),
              ),
            );
            break;
          case 1001:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("A validation error occurred"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1011:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("An internal error occurred"),
              duration: Duration(seconds: 1),
            ));
            break;
          case 1006:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Sorry, OTP not allowed in your country"),
              duration: Duration(seconds: 1),
            ));
            break;
          default:
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("An unknown error occurred"),
              duration: Duration(seconds: 1),
            ));
        }
      } else if (response.statusCode == 401) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Authentication failed!"),
          duration: Duration(seconds: 1),
        ));
      } else if (response.statusCode == 422) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter your mobile number"),
          duration: Duration(seconds: 1),
        ));
      } else if (response.statusCode == 500) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Internal error"),
          duration: Duration(seconds: 1),
        ));
      } else {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unknown"),
          duration: Duration(seconds: 1),
        ));
      }
    } catch (e) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your internet connection"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Phone verification",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(CupertinoIcons.back)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Enter your mobile number.An OTP code will be sent to you shortly.",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: IntlPhoneField(
                    onSubmitted: (_) {
                      sendRequest(phoneNumber);
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    dropdownIconPosition: IconPosition.trailing,
                    onCountryChanged: (Country countryCode) {
                      phoneNumber = countryCode.toString();
                    },
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? const CircularProgressIndicator(
                        color: bcolor,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            sendRequest(phoneNumber);
                            FocusScope.of(context).unfocus();
                          },
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Send",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
