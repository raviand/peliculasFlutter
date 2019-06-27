import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider{

  String _apiKey = '4d01f03d72eec6bd6e1e6125af683e6c';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularesPage = 0;

  List<Pelicula> _listaPopulares = new List();

  final _popularStream = StreamController<List<Pelicula>>.broadcast();

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

      return resp;
    }


  }

  Function(List<Pelicula>) get popularesSink => _popularStream.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularStream.stream;

}