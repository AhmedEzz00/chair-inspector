class VisualNote {
  String? date;
  String? title;
  String? imagePath;
  String? description;
  String? status;
  int? id;

  VisualNote(
      {this.description,
      this.date,
      this.id,
      this.status,
      this.title,
      this.imagePath});

  VisualNote.fromJson(Map<String, dynamic> json) {
    date= json['date'];
    title= json['title'];
    imagePath=json['imagePath'];
    description= json['description'];
    status = json['status'];
    id= json['id'];
  }
}
