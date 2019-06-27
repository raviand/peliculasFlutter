import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatelessWidget {
  final pelicuasProvider = PeliculasProvider();
  
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    pelicuasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Peliculas en cine'),
          backgroundColor: Colors.deepOrangeAccent[70],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          height: _screenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(context)
              ],
          ),
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: pelicuasProvider.getEnCines(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
            
          );
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(height: 15.0,),

          StreamBuilder(
            stream:  pelicuasProvider.popularesStream,
            
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  snapshot.data, 
                  pelicuasProvider.getPopulares 
                  );
              } else {
                return Container(
                    height: 20.0,
                    child: Center(child: Center(child: CircularProgressIndicator())));
              }
            },
          ),
        ],
      ),
    );
  }
}
