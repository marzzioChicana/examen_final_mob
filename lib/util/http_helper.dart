import 'dart:convert';
import 'dart:io';
import 'package:examen_final/model/super_hero.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String urlBase = 'https://superheroapi.com/api/';
  final String urlKey = '10157703717092094';
  final String urlName = '/search/';
  //https://superheroapi.com/api/10157703717092094

  Future<List<SuperHero>> getSuperHeroesByName(String name) async {
    final String urlFinal = urlBase + urlKey + urlName + name;
    print(urlFinal);
    http.Response result = await http.get(Uri.parse(urlFinal));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);

      final superHeroesMap = jsonResponse['results'];
      if (superHeroesMap is List) {
        List<SuperHero> superHeroes = superHeroesMap.map<SuperHero>((i) => SuperHero.fromJson(i)).toList();
        return superHeroes;
      } else {
        print("'results' no es una lista en la respuesta JSON");
        return <SuperHero>[];
      }
    } else {
      print(result.body);
      return <SuperHero>[];
    }
  }
}