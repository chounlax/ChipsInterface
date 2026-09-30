import 'package:flutter/material.dart';

import 'models/gout.dart';

/// Formate un montant en euros : 2.5 -> "2,50 €".
String euros(double montant) =>
    "${montant.toStringAsFixed(2).replaceAll('.', ',')} €";

/// Emoji associé à un goût.
String emojiPourGout(Gout gout) {
  switch (gout.nom) {
    case "Sel marin":
      return "🧂";
    case "Andouillette & Maroilles":
      return "🧀";
    case "Gauffre Lilloise":
      return "🧇";
    case "Bêtise de Cambrai":
      return "🍬";
    default:
      return "🥔";
  }
}

/// Couleur du sachet selon le goût.
Color couleurPourGout(Gout gout) {
  switch (gout.nom) {
    case "Sel marin":
      return const Color(0xFFF2B01E); // doré
    case "Andouillette & Maroilles":
      return const Color(0xFFD4432B); // rouge brique du Nord
    case "Gauffre Lilloise":
      return const Color(0xFFB8741F); // caramel
    case "Bêtise de Cambrai":
      return const Color(0xFF14A98A); // menthe
    default:
      return const Color(0xFF5B6CFF);
  }
}
