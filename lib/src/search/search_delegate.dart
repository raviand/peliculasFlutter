import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  final peliculasProvider = PeliculasProvider();

  String seleccion = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro Appbar

    return [
      IconButton(
        icon: Icon( Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del buscador
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueGrey,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if(query.isEmpty ) return Container();
    
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          final List<Pelicula> peliculas = snapshot.data;
          return ListView(
            children: peliculas.map( (pelicula) {
              pelicula.uid = '${pelicula.id}-search';
                  return Hero(
                    tag: pelicula.uid,
                      child: ListTile(
                      leading: FadeInImage(
                        image:  NetworkImage(pelicula.getPosterImg()),
                        placeholder: AssetImage('assets/img/no-image.jpg'),
                        width: 50.0,
                        fit: BoxFit.contain,
                      ),
                      title: Text(pelicula.title),
                      subtitle: Text(pelicula.originalTitle),
                      onTap: () {
                        close(context, null);
                        Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                      } 
                    ),
                  );
              } ).toList()
          );
        }
      },
    );
  }
  
}