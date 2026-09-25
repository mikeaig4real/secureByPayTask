import 'package:flutter/material.dart';

/// Vector rendition of the Nigerian national flag (1:2 aspect ratio).
class NigeriaFlagIcon extends StatelessWidget {
  final double width;
  final double height;

  const NigeriaFlagIcon({
    super.key,
    this.width = 16,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFD0D5DD), width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(child: Container(color: const Color(0xFF009A49))),
          Expanded(child: Container(color: Colors.white)),
          Expanded(child: Container(color: const Color(0xFF009A49))),
        ],
      ),
    );
  }
}
