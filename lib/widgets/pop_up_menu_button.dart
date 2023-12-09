import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUpMenuButton extends StatelessWidget {
  const PopUpMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        iconSize: 25,
        iconColor: Colors.white,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/calculatorPage", (route) => false);
              },
              child: Text(
                "Return",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PopupMenuItem(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            "Warning",
                            style: GoogleFonts.inter(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to log out?",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(33, 38, 47, 1)),
                                onPressed: () async {
                                  try {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove("Number");
                                    await FirebaseAuth.instance.signOut();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(e.toString()),
                                      duration: const Duration(seconds: 2),
                                    ));
                                  }
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/calculatorPage", (route) => false);
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(33, 38, 47, 1)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        );
                      });
                },
                child: Text(
                  "Log out",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ];
        });
  }
}
