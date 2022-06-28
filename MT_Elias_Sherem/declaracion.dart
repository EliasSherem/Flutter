class Declaracion {
  final String imageurl;
  Declaracion(
    this.imageurl,
  );
  factory Declaracion.fromMap(Map<String, dynamic> json) {
    return Declaracion(json['imageurl']);
  }
}
