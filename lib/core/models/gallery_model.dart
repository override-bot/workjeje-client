class Gallery {
  final String? id;
  final List? imageUrl;
  final String? caption;
  Gallery({this.id, this.caption, this.imageUrl});
  Gallery.fromMap(Map snapshot, this.id)
      : imageUrl = snapshot["imageUrl"],
        caption = snapshot['caption'];
  toJson() {
    return {
      "imageUrl": imageUrl,
      "caption": caption,
    };
  }
}
