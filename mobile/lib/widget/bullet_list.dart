import 'package:flutter/material.dart';
import 'package:mobile/constant.dart';

class BulletList extends StatelessWidget {
  const BulletList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children.map((child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("\u2022"),
            const SizedBox(width: Constant.space2),
            Expanded(child: child),
          ],
        );
      }).toList(),
    );
  }
}
