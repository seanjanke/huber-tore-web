import 'dart:js' as js;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class ProtocolScreen extends StatefulWidget {
  const ProtocolScreen({super.key});

  @override
  State<ProtocolScreen> createState() => _ProtocolScreenState();
}

class _ProtocolScreenState extends State<ProtocolScreen> {
  late Future<ListResult> futureFiles;
  late Future<ListResult> futureFilesTueren;

  List<String> protocols = [];
  List<String> foundProtocols = [];
  List<String> tuerenProtocols = [];
  List<String> foundTuerenProtocols = [];

  Future getDocIDProtocols() async {
    await FirebaseStorage.instance.ref('protocols').listAll().then(
      (snapshot) {
        for (var document in snapshot.items) {
          if (protocols.contains(document.name) == false) {
            protocols.add(document.name);
          }
        }
      },
    );
  }

  Future getDocIDTuerenProtocols() async {
    await FirebaseStorage.instance.ref('protocols tueren').listAll().then(
      (snapshot) {
        for (var document in snapshot.items) {
          if (tuerenProtocols.contains(document.name) == false) {
            tuerenProtocols.add(document.name);
          }
        }
      },
    );
  }

  void downloadFile(String fileName) async {
    final url = await FirebaseStorage.instance
        .ref('protocols/$fileName')
        .getDownloadURL();
    js.context.callMethod('open', [url]);
  }

  void downloadFileTueren(String fileName) async {
    final url = await FirebaseStorage.instance
        .ref('protocols tueren/$fileName')
        .getDownloadURL();
    js.context.callMethod('open', [url]);
  }

  void filterSearchProtocols(String searchTermProtocols) {
    List<String> searchResultProtocols = [];
    if (searchTermProtocols.isEmpty) {
      searchResultProtocols = protocols;
    } else {
      searchResultProtocols = protocols
          .where((protocols) => protocols.toLowerCase().contains(
                searchTermProtocols.toLowerCase(),
              ))
          .toList();
    }

    setState(() {
      foundProtocols = searchResultProtocols;
    });
  }

  void filterSearchTuerenProtocols(String searchTermTuerenProtocols) {
    List<String> searchResultTuerenProtocols = [];
    if (searchTermTuerenProtocols.isEmpty) {
      searchResultTuerenProtocols = tuerenProtocols;
    } else {
      searchResultTuerenProtocols = tuerenProtocols
          .where((tuerenProtocols) => tuerenProtocols.toLowerCase().contains(
                searchTermTuerenProtocols.toLowerCase(),
              ))
          .toList();
    }

    setState(() {
      foundTuerenProtocols = searchResultTuerenProtocols;
    });
  }

  @override
  void initState() {
    foundProtocols = protocols;
    futureFiles = FirebaseStorage.instance.ref('protocols').listAll();
    foundTuerenProtocols = tuerenProtocols;
    futureFilesTueren =
        FirebaseStorage.instance.ref('protocols tueren').listAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.4,
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
                      flex: 3,
                      child: Text(
                        'Tor-Protokolle',
                        style: GoogleFonts.montserrat(
                          color: whiteColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
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
                                    filterSearchProtocols(searchTerm),
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
                      future: getDocIDProtocols(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FutureBuilder<ListResult>(
                            future: futureFiles,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                final files = snapshot.data!.items;
                                return ListView.builder(
                                  itemCount: foundProtocols.length,
                                  itemBuilder: (context, index) {
                                    final foundProtocol = foundProtocols[index];
                                    final fileIndex =
                                        protocols.indexOf(foundProtocol);
                                    final file = files[fileIndex];
                                    return files.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                foundProtocols[index],
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
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.4,
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
                      flex: 3,
                      child: Text(
                        'Türen-Protokolle',
                        style: GoogleFonts.montserrat(
                          color: whiteColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
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
                                    filterSearchTuerenProtocols(searchTerm),
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
                      future: getDocIDTuerenProtocols(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FutureBuilder<ListResult>(
                            future: futureFilesTueren,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                final files = snapshot.data!.items;
                                return ListView.builder(
                                  itemCount: foundTuerenProtocols.length,
                                  itemBuilder: (context, index) {
                                    final foundTuerenProtocol =
                                        foundTuerenProtocols[index];
                                    final fileIndex = tuerenProtocols
                                        .indexOf(foundTuerenProtocol);
                                    final file = files[fileIndex];
                                    return files.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                foundTuerenProtocols[index],
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
                                                  downloadFileTueren(file.name);
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
          ),
        ],
      ),
    );
  }
}
