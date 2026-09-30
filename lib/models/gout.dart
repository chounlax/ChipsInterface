/// Classe Gout : caractérise le goût d'une chips.
/// L'attribut type vaut "salé" ou "sucré".
class Gout {
  String _nom = "";
  String _type = "";

  Gout(String nom, String type) {
    _nom = nom;
    _type = type;
  }

  String get nom => _nom;
  String get type => _type;
  void setNom(String nom) => _nom = nom;
  void setType(String type) => _type = type;

  bool get estSale => _type == "salé";
  bool get estSucre => _type == "sucré";

  // Goûts du catalogue (annexe 1)
  static Gout nature() => Gout("Sel marin", "salé");
  static Gout andouilletteMaroilles() =>
      Gout("Andouillette & Maroilles", "salé");
  static Gout gauffreLilloise() => Gout("Gauffre Lilloise", "salé");
  static Gout betiseCambrai() => Gout("Bêtise de Cambrai", "sucré");

  @override
  String toString() => "$_nom ($_type)";
}
