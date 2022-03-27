class Reviews {
  final String? id;
  final int rate;
  final String review;
  final String name;
  final String image;

  Reviews(
      {this.id,
      required this.image,
      required this.name,
      required this.rate,
      required this.review});

  Reviews.fromMap(Map snapshot, this.id)
      : rate = snapshot['rate'],
        review = snapshot['review'],
        name = snapshot['name'],
        image = snapshot['imageUrl'];

  toJson() {
    return {"rate": rate, "review": review, "name": name, "imageUrl": image};
  }
}
