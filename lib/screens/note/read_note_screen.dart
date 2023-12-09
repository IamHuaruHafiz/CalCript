import 'package:calcript/screens/note/add_note_screen.dart';
import 'package:calcript/screens/note/delete_note_screen.dart';
import 'package:calcript/screens/note/update_note_screen.dart';
import 'package:calcript/utilities/color.dart';
import 'package:calcript/widgets/pop_up_menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReadNoteScreen extends StatelessWidget {
  const ReadNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    final stream = FirebaseFirestore.instance
        .collection("note")
        .doc(user.uid)
        .collection("notes")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots();

    return PopScope(
      canPop: false,
      onPopInvoked: (b) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/calculatorPage",
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const Icon(
            Icons.event_note,
            color: Colors.white,
            size: 30,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: bcolor,
          title: Text(
            "Notes",
            style: GoogleFonts.inter(
              fontSize: 27,
              color: Colors.white,
            ),
          ),
          actions: const [
            PopUpMenuButton(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: bcolor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddNoteScreen()));
          },
          child: const Icon(
            Icons.edit,
            size: 30,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SizedBox();
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: bcolor,
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "You have no stored data\n Consider adding some notes",
                        style: GoogleFonts.inter(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>;
                      return Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 100,
                          decoration: BoxDecoration(
                              color: bcolor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10.0,
                                    offset: Offset(5, 5))
                              ]),
                          child: ListTile(
                            onTap: () {
                              String note = (data["content"]).toString();
                              String noteId = (data["id"]).toString();

                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return UpdateNoteScreen(
                                  docId: noteId,
                                  content: note,
                                );
                              }));
                            },
                            title: Text(
                              data["content"].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd()
                                  .format(DateTime.parse(data["createdAt"])),
                              style: GoogleFonts.inter(color: Colors.white60),
                            ),
                            trailing: PopupMenuButton(
                                iconColor: Colors.white,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () {
                                        String note =
                                            (data["content"]).toString();
                                        String noteId = (data["id"]).toString();

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UpdateNoteScreen(
                                            docId: noteId,
                                            content: note,
                                          );
                                        }));
                                      },
                                      value: "Edit",
                                      child: Text(
                                        "Edit",
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        String docId = (data["id"]).toString();

                                        showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DeleteNoteScreen(docId: docId));
                                      },
                                      value: "Delete",
                                      child: Text(
                                        "Delete",
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ];
                                }),
                          ));
                    }).toList(),
                  );
              }
            }),
      ),
    );
  }
}
