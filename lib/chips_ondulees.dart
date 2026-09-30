import 'gout.dart';
import 'produit.dart';
import 'promotable.dart';

/// Une chips ondulée du catalogue Pétote.
/// Hérite de Produit et implémente Promotable.
class ChipsOndulees extends Produit implements Promotable {
  Gout _unGout;

  ChipsOndulees(
      String reference, String nom, int poids, double prix, Gout gout)
      : _unGout = gout,
        super(reference, nom, poids, prix);

  Gout get gout => _unGout;
  void setGout(Gout gout) => _unGout = gout;

  @override
  String describe() {
    return "$reference - $nom - $poids g - "
        "${prix.toStringAsFixed(2)} € - Goût : ${_unGout.nom} (${_unGout.type})";
  }

  @override
  double obtenirPrixPromo(double remise) {
    return prix - (prix * remise / 100);
  }
}
