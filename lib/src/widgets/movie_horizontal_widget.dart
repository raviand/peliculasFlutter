import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextPage;

  MovieHorizontal(@required this.peliculas, @required this.nextPage);
    final _pageController = PageController(
      initialPage: 1, 
      viewportFraction: 0.3,

    );
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    
    _pageController.addListener( () {
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        itemCount:  peliculas.length,
        controller: _pageController,
        itemBuilder: ( context , i ) =>  _tarjeta(context, peliculas[i]),

      ),
    );
  }


  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    final _card = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            Text(
              pelicula.title, 
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.overline,
            )
          ],
        ),
      );

      return GestureDetector(
        child: _card,
        onTap: (){
          Navigator.pushNamed(context, 'detalle', arguments: pelicula );
        },
      );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            Text(
              pelicula.title, 
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.overline,
            )
          ],
        ),
      );
    }).toList();
  }
}
