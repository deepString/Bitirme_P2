class Songs {
  String? photo;
  String? musicName;
  String? artist;
  String? url;

  Songs({this.photo, this.musicName, this.artist, this.url});

  Songs.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    musicName = json['musicName'];
    artist = json['artist'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['musicName'] = this.musicName;
    data['artist'] = this.artist;
    data['url'] = this.url;
    return data;
  }
}
