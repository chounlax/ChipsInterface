import 'package:flutter/material.dart';

import '../theme.dart';

/// Bandeau d'en-tête au bord ondulé, clin d'œil aux chips ondulées.
class WaveHeader extends StatelessWidget {
  final Widget child;
  const WaveHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PetoteColors.ardoise, PetoteColors.marine],
          ),
        ),
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).padding.top + 28, 20, 60),
        child: child,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const creux = 22.0;
    final path = Path()..lineTo(0, size.height - creux);
    const ondes = 8;
    final largeur = size.width / ondes;
    for (var i = 0; i < ondes; i++) {
      final x = i * largeur;
      final haut = i.isEven;
      path.quadraticBezierTo(
        x + largeur / 2,
        haut ? size.height : size.height - creux * 2,
        x + largeur,
        size.height - creux,
      );
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
