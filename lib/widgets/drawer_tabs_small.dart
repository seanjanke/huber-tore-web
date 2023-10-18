import 'package:flutter/material.dart';
import 'package:tore_huber_web/widgets/constants.dart';

class DrawerTabSmall extends StatelessWidget {
  const DrawerTabSmall({
    super.key,
    required this.icon,
    required this.onPress,
    required this.isSelected,
  });

  final IconData icon;
  final VoidCallback onPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(20.0),
      onPressed: onPress,
      icon: Icon(
        icon,
        color: isSelected ? greenColor : lightGreyColor,
        size: 30.0,
      ),
    );
  }
}
