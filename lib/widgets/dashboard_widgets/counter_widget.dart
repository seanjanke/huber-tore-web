import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: darkGreyColor,
      ),
      child: MediaQuery.of(context).size.height > 600
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('service reports')
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List serviceReportsDocCount = snapshot.data!.docs;
                          var serviceReportsCount =
                              serviceReportsDocCount.length.toString();
                          return Text(
                            serviceReportsCount.toString(),
                            style: GoogleFonts.montserrat(
                              color: greenColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Serviceberichte',
                      style: GoogleFonts.montserrat(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('protocols')
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List protocolsDocCount = snapshot.data!.docs;
                          var protocolsCount =
                              protocolsDocCount.length.toString();
                          return Text(
                            protocolsCount.toString(),
                            style: GoogleFonts.montserrat(
                              color: greenColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Protokolle',
                      style: GoogleFonts.montserrat(
                        color: whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Serviceberichte:',
                      style: GoogleFonts.montserrat(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('service reports')
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List serviceReportsDocCount = snapshot.data!.docs;
                          var serviceReportsCount =
                              serviceReportsDocCount.length.toString();
                          return Text(
                            serviceReportsCount.toString(),
                            style: GoogleFonts.montserrat(
                              color: greenColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Protokolle:',
                      style: GoogleFonts.montserrat(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('protocols')
                          .get(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          List protocolsDocCount = snapshot.data!.docs;
                          var protocolsCount =
                              protocolsDocCount.length.toString();
                          return Text(
                            protocolsCount.toString(),
                            style: GoogleFonts.montserrat(
                              color: greenColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
