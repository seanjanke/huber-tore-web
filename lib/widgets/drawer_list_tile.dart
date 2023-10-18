import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.isSelected,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      horizontalTitleGap: 0.0,
      tileColor: isSelected ? greenColor.withOpacity(0.2) : null,
      leading: Icon(
        icon,
        color: isSelected ? greenColor : lightGreyColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: isSelected ? greenColor : lightGreyColor,
        ),
      ),
    );
  }
}
