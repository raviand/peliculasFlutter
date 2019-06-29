import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/casting_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider{

  String _apiKey = '4d01f03d72eec6bd6e1e6125af683e6c';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _listaPopulares = new List();

  final _popularStream = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularStream.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularStream.stream;

  void disposeStreams(){
    _popularStream?.close();
  }

  Future <List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language' : _languaje,
      'page' : '1'
    });

    final response = await  http.get(url);

    if(response.statusCode == 200){

      final data = json.decode(response.body);

      final peliculas = Peliculas.fromJsonList(data['results']);

      return peliculas.items;
    }
  }

  Future<List<Pelicula>> getPopulares() async{
    
    if ( _cargando ) return [];
    
    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language' : _languaje,
      'page' : _popularesPage.toString()
    });

    final response = await  http.get(url);

    if(response.statusCode == 200){

      final data = json.decode(response.body);

      final peliculas = Peliculas.fromJsonList(data['results']);

      final resp = peliculas.items;

      _listaPopulares.addAll(resp);

      popularesSink(_listaPopulares);
      _cargando = false;
      return resp;
    }


  }

  Future<List<Actor>> getCasting(int idMovie) async{
    ///movie/{movie_id}/credits
    final url = Uri.https(_url, '3/movie/$idMovie/credits', {
      'api_key' : _apiKey,
      'language' : _languaje,
    });

     final response = await  http.get(url);

    if(response.statusCode == 200){

      final data = json.decode(response.body);

      final actores = Cast.fromJsonList(data['cast']);

      return actores.actores;
    }
  }

  Future<List<Pelicula>> buscarPelicula(String query) async{
        final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _languaje,
      'query' : query
    });

    final response = await  http.get(url);

    if(response.statusCode == 200){

      final data = json.decode(response.body);

      final peliculas = Peliculas.fromJsonList(data['results']);

      return peliculas.items;
    }
  }

}