import 'package:flutter/material.dart';

import '../data/catalogue_petote.dart';
import '../models/catalogue.dart';
import '../models/produit.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/dialogs.dart';
import '../widgets/product_card.dart';
import '../widgets/stat_tile.dart';
import '../widgets/wave_header.dart';

enum Filtre { tous, sale, sucre }

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
      liste = _catalogue
          .donnerChipsOndulees()
          .where((c) => c.gout.type == type);
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
    _message("${chips.nom} ajouté au catalogue.");
  }

  @override
  Widget build(BuildContext context) {
    final produits = _produitsAffiches;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ajouter,
        backgroundColor: PetoteColors.jaune,
        foregroundColor: PetoteColors.ardoise,
        icon: const Icon(Icons.add),
        label: const Text("Nouveau produit",
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _entete()),
          SliverToBoxAdapter(child: _barreOutils()),
          if (produits.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    "Aucun produit ne correspond. Modifiez la recherche ou le filtre.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisExtent: 268,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
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
            ),
        ],
      ),
    );
  }

  Widget _entete() {
    return WaveHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pétote",
              style: TextStyle(
                  color: PetoteColors.jaune,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1)),
          const SizedBox(height: 4),
          Text("Chips ondulées en petites séries, made in Douai.",
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 15)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              StatTile(
                  valeur: "${_catalogue.lesProduits.length}",
                  libelle: "produits au catalogue"),
              StatTile(
                  valeur: "${_catalogue.donnerChipsOndulees().length}",
                  libelle: "chips ondulées"),
              StatTile(
                  valeur: euros(_catalogue.valeurTotale()),
                  libelle: "valeur totale"),
              StatTile(
                  valeur: "${_promos.length}", libelle: "promotions en cours"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barreOutils() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    Filtre.tous => "Tous",
                    Filtre.sale => "Salé",
                    Filtre.sucre => "Sucré",
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
