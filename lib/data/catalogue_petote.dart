import '../models/catalogue.dart';
import '../models/chips_ondulees.dart';
import '../models/gout.dart';

/// Construit le premier catalogue Pétote (annexe 1).
Catalogue construireCatalogue() {
  final catalogue = Catalogue();
  catalogue.ajouterProduit(
      ChipsOndulees("PT-001", "Ondulée nature", 125, 2.10, Gout.nature()));
  catalogue.ajouterProduit(ChipsOndulees("PT-002",
      "Ondulée Andouillette & Maroilles", 150, 2.50, Gout.andouilletteMaroilles()));
  catalogue.ajouterProduit(ChipsOndulees(
      "PT-003", "Ondulée gaufre Lilloise", 150, 2.50, Gout.gauffreLilloise()));
  catalogue.ajouterProduit(ChipsOndulees(
      "PT-004", "Ondulée Bêtise de Cambrai", 150, 2.40, Gout.betiseCambrai()));
  return catalogue;
}
