import 'package:examen_final/model/super_hero.dart';
import 'package:examen_final/model/super_hero_favorite.dart';
import 'package:examen_final/util/db_helper.dart';
import 'package:examen_final/util/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuperheroSearchPage extends StatefulWidget {
  const SuperheroSearchPage({super.key});

  @override
  State<SuperheroSearchPage> createState() => _SuperheroSearchPageState();
}

class _SuperheroSearchPageState extends State<SuperheroSearchPage> {
  TextEditingController _searchController = TextEditingController();
  int _resultCount = 0;
  List<SuperHero> _superheroes = [];

  HttpHelper _httpHelper = HttpHelper();

  @override
  void initState() {
    super.initState();
    _loadResultCount();
  }

  Future<void> _loadResultCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int resultCount = prefs.getInt('resultCount') ?? 0;
    setState(() {
      _resultCount = resultCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Heroe Search'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Resultados: $_resultCount'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre del SuperHéroe',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _performSearch();
              },
              child: Text('Realizar Consulta'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildSuperheroesList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFavorite(SuperHero superhero) async {

    SuperHeroFavorite superHeroFavorite = SuperHeroFavorite(
      0,
      superhero.image?.url ?? '',
      superhero.name ?? '',
    );

    bool isAlreadyFavorite = await _isSuperHeroAlreadyFavorite(superHeroFavorite.name);

    if (!isAlreadyFavorite) {
      int id = await DbHelper.dbHelper.insertSuperHero(superHeroFavorite);

      print('SuperHéroe Favorito Insertado con ID: $id');
    } else {
      print('SuperHéroe ya está en la base de datos');

      _showSnackBar('Este Superhéroe ya está en favoritos');
    }
  }

  Future<bool> _isSuperHeroAlreadyFavorite(String superheroName) async {
    if (DbHelper.dbHelper.dbExamenFinal == null) {
      return false;
    }

    List<SuperHeroFavorite> favorites = await DbHelper.dbHelper.getSuperHeroesFavorites();

    if (favorites.isNotEmpty) {
      return favorites.any((favorite) => favorite.name == superheroName);
    } else {
      return false;
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  Widget _buildSuperheroesList() {
    return ListView.builder(
      itemCount: _superheroes.length,
      itemBuilder: (context, index) {
        SuperHero superhero = _superheroes[index];

        return ListTile(
          title: Text(superhero.name ?? 'Nombre Desconocido'),
          subtitle: Text(
            'Género: ${superhero.appearance?.gender ?? 'Género Desconocido'}\nInteligencia: ${superhero.powerstats?.intelligence ?? 'Inteligencia Desconocida'}',
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(superhero.image?.url ?? ''),
          ),
          trailing: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              await _handleFavorite(superhero);
            },
          ),
        );
      },
    );
  }

  Future<void> _performSearch() async {
    String superheroName = _searchController.text;

    List<SuperHero> results = await _httpHelper.getSuperHeroesByName(superheroName);

    setState(() {
      _resultCount = results.length;
      _superheroes = results;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('resultCount', _resultCount);
  }
}