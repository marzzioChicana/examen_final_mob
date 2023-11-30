import 'package:examen_final/ui/favorite_superheroes_page.dart';
import 'package:examen_final/ui/superhero_search_page.dart';
import 'package:examen_final/util/db_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Llama a openDb para abrir la base de datos antes de ejecutar la aplicación
  final dbHelper = DbHelper();
  await dbHelper.openDb(); // Abre la base de datos

  runApp(const MySuperComicsApp());
}

class MySuperComicsApp extends StatelessWidget {
  const MySuperComicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Comics App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Super Heroes App',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 60),
          Image.asset(
            'assets/main.jpg',
            height: 450,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuperheroSearchPage())
                  );
                  print('Botón de Búsqueda presionado');
                },
                child: Text('Búsqueda'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteSuperheroesPage()),
                  );
                  print('Botón de Favoritos presionado');
                },
                child: Text('Favoritos'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}