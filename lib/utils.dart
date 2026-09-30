import 'models/gout.dart';

/// Formate un montant en euros : 2.5 -> "2,50 €".
String euros(double montant) =>
    "${montant.toStringAsFixed(2).replaceAll('.', ',')} €";

/// Emoji associé à un goût, pour illustrer les cartes.
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
