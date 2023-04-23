import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class Anime {
  final String title;
  final String imageUrl;
  final List<String> titleSynonyms;

  Anime(
      {required this.title,
      required this.imageUrl,
      required this.titleSynonyms});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _searchController = TextEditingController();
  List<Anime> _animes = [];
  String _title = '';

  Future<void> _fetchAnime(String query) async {
    final response = await http
        .get(Uri.parse('https://api.jikan.moe/v4/anime?q=$query&sfw=true'));
    if (response.statusCode == 200) {
      setState(() {
        if (json.decode(response.body)['data'].length > 0) {
          _title = json.decode(response.body)['data'][0]['title'];
          _animes = (json.decode(response.body)['data'] as List)
              .map((anime) => Anime(
                  title: anime['title'],
                  imageUrl: anime['images']['jpg']['large_image_url'],
                  titleSynonyms: List<String>.from(anime['title_synonyms'])))
              .toList();
        } else {
          setState(() {
            _title = 'No se encontraron resultados';
            _animes = [];
          });
        }
      });
    } else {
      throw Exception('Failed to load anime');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Search',
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SvgPicture.network(
                'https://www.svgrepo.com/show/419503/anime-and-manga.svg',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 8),
              Text('Anime Search'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://e0.pxfuel.com/wallpapers/42/997/desktop-wallpaper-2b-anime-aesthetic-anime-anime-x-reality-nier-automata-anime-thumbnail.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar anime (Dar clic en la lupa)',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _fetchAnime(_searchController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
              CarouselSlider(
                items: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 90, 171, 211),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Escriba el nombre de un anime y presione la lupa',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 91, 162, 197),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Julio Antonio Alas Gómez 25-1986-2018 Parcial 3',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 90, 171, 211),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '25-1986-2018 Parcial 3',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 90,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: _animes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      _animes[index].imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons.broken_image);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Anime {
  final String title;
  final String imageUrl;
  final List<String> titleSynonyms;

  Anime(
      {required this.title,
      required this.imageUrl,
      required this.titleSynonyms});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _searchController = TextEditingController();
  List<Anime> _animes = [];

  Future<void> _fetchAnime(String query) async {
    final response = await http
        .get(Uri.parse('https://api.jikan.moe/v4/anime?q=$query&sfw=true'));
    if (response.statusCode == 200) {
      setState(() {
        _animes = (json.decode(response.body)['data'] as List)
            .map((anime) => Anime(
                title: anime['title'],
                imageUrl: anime['images']['jpg']['large_image_url'],
                titleSynonyms: List<String>.from(anime['title_synonyms'])))
            .toList();
      });
    } else {
      throw Exception('Failed to load anime');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Search',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Anime Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar anime',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _fetchAnime(_searchController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: _animes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          _animes[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _animes[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Títulos alternativos: ${_animes[index].titleSynonyms.join(', ')}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String apiUrl = 'https://api.jikan.moe/v4/anime?q=naruto&sfw=true';

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Anime App'),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              final titleSynonyms = data['data'][0]['title_synonyms'];
              final images = data['data'][0]['images']['jpg'];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Title Synonyms: $titleSynonyms',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Image.network(images['large_image_url']),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
*/