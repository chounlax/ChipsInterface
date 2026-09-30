import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/chips_ondulees.dart';
import '../models/produit.dart';
import '../models/promotable.dart';
import '../theme.dart';
import '../utils.dart';
import 'chips_bag.dart';

/// Carte d'une référence du catalogue, avec son sachet illustré.
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
    final couleur =
        chips == null ? PetoteColors.ardoise : couleurPourGout(chips.gout);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: PetoteColors.ardoise.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Zone visuelle
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  couleur.withValues(alpha: 0.28),
                  couleur.withValues(alpha: 0.06),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 14,
                  left: 14,
                  child: chips == null
                      ? const SizedBox()
                      : _Pastille(
                          texte: chips.gout.type,
                          couleur: chips.gout.estSucre
                              ? PetoteColors.sucre
                              : PetoteColors.sale),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Text(p.reference,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: PetoteColors.ardoise.withValues(alpha: 0.55))),
                ),
                Transform.rotate(
                  angle: -math.pi / 40,
                  child: ChipsBag(
                    couleur: couleur,
                    emoji: chips == null ? "🥔" : emojiPourGout(chips.gout),
                    poids: p.poids,
                    hauteur: 165,
                  ),
                ),
                if (enPromo)
                  Positioned(
                    bottom: 14,
                    right: 14,
                    child: _Pastille(
                        texte: "-${remise.toStringAsFixed(0)} %",
                        couleur: PetoteColors.promo),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.nom,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: PetoteColors.ardoise,
                              height: 1.2)),
                      const SizedBox(height: 6),
                      Text(
                        chips == null
                            ? "${p.poids} g"
                            : "Goût ${chips.gout.nom}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: PetoteColors.ardoise.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(euros(prixFinal),
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: enPromo
                                  ? PetoteColors.promo
                                  : PetoteColors.ardoise)),
                      if (enPromo) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(euros(p.prix),
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: PetoteColors.ardoise
                                      .withValues(alpha: 0.4))),
                        ),
                      ],
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text("${euros(p.calculerPrixAuKilo())} / kg",
                            style: TextStyle(
                                fontSize: 12.5,
                                color: PetoteColors.ardoise
                                    .withValues(alpha: 0.55))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onPromo,
                          icon:
                              const Icon(Icons.local_offer_outlined, size: 18),
                          label: const Text("Promo"),
                        ),
                      ),
                      const SizedBox(width: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texte,
          style: const TextStyle(
              color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
    );
  }
}
