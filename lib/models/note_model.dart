class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime dateTime; // Field for date and time

  const Note({
    required this.title,
    required this.description,
    this.id,
    required this.dateTime, // Required field
  });

  // Factory constructor to create a Note from a JSON object
  factory Note.fromJson(Map<String, dynamic> json) {
    // Parse dateTime with space between date and time
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime'].replaceAll(' ', 'T')), // Convert space to 'T'
    );
  }

  // Method to convert Note to a JSON object
  Map<String, dynamic> toJson() {
    // Format dateTime to ISO 8601 string
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(), // Convert to ISO 8601 format
    };
  }
}
