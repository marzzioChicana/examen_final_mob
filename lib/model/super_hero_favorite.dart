class SuperHeroFavorite {
  int id;
  String image;
  String name;

  SuperHeroFavorite(this.id, this.image, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0)? null : id,
      'image': image,
      'name': name
    };
  }
}