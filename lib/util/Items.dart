import 'package:firebase_database/firebase_database.dart';

class Item {
  String key;
  String title;
  String body;
  String imageUrl;
  String startDate;
  String endDate;
  String postedBy;

  Item(this.title, this.body, this.imageUrl, this.startDate, this.endDate,
      this.postedBy);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        body = snapshot.value["body"],
        imageUrl = snapshot.value["imageUrl"],
        startDate = snapshot.value["startDate"],
        endDate = snapshot.value["endDate"],
        postedBy = snapshot.value["postedBy"];

  toJson() {
    return {
      "title": title,
      "body": body,
      "imageUrl": imageUrl,
      "startDate": startDate,
      "endDate": endDate,
      "postedBy": postedBy,
    };
  }
}
