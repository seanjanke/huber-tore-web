import 'dart:js' as js;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class ServiceReportWidget extends StatefulWidget {
  const ServiceReportWidget({
    super.key,
  });

  @override
  State<ServiceReportWidget> createState() => _ServiceReportWidgetState();
}

class _ServiceReportWidgetState extends State<ServiceReportWidget> {
  late Future<ListResult> futureFiles;

  List<String> serviceReports = [];
  List<String> foundServiceReports = [];

  Future getDocIDServiceReports() async {
    await FirebaseStorage.instance.ref('service reports').listAll().then(
      (snapshot) {
        for (var document in snapshot.items) {
          if (serviceReports.contains(document.name) == false) {
            serviceReports.add(document.name);
          }
        }
      },
    );
  }

  void downloadFile(String fileName) async {
    final url = await FirebaseStorage.instance
        .ref('service reports/$fileName')
        .getDownloadURL();
    js.context.callMethod('open', [url]);
  }

  void filterSearchServiceReports(String searchTermServiceReports) {
    List<String> searchResultServiceReports = [];
    if (searchTermServiceReports.isEmpty) {
      searchResultServiceReports = serviceReports;
    } else {
      searchResultServiceReports = serviceReports
          .where((serviceReport) => serviceReport.toLowerCase().contains(
                searchTermServiceReports.toLowerCase(),
              ))
          .toList();
    }

    setState(() {
      foundServiceReports = searchResultServiceReports;
    });
  }

  @override
  void initState() {
    foundServiceReports = serviceReports;
    futureFiles = FirebaseStorage.instance.ref('service reports').listAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: darkGreyColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Serviceberichte',
                  style: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 5.0,
                    right: 15.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 2,
                      color: lightGreyColor,
                    ),
                    color: lightGreyColor.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        color: lightGreyColor,
                        size: 20.0,
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextField(
                          onChanged: (searchTerm) =>
                              filterSearchServiceReports(searchTerm),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Suchen',
                            hintStyle: GoogleFonts.montserrat(
                              color: lightGreyColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 30.0,
            thickness: 1.5,
            color: lightGreyColor,
          ),
          Expanded(
            child: FutureBuilder(
                future: getDocIDServiceReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder<ListResult>(
                      future: futureFiles,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          final files = snapshot.data!.items;
                          return ListView.builder(
                            itemCount: foundServiceReports.length,
                            itemBuilder: (context, index) {
                              final foundServiceReport =
                                  foundServiceReports[index];
                              final fileIndex =
                                  serviceReports.indexOf(foundServiceReport);
                              final file = files[fileIndex];
                              return files.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          foundServiceReports[index],
                                          style: GoogleFonts.montserrat(
                                            color: whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.download,
                                            color: lightGreyColor,
                                          ),
                                          onPressed: () {
                                            downloadFile(file.name);
                                          },
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text(
                                        'Keine Dateien vorhanden',
                                        style: TextStyle(
                                          color: lightGreyColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Fehler beim Laden der Dateien',
                              style: TextStyle(
                                color: lightGreyColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                      },
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
    );
  }
}
