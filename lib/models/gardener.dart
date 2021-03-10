class Gardener {
  final int id;
  final String firstName;
  final String lastName;
  final dynamic price;
  final String notes;
  final String image;
  final String phoneNumber;

  Gardener({this.id, this.firstName, this.lastName, this.price, this.notes, this.image, this.phoneNumber});

  factory Gardener.fromJson(Map<String, dynamic> json) {
    return Gardener(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      price: json['price'],
      notes: json['notes'],
      image: json['image'],
      phoneNumber: json['phone_number'],
    );
  }

  String fullName(){
    return this.firstName+' '+this.lastName;
  }

}
