import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String newEmployeeName = '';
  List<String> employees = [];
  List<String> foundEmployees = [];

  Future getDocIDEmployees() async {
    await FirebaseFirestore.instance.collection('users').get().then(
      (snapshot) {
        for (var document in snapshot.docs) {
          if (employees.contains(document.reference.id) == false) {
            employees.add(document.reference.id);
          }
        }
      },
    );
  }
  
  void filterSearchEmployees(String searchTermEmployees) {
    List<String> searchResultEmployees = [];
    if (searchTermEmployees.isEmpty) {
      searchResultEmployees = employees;
    } else {
      searchResultEmployees = employees
          .where((employees) => employees.toLowerCase().contains(
                searchTermEmployees.toLowerCase(),
              ))
          .toList();
    }

    setState(() {
      foundEmployees = searchResultEmployees;
    });
  }

  @override
  void initState() {
    foundEmployees = employees;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      child: Container(
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
                  flex: 3,
                  child: Text(
                    'Mitarbeiter',
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
                                filterSearchEmployees(searchTerm),
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
                future: getDocIDEmployees(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? ListView.builder(
                          itemCount: foundEmployees.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  foundEmployees[index],
                                  style: GoogleFonts.montserrat(
                                    color: whiteColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: lightGreyColor,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => SimpleDialog(
                                            contentPadding:
                                                const EdgeInsets.all(20.0),
                                            backgroundColor: darkGreyColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            children: [
                                              TextField(
                                                onChanged: (newValue) {
                                                  newEmployeeName = newValue;
                                                },
                                                style: GoogleFonts.montserrat(
                                                  color: whiteColor,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      foundEmployees[index],
                                                  hintStyle:
                                                      GoogleFonts.montserrat(
                                                    color: lightGreyColor,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  enabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: whiteColor),
                                                  ),
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: whiteColor),
                                                  ),
                                                ),
                                                cursorColor: whiteColor,
                                              ),
                                              const SizedBox(height: 10.0),
                                              GestureDetector(
                                                onTap: () {
                                                  if (newEmployeeName != '') {
                                                    //delete old document
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(foundEmployees[
                                                            index])
                                                        .delete();

                                                    setState(() {
                                                      foundEmployees.remove(
                                                          foundEmployees[
                                                              index]);
                                                    });

                                                    //create new document
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(newEmployeeName)
                                                        .set({
                                                      'name': newEmployeeName,
                                                      'id': newEmployeeName
                                                    });
                                                  }

                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    newEmployeeName = '';
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: greenColor,
                                                  ),
                                                  child: Text(
                                                    'Ändern',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: lightGreyColor,
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(foundEmployees[index])
                                            .delete();
                                        setState(() {
                                          foundEmployees.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: greenColor,
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeListTile2 extends StatelessWidget {
  const EmployeeListTile2({
    super.key,
    required this.employeeName,
  });

  final String employeeName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          employeeName,
          style: GoogleFonts.montserrat(
            color: whiteColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: lightGreyColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: lightGreyColor,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 20.0),
          ],
        ),
      ],
    );
  }
}
