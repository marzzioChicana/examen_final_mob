import 'package:flutter/material.dart';
import 'package:examen_final/model/super_hero_favorite.dart';
import 'package:examen_final/util/db_helper.dart';

class FavoriteSuperheroesPage extends StatefulWidget {
  const FavoriteSuperheroesPage({Key? key}) : super(key: key);

  @override
  _FavoriteSuperheroesPageState createState() => _FavoriteSuperheroesPageState();
}

class _FavoriteSuperheroesPageState extends State<FavoriteSuperheroesPage> {
  late List<SuperHeroFavorite> _favoriteSuperheroes = [];
  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    _loadFavoriteSuperheroes();
  }

  Future<void> _loadFavoriteSuperheroes() async {
    final List<SuperHeroFavorite> favorites = await _dbHelper.getSuperHeroesFavorites();
    setState(() {
      _favoriteSuperheroes = favorites;
    });
  }

  Future<void> _deleteFavoriteSuperhero(int id) async {
    await _dbHelper.deleteSuperHeroById(id);
    _loadFavoriteSuperheroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Heroes Favorites'),
      ),
      body: _buildFavoriteSuperheroesList(),
    );
  }

  Widget _buildFavoriteSuperheroesList() {
    if (_favoriteSuperheroes.isEmpty) {
      return const Center(
        child: Text('No tienes SuperHéroes favoritos.'),
      );
    }

    return ListView.builder(
      itemCount: _favoriteSuperheroes.length,
      itemBuilder: (context, index) {
        SuperHeroFavorite superhero = _favoriteSuperheroes[index];

        return ListTile(
          title: Text(superhero.name ?? 'Nombre Desconocido'),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(superhero.image ?? ''),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteFavoriteSuperhero(superhero.id!);
            },
          ),
        );
      },
    );
  }
}