import 'chips_ondulees.dart';
import 'produit.dart';

/// Regroupe l'ensemble des produits commercialisés par Pétote.
class Catalogue {
  List<Produit> _lesProduits = [];

  Catalogue() {
    _lesProduits = List<Produit>.empty(growable: true);
  }

  /// Lecture seule de la liste des produits.
  List<Produit> get lesProduits => List.unmodifiable(_lesProduits);

  void ajouterProduit(Produit produit) {
    _lesProduits.add(produit);
  }

  /// Retourne une nouvelle liste ne contenant que les chips ondulées.
  List<ChipsOndulees> donnerChipsOndulees() {
    List<ChipsOndulees> resultat = [];
    for (Produit produit in _lesProduits) {
      if (produit is ChipsOndulees) {
        resultat.add(produit);
      }
    }
    return resultat;
  }

  /// Somme des prix de tous les produits du catalogue.
  double valeurTotale() {
    double total = 0;
    for (Produit produit in _lesProduits) {
      total += produit.prix;
    }
    return total;
  }

  bool contientReference(String reference) =>
      _lesProduits.any((p) => p.reference == reference);
}
