import 'package:flutter/material.dart';
import 'package:peliculas/src/models/casting_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetallePage extends StatelessWidget {
  //final Pelicula pelicula;
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppBar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 15.0,
            ),
            _posterTitulo(pelicula, context),
            _descripcion(pelicula),
            _crearCasting(pelicula.id)
          ]),
        )
      ],
    ));
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uid,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(pelicula.getPosterImg()),
              height: 150.0,
            ),
            ),
          ),
          SizedBox(width: 15.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text('Vote Averange: ${pelicula.voteAverage}'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview, 
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          height: 1.0
        ),
        ),
    );
  }

  Widget _crearCasting(int movieid){
    final peliprovider = PeliculasProvider();



    return FutureBuilder(
      future: peliprovider.getCasting(movieid),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Image(
            image: AssetImage('assets/img/loading.gif'),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
          controller: PageController(
            viewportFraction: 0.3,
            initialPage: 1
          ),
          itemCount: actores.length,
          itemBuilder: (context , i){
            return _castCard(actores[i]);
          },
      ),
    );
  }

  Widget _castCard(Actor actor){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
              image: NetworkImage(actor.getActorImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(
              color: Colors.orangeAccent,
              //fontFamily: 'VT323',
              fontSize: 20.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
