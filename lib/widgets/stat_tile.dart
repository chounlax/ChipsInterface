import 'package:flutter/material.dart';

import '../theme.dart';

/// Petit indicateur de l'en-tête (valeur + libellé).
class StatTile extends StatelessWidget {
  final String valeur;
  final String libelle;
  const StatTile({super.key, required this.valeur, required this.libelle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(valeur,
              style: const TextStyle(
                  color: PetoteColors.jaune,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(libelle,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
        ],
      ),
    );
  }
}
