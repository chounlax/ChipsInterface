/// Classe abstraite Produit : classe de base du catalogue Pétote.
abstract class Produit {
  // attributs
  String _reference = "";
  String _nom = "";
  int _poids = 0; // en grammes
  double _prix = 0; // en euros

  // constructeur
  Produit(String reference, String nom, int poids, double prix) {
    _reference = reference;
    _nom = nom;
    _poids = poids;
    _prix = prix;
  }

  // accesseurs
  String get reference => _reference;
  String get nom => _nom;
  int get poids => _poids;
  double get prix => _prix;

  // mutateurs
  void setReference(String reference) => _reference = reference;
  void setNom(String nom) => _nom = nom;
  void setPoids(int poids) => _poids = poids;

  /// Mutateur du prix : la valeur n'est prise en compte
  /// que si elle est strictement positive.
  void setPrix(double prix) {
    if (prix > 0) {
      _prix = prix;
    }
  }

  /// Retourne le prix du produit au kilogramme.
  double calculerPrixAuKilo() {
    if (_poids <= 0) return 0;
    return _prix * 1000 / _poids;
  }

  /// Chaque produit fournit sa propre description.
  String describe();
}
