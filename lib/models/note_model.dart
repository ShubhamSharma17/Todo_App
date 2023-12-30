class NotesModel {
  String? notes;
  String? description;
  String? noteID;
  DateTime? date;

  NotesModel({
    this.notes,
    this.description,
    this.date,
    this.noteID,
  });

  NotesModel.fromMap(Map<String, dynamic> map) {
    notes = map["notes"];
    noteID = map["noteID"];
    description = map["description"];
    date = map["date"].toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      "notes": notes,
      "noteID": noteID,
      "description": description,
      "date": date,
    };
  }
}
