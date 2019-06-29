import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  final SwiperLayout layout;
  CardSwiper({@required this.peliculas, this.layout});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
      ),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {

          peliculas[index].uid = '${peliculas[index].id}-swiper';
          return Hero(
            tag: peliculas[index].uid,
            transitionOnUserGestures: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]);
                },
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: layout == null ? SwiperLayout.STACK : layout,
      ),
    );
  }
}
