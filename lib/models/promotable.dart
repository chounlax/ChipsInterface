/// Interface Promotable : contrat des produits pouvant bénéficier
/// d'une promotion (remise exprimée en pourcentage).
abstract interface class Promotable {
  /// Retourne le prix après application de la remise (en %).
  double obtenirPrixPromo(double remise);
}
