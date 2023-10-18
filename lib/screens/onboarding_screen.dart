import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/main.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  List docIDsProtocol = [];

  Future getDocIDProtocols() async {
    await FirebaseFirestore.instance.collection('protocols').get().then(
      (snapshot) {
        for (var document in snapshot.docs) {
          docIDsProtocol.add(document.reference.id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Huber Tore',
      color: Colors.red,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: darkGreyColor,
          body: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: 300.0,
                  height: 300.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Name eingeben',
                      hintStyle: GoogleFonts.montserrat(
                        color: lightGreyColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Passwort eingeben',
                            hintStyle: GoogleFonts.montserrat(
                              color: lightGreyColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Colors.white,
                          obscureText: isObscure,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: lightGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    if (nameController.text == 'admin' &&
                        passwordController.text == 'AdminPanelHuberTore') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                      );
                    } else {
                      showErrorMessage(context);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        colors: [greenColor, Color.fromARGB(255, 19, 165, 41)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showErrorMessage(context) async {
  await Flushbar(
    title: 'Falsches Login-Informationen',
    message: 'Versuche es erneut mit den richtigen Angaben',
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(10),
    backgroundColor: Colors.red.shade400,
    icon: const Icon(
      Icons.error_outline_outlined,
      size: 28.0,
      color: Colors.white,
    ),
  ).show(context);
}
