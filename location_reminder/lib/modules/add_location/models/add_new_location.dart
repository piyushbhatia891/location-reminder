class AddANewLocation{
  int id;
  String name,description,image,latitude,longitude,creation_date;
  AddANewLocation({this.id,this.name,this.description,this.latitude,this.longitude,this.creation_date,this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'latitude':latitude,
      'longitude':longitude,
      'image':image,
      'creation_date':creation_date
    };
  }
}