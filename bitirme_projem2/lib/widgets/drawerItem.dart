import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Function()? onTapRoute;
  final String name;
  final Icon icon;

  const DrawerItem({
    super.key,
    required this.name,
    required this.icon,
    this.onTapRoute,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapRoute,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 5,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
