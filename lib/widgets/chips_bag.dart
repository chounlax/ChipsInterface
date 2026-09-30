import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Sachet de chips dessiné en code : bords crantés et ondulations.
class ChipsBag extends StatelessWidget {
  final Color couleur;
  final String emoji;
  final int poids;
  final double hauteur;

  const ChipsBag({
    super.key,
    required this.couleur,
    required this.emoji,
    required this.poids,
    this.hauteur = 170,
  });

  @override
  Widget build(BuildContext context) {
    final h = hauteur;
    final texte =
        couleur.computeLuminance() > 0.5 ? PetoteColors.ardoise : Colors.white;
    return SizedBox(
      width: h * 0.78,
      height: h,
      child: CustomPaint(
        painter: _BagPainter(couleur),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.14, 0, h * 0.12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pétote",
                  style: TextStyle(
                      color: texte,
                      fontSize: h * 0.14,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.5)),
              SizedBox(height: h * 0.04),
              Container(
                width: h * 0.34,
                height: h * 0.34,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(emoji, style: TextStyle(fontSize: h * 0.18)),
              ),
              SizedBox(height: h * 0.05),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: h * 0.06, vertical: h * 0.015),
                decoration: BoxDecoration(
                  color: texte.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("$poids g",
                    style: TextStyle(
                        color: texte,
                        fontSize: h * 0.08,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BagPainter extends CustomPainter {
  final Color couleur;
  _BagPainter(this.couleur);

  Color _nuance(double delta) {
    final hsl = HSLColor.fromColor(couleur);
    return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final crimp = h * 0.075;
    final x0 = w * 0.04, x1 = w * 0.96;
    const dents = 12;
    final pas = (x1 - x0) / dents;

    final path = Path()..moveTo(x0, crimp);
    for (var i = 0; i < dents; i++) {
      path.lineTo(x0 + pas * i + pas / 2, 0);
      path.lineTo(x0 + pas * (i + 1), crimp);
    }
    path.quadraticBezierTo(w, h / 2, x1, h - crimp);
    for (var i = dents; i > 0; i--) {
      path.lineTo(x0 + pas * i - pas / 2, h);
      path.lineTo(x0 + pas * (i - 1), h - crimp);
    }
    path.quadraticBezierTo(0, h / 2, x0, crimp);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.5), 8, false);

    final fill = Paint()
      ..shader = LinearGradient(
        colors: [
          _nuance(-0.12),
          couleur,
          _nuance(0.10),
          couleur,
          _nuance(-0.14),
        ],
        stops: const [0, 0.25, 0.45, 0.75, 1],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(path, fill);

    // Ondulations sur le sachet
    canvas.save();
    canvas.clipPath(path);
    final onde = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white.withValues(alpha: 0.16);
    for (var k = 1; k <= 7; k++) {
      final y = h * (0.1 + k * 0.115);
      final p = Path()..moveTo(0, y);
      for (double x = 0; x <= w; x += 2) {
        p.lineTo(x, y + math.sin(x / w * math.pi * 6) * h * 0.012);
      }
      canvas.drawPath(p, onde);
    }
    // Bandes de scellage brillantes
    final bande = Paint()..color = Colors.white.withValues(alpha: 0.14);
    canvas.drawRect(Rect.fromLTWH(0, crimp, w, h * 0.02), bande);
    canvas.drawRect(Rect.fromLTWH(0, h - crimp - h * 0.02, w, h * 0.02), bande);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BagPainter old) => old.couleur != couleur;
}
