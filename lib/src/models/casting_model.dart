
class Cast{
  List<Actor> actores = List();

  Cast.fromJsonList( List<dynamic>  jsonList){

    if(jsonList == null) return;

    jsonList.forEach( (item)  {
      final actor = Actor.fromJsonMAp(item);
      actores.add(actor);
    } );

  }
  
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

   Actor.fromJsonMAp( Map<String, dynamic> json ){
   castId         = json['cast_id'];
   character      = json['character'];
   creditId       = json['credit_id'];
   gender         = json['gender'];
   id             = json['id'];
   name           = json['name'] ;
   order          = json['order'];
   profilePath    = json['profile_path'];
  }

  String getActorImg(){
    if(profilePath == null){

      return 'https://image.shutterstock.com/image-vector/no-image-available-sign-internet-260nw-261719003.jpg';

    }
    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }

}


