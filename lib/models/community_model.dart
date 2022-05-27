/// subject : "44"
/// memberId : 1
/// nickName : "스테이블영"
/// createdAt : "2021-11-17T16:19:28"
/// memo : "555"
/// images : [{"id":59,"filename":"file12021-11-17 16:19:20.47822420211028_185731.jpg","path":"Community-c6553db0-ab01-4405-af63-3e5e8cf0cbec_file12021-11-17 16:19:20.47822420211028_185731.jpg","type":"application/octet-stream","ratio":"1.3333"}]
/// goodCount : 0
/// isGood : true
/// isReport : false
/// isScrap : true
/// replyCount : 0
/// viewCount : 1
/// isWheelchair : false
/// isToilet : true
/// isNokids : false
/// isParking : false
/// isWifi : true
/// isPet : false
/// id : 44

class CommunityModel {
  CommunityModel({
      String subject, 
      int memberId, 
      String nickName, 
      String createdAt, 
      String memo, 
      List<Images> images, 
      int goodCount, 
      bool isGood, 
      bool isReport, 
      bool isScrap, 
      int replyCount, 
      int viewCount, 
      bool isWheelchair, 
      bool isToilet, 
      bool isNokids, 
      bool isParking, 
      bool isWifi, 
      bool isPet, 
      int id,}){
    _subject = subject;
    _memberId = memberId;
    _nickName = nickName;
    _createdAt = createdAt;
    _memo = memo;
    _images = images;
    _goodCount = goodCount;
    _isGood = isGood;
    _isReport = isReport;
    _isScrap = isScrap;
    _replyCount = replyCount;
    _viewCount = viewCount;
    _isWheelchair = isWheelchair;
    _isToilet = isToilet;
    _isNokids = isNokids;
    _isParking = isParking;
    _isWifi = isWifi;
    _isPet = isPet;
    _id = id;
}

  CommunityModel.fromJson(dynamic json) {
    _subject = json['subject'];
    _memberId = json['memberId'];
    _nickName = json['nickName'];
    _createdAt = json['createdAt'];
    _memo = json['memo'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images.add(Images.fromJson(v));
      });
    }
    _goodCount = json['goodCount'];
    _isGood = json['isGood'];
    _isReport = json['isReport'];
    _isScrap = json['isScrap'];
    _replyCount = json['replyCount'];
    _viewCount = json['viewCount'];
    _isWheelchair = json['isWheelchair']??false;
    _isToilet = json['isToilet']??false;
    _isNokids = json['isNokids']??false;
    _isParking = json['isParking']??false;
    _isWifi = json['isWifi']??false;
    _isPet = json['isPet']??false;
    _id = json['id'];
  }
  String _subject;
  int _memberId;
  String _nickName;
  String _createdAt;
  String _memo;
  List<Images> _images;
  int _goodCount;
  bool _isGood;
  bool _isReport;
  bool _isScrap;
  int _replyCount;
  int _viewCount;
  bool _isWheelchair;
  bool _isToilet;
  bool _isNokids;
  bool _isParking;
  bool _isWifi;
  bool _isPet;
  int _id;

  String get subject => _subject;
  int get memberId => _memberId;
  String get nickName => _nickName;
  String get createdAt => _createdAt;
  String get memo => _memo;
  List<Images> get images => _images;
  int get goodCount => _goodCount;
  bool get isGood => _isGood;
  bool get isReport => _isReport;
  bool get isScrap => _isScrap;
  int get replyCount => _replyCount;
  int get viewCount => _viewCount;
  bool get isWheelchair => _isWheelchair;
  bool get isToilet => _isToilet;
  bool get isNokids => _isNokids;
  bool get isParking => _isParking;
  bool get isWifi => _isWifi;
  bool get isPet => _isPet;
  int get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subject'] = _subject;
    map['memberId'] = _memberId;
    map['nickName'] = _nickName;
    map['createdAt'] = _createdAt;
    map['memo'] = _memo;
    if (_images != null) {
      map['images'] = _images.map((v) => v.toJson()).toList();
    }
    map['goodCount'] = _goodCount;
    map['isGood'] = _isGood;
    map['isReport'] = _isReport;
    map['isScrap'] = _isScrap;
    map['replyCount'] = _replyCount??false;
    map['viewCount'] = _viewCount??false;
    map['isWheelchair'] = _isWheelchair??false;
    map['isToilet'] = _isToilet??false;
    map['isNokids'] = _isNokids??false;
    map['isParking'] = _isParking??false;
    map['isWifi'] = _isWifi??false;
    map['isPet'] = _isPet??false;
    map['id'] = _id;
    return map;
  }

}

/// id : 59
/// filename : "file12021-11-17 16:19:20.47822420211028_185731.jpg"
/// path : "Community-c6553db0-ab01-4405-af63-3e5e8cf0cbec_file12021-11-17 16:19:20.47822420211028_185731.jpg"
/// type : "application/octet-stream"
/// ratio : "1.3333"

class Images {
  Images({
      int id, 
      String filename, 
      String path, 
      String type, 
      String ratio,}){
    _id = id;
    _filename = filename;
    _path = path;
    _type = type;
    _ratio = ratio;
}

  Images.fromJson(dynamic json) {
    _id = json['id'];
    _filename = json['filename'];
    _path = json['path'];
    _type = json['type'];
    _ratio = json['ratio'];
  }
  int _id;
  String _filename;
  String _path;
  String _type;
  String _ratio;

  int get id => _id;
  String get filename => _filename;
  String get path => _path;
  String get type => _type;
  String get ratio => _ratio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['filename'] = _filename;
    map['path'] = _path;
    map['type'] = _type;
    map['ratio'] = _ratio;
    return map;
  }

}