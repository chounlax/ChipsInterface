import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/catalogue_petote.dart';
import '../models/catalogue.dart';
import '../models/produit.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/chips_bag.dart';
import '../widgets/dialogs.dart';
import '../widgets/product_card.dart';
import '../widgets/stat_tile.dart';
import '../widgets/wave_header.dart';

enum Filtre { tous, sale, sucre }

const double _largeurMax = 1200;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Catalogue _catalogue = construireCatalogue();
  final Map<String, double> _promos = {}; // référence -> remise (%)
  Filtre _filtre = Filtre.tous;
  String _recherche = "";

  List<Produit> get _produitsAffiches {
    Iterable<Produit> liste = _catalogue.lesProduits;
    if (_filtre != Filtre.tous) {
      final type = _filtre == Filtre.sale ? "salé" : "sucré";
      liste =
          _catalogue.donnerChipsOndulees().where((c) => c.gout.type == type);
    }
    final q = _recherche.trim().toLowerCase();
    if (q.isNotEmpty) {
      liste = liste.where((p) =>
          p.nom.toLowerCase().contains(q) ||
          p.reference.toLowerCase().contains(q));
    }
    return liste.toList();
  }

  void _message(String texte) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(texte),
        behavior: SnackBarBehavior.floating,
      ));
  }

  Future<void> _promo(Produit p) async {
    final remise = await demanderRemise(context, p, _promos[p.reference] ?? 0);
    if (remise == null) return;
    setState(() {
      if (remise == 0) {
        _promos.remove(p.reference);
      } else {
        _promos[p.reference] = remise;
      }
    });
    _message(remise == 0
        ? "Promotion retirée pour ${p.reference}."
        : "Promotion de ${remise.toStringAsFixed(0)} % appliquée à ${p.reference}.");
  }

  Future<void> _modifierPrix(Produit p) async {
    final prix = await demanderPrix(context, p);
    if (prix == null) return;
    setState(() => p.setPrix(prix));
    _message("Prix de ${p.reference} mis à jour.");
  }

  Future<void> _ajouter() async {
    final chips = await demanderNouvelleChips(context, _catalogue);
    if (chips == null) return;
    setState(() => _catalogue.ajouterProduit(chips));
    _message("${chips.nom} ajoutée au catalogue.");
  }

  Widget _centre(Widget enfant) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _largeurMax),
          child: enfant,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final produits = _produitsAffiches;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouter,
        backgroundColor: PetoteColors.jaune,
        foregroundColor: PetoteColors.ardoise,
        icon: const Icon(Icons.add),
        label: const Text("Nouvelle chips",
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _entete()),
          SliverToBoxAdapter(child: _centre(_barreOutils())),
          if (produits.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ChipsBag(
                          couleur: Color(0xFF9AA5B8), emoji: "🔍", poids: 0, hauteur: 110),
                      const SizedBox(height: 16),
                      Text(
                          "Aucune chips ne correspond. Modifiez la recherche ou le filtre.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  PetoteColors.ardoise.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverLayoutBuilder(
              builder: (context, c) {
                final cote =
                    math.max(20.0, (c.crossAxisExtent - _largeurMax) / 2);
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(cote, 8, cote, 110),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 360,
                      mainAxisExtent: 470,
                      crossAxisSpacing: 22,
                      mainAxisSpacing: 22,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final p = produits[i];
                        return ProductCard(
                          produit: p,
                          remise: _promos[p.reference] ?? 0,
                          onPromo: () => _promo(p),
                          onModifierPrix: () => _modifierPrix(p),
                        );
                      },
                      childCount: produits.length,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _entete() {
    return WaveHeader(
      child: _centre(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pétote",
                style: TextStyle(
                    color: PetoteColors.jaune,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -1.5)),
            const SizedBox(height: 4),
            Text("Le catalogue des chips ondulées, fabriquées à Douai.",
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8), fontSize: 15)),
            const SizedBox(height: 22),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                StatTile(
                    valeur: "${_catalogue.lesProduits.length}",
                    libelle: "références"),
                StatTile(
                    valeur: "${_catalogue.donnerChipsOndulees().length}",
                    libelle: "chips ondulées"),
                StatTile(
                    valeur: euros(_catalogue.valeurTotale()),
                    libelle: "valeur du catalogue"),
                StatTile(
                    valeur: "${_promos.length}",
                    libelle: "promotions actives"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _barreOutils() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Nos chips",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: PetoteColors.ardoise)),
              const SizedBox(width: 10),
              Text("${_produitsAffiches.length} affichée(s)",
                  style: TextStyle(
                      color: PetoteColors.ardoise.withValues(alpha: 0.55))),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: (v) => setState(() => _recherche = v),
            decoration: const InputDecoration(
              hintText: "Rechercher un nom ou une référence",
              prefixIcon: Icon(Icons.search),
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final f in Filtre.values)
                ChoiceChip(
                  label: Text(switch (f) {
                    Filtre.tous => "Toutes",
                    Filtre.sale => "Salées",
                    Filtre.sucre => "Sucrées",
                  }),
                  selected: _filtre == f,
                  selectedColor: PetoteColors.jaune,
                  onSelected: (_) => setState(() => _filtre = f),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
