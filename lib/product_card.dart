import 'package:flutter/material.dart';

import '../models/chips_ondulees.dart';
import '../models/produit.dart';
import '../models/promotable.dart';
import '../theme.dart';
import '../utils.dart';

/// Carte d'un produit du catalogue.
class ProductCard extends StatelessWidget {
  final Produit produit;
  final double remise; // en %, 0 = pas de promotion
  final VoidCallback onPromo;
  final VoidCallback onModifierPrix;

  const ProductCard({
    super.key,
    required this.produit,
    required this.remise,
    required this.onPromo,
    required this.onModifierPrix,
  });

  @override
  Widget build(BuildContext context) {
    final p = produit;
    final chips = p is ChipsOndulees ? p : null;
    final promotable = p is Promotable ? p as Promotable : null;
    final enPromo = promotable != null && remise > 0;
    final prixFinal = enPromo ? promotable.obtenirPrixPromo(remise) : p.prix;
    final couleur = chips == null
        ? PetoteColors.ardoise
        : (chips.gout.estSucre ? PetoteColors.sucre : PetoteColors.sale);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PetoteColors.ardoise.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 84,
            width: double.infinity,
            color: couleur.withValues(alpha: 0.12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(chips == null ? "🥔" : emojiPourGout(chips.gout),
                    style: const TextStyle(fontSize: 44)),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Pastille(texte: p.reference, couleur: PetoteColors.ardoise),
                    if (chips != null) ...[
                      const SizedBox(height: 6),
                      _Pastille(texte: chips.gout.type, couleur: couleur),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.nom,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: PetoteColors.ardoise,
                        height: 1.2)),
                const SizedBox(height: 4),
                Text(
                  "${p.poids} g  ·  ${euros(p.calculerPrixAuKilo())} / kg",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.5,
                      color: PetoteColors.ardoise.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(euros(prixFinal),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: enPromo
                                ? PetoteColors.promo
                                : PetoteColors.ardoise)),
                    if (enPromo) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(euros(p.prix),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: PetoteColors.ardoise
                                    .withValues(alpha: 0.45))),
                      ),
                      const Spacer(),
                      _Pastille(
                          texte: "-${remise.toStringAsFixed(0)} %",
                          couleur: PetoteColors.promo),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onPromo,
                        icon: const Icon(Icons.local_offer_outlined, size: 18),
                        label: const Text("Promo"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onModifierPrix,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Prix"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pastille extends StatelessWidget {
  final String texte;
  final Color couleur;
  const _Pastille({required this.texte, required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texte,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
