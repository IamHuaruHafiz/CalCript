import 'package:calcript/screens/auth/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Uri _url = Uri.parse(
    "https://docs.google.com/document/d/17FLOFduMCc71OObtXnOyu8xKoYYaAOcB/edit?usp=sharing&ouid=106533545059119776058&rtpof=true&sd=true",
  );
  Future<void> _lauchUrl() async {
    try {
      await launchUrl(_url);
    } catch (e) {
      debugPrint("Could not load $_url: $e");
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset("assets/images/pic.jpg")),
            const SizedBox(
              height: 18,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Get started",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text("Keep your privacy to yourself",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(children: [
              Checkbox(
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  hoverColor: Colors.blue,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }),
              Text(
                "By clicking, you agree with our ",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              InkWell(
                  onTap: _lauchUrl,
                  child: const Text(
                    " privacy policy",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ))
            ]),
            const SizedBox(
              height: 38,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    !isChecked
                        ? null
                        : Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      )),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
