class GravatarModel {
  List<Entry> entry;

  GravatarModel({this.entry});

  GravatarModel.fromJson(Map<String, dynamic> json) {
    if (json['entry'] != null) {
      entry = new List<Entry>();
      json['entry'].forEach((v) {
        entry.add(new Entry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.entry != null) {
      data['entry'] = this.entry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entry {
  String id;
  String hash;
  String requestHash;
  String profileUrl;
  String preferredUsername;
  String thumbnailUrl;
  List<Photos> photos;
  String displayName;
  List<Null> urls;

  Entry(
      {this.id,
        this.hash,
        this.requestHash,
        this.profileUrl,
        this.preferredUsername,
        this.thumbnailUrl,
        this.photos,
        this.displayName,
        this.urls});

  Entry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hash = json['hash'];
    requestHash = json['requestHash'];
    profileUrl = json['profileUrl'];
    preferredUsername = json['preferredUsername'];
    thumbnailUrl = json['thumbnailUrl'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    displayName = json['displayName'];
    if (json['urls'] != null) {
      urls = new List<Null>();
      json['urls'].forEach((v) {
        // urls.add(new Null.fromJson(v));  // ToDo: verificar
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hash'] = this.hash;
    data['requestHash'] = this.requestHash;
    data['profileUrl'] = this.profileUrl;
    data['preferredUsername'] = this.preferredUsername;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['displayName'] = this.displayName;
    if (this.urls != null) {
      // data['urls'] = this.urls.map((v) => v.toJson()).toList(); // ToDo: verificar
    }
    return data;
  }
}

class Photos {
  String value;
  String type;

  Photos({this.value, this.type});

  Photos.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}