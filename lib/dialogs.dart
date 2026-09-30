import 'package:flutter/material.dart';

import '../models/catalogue.dart';
import '../models/chips_ondulees.dart';
import '../models/gout.dart';
import '../models/produit.dart';
import '../models/promotable.dart';
import '../theme.dart';
import '../utils.dart';

/// Choix d'une remise (%) avec aperçu du prix. Retourne la remise choisie.
Future<double?> demanderRemise(
    BuildContext context, Produit produit, double remiseActuelle) {
  return showDialog<double>(
    context: context,
    builder: (_) =>
        _RemiseDialog(produit: produit, remiseInitiale: remiseActuelle),
  );
}

class _RemiseDialog extends StatefulWidget {
  final Produit produit;
  final double remiseInitiale;
  const _RemiseDialog({required this.produit, required this.remiseInitiale});

  @override
  State<_RemiseDialog> createState() => _RemiseDialogState();
}

class _RemiseDialogState extends State<_RemiseDialog> {
  late double _remise = widget.remiseInitiale;

  @override
  Widget build(BuildContext context) {
    final promotable = widget.produit as Promotable;
    final prixPromo = promotable.obtenirPrixPromo(_remise);
    return AlertDialog(
      title: const Text("Appliquer une promotion"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.produit.nom,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Center(
            child: Text(euros(prixPromo),
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: PetoteColors.promo)),
          ),
          Center(
              child: Text(
                  "au lieu de ${euros(widget.produit.prix)}  (-${_remise.toStringAsFixed(0)} %)")),
          Slider(
            value: _remise,
            min: 0,
            max: 50,
            divisions: 10,
            label: "${_remise.toStringAsFixed(0)} %",
            activeColor: PetoteColors.promo,
            onChanged: (v) => setState(() => _remise = v),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        FilledButton(
            onPressed: () => Navigator.pop(context, _remise),
            child: const Text("Appliquer")),
      ],
    );
  }
}

/// Saisie d'un nouveau prix. Retourne le prix saisi (strictement positif).
Future<double?> demanderPrix(BuildContext context, Produit produit) {
  final controller =
      TextEditingController(text: produit.prix.toStringAsFixed(2));
  final cle = GlobalKey<FormState>();
  return showDialog<double>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Modifier le prix"),
      content: Form(
        key: cle,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration:
              const InputDecoration(labelText: "Prix (€)", suffixText: "€"),
          validator: (v) {
            final prix = double.tryParse((v ?? "").replaceAll(',', '.'));
            if (prix == null || prix <= 0) {
              return "Le prix doit être strictement positif.";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler")),
        FilledButton(
          onPressed: () {
            if (cle.currentState!.validate()) {
              Navigator.pop(
                  context, double.parse(controller.text.replaceAll(',', '.')));
            }
          },
          child: const Text("Enregistrer"),
        ),
      ],
    ),
  );
}

/// Formulaire d'ajout d'une chips ondulée. Retourne le produit créé.
Future<ChipsOndulees?> demanderNouvelleChips(
    BuildContext context, Catalogue catalogue) {
  return showModalBottomSheet<ChipsOndulees>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _NouvelleChipsForm(catalogue: catalogue),
    ),
  );
}

class _NouvelleChipsForm extends StatefulWidget {
  final Catalogue catalogue;
  const _NouvelleChipsForm({required this.catalogue});

  @override
  State<_NouvelleChipsForm> createState() => _NouvelleChipsFormState();
}

class _NouvelleChipsFormState extends State<_NouvelleChipsForm> {
  final _cle = GlobalKey<FormState>();
  final _reference = TextEditingController(text: "PT-");
  final _nom = TextEditingController();
  final _poids = TextEditingController();
  final _prix = TextEditingController();
  final List<Gout> _gouts = [
    Gout.nature(),
    Gout.andouilletteMaroilles(),
    Gout.gauffreLilloise(),
    Gout.betiseCambrai(),
  ];
  int _goutIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Form(
        key: _cle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ajouter une chips ondulée",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: PetoteColors.ardoise)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reference,
              decoration:
                  const InputDecoration(labelText: "Référence (PT-xxx)"),
              validator: (v) {
                final ref = (v ?? "").trim();
                if (!RegExp(r'^PT-\d{3}$').hasMatch(ref)) {
                  return "Format attendu : PT-005";
                }
                if (widget.catalogue.contientReference(ref)) {
                  return "Cette référence existe déjà.";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nom,
              decoration: const InputDecoration(labelText: "Nom commercial"),
              validator: (v) =>
                  (v ?? "").trim().isEmpty ? "Le nom est obligatoire." : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _poids,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Poids net", suffixText: "g"),
                    validator: (v) {
                      final poids = int.tryParse((v ?? "").trim());
                      return (poids == null || poids <= 0)
                          ? "Poids invalide."
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _prix,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: "Prix", suffixText: "€"),
                    validator: (v) {
                      final prix =
                          double.tryParse((v ?? "").replaceAll(',', '.'));
                      return (prix == null || prix <= 0)
                          ? "Prix strictement positif."
                          : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _goutIndex,
              decoration: const InputDecoration(labelText: "Goût"),
              items: [
                for (var i = 0; i < _gouts.length; i++)
                  DropdownMenuItem(
                      value: i,
                      child: Text("${emojiPourGout(_gouts[i])}  ${_gouts[i]}")),
              ],
              onChanged: (v) => setState(() => _goutIndex = v ?? 0),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (!_cle.currentState!.validate()) return;
                  Navigator.pop(
                    context,
                    ChipsOndulees(
                      _reference.text.trim(),
                      _nom.text.trim(),
                      int.parse(_poids.text.trim()),
                      double.parse(_prix.text.replaceAll(',', '.')),
                      _gouts[_goutIndex],
                    ),
                  );
                },
                child: const Text("Ajouter au catalogue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
