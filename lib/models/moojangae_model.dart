/// addr1 : "부산광역시 남구 수영로 309"
/// addr2 : "(대연동)"
/// areacode : 6
/// booktour : 0
/// cat1 : "A02"
/// cat2 : "A0206"
/// cat3 : "A02060100"
/// contentid : 129823
/// contenttypeid : 14
/// createdtime : 20071106013202
/// dist : 4077
/// firstimage : "http://tong.visitkorea.or.kr/cms/resource/24/1859024_image2_1.jpg"
/// firstimage2 : "http://tong.visitkorea.or.kr/cms/resource/24/1859024_image3_1.jpg"
/// mapx : 129.0969499828
/// mapy : 35.1422639512
/// mlevel : 6
/// modifiedtime : 20210916152610
/// readcount : 28649
/// sigungucode : 4
/// title : "경성대학교 문화홍보처 박물관"

class MoojangaeModel {
  MoojangaeModel({
      String addr1, 
      String addr2,
      int areacode,
      int booktour,
      String cat1, 
      String cat2, 
      String cat3, 
      int contentid, 
      int contenttypeid, 
      int createdtime, 
      int dist, 
      String firstimage, 
      String firstimage2,
    String mapx,
    String mapy,
      int mlevel, 
      int modifiedtime, 
      int readcount, 
      int sigungucode, 
      String title,}){
    _addr1 = addr1;
    _addr2 = addr2;
    _areacode = areacode;
    _booktour = booktour;
    _cat1 = cat1;
    _cat2 = cat2;
    _cat3 = cat3;
    _contentid = contentid;
    _contenttypeid = contenttypeid;
    _createdtime = createdtime;
    _dist = dist;
    _firstimage = firstimage;
    _firstimage2 = firstimage2;
    _mapx = mapx;
    _mapy = mapy;
    _mlevel = mlevel;
    _modifiedtime = modifiedtime;
    _readcount = readcount;
    _sigungucode = sigungucode;
    _title = title;
}

  MoojangaeModel.fromJson(dynamic json) {
    _addr1 = json['addr1'];
    _addr2 = json['addr2'];
    _areacode = json['areacode'];
    _booktour = json['booktour'];
    _cat1 = json['cat1'];
    _cat2 = json['cat2'];
    _cat3 = json['cat3'];
    _contentid = json['contentid'];
    _contenttypeid = json['contenttypeid'];
    _createdtime = json['createdtime'];
    _dist = json['dist'];
    _firstimage = json['firstimage'];
    _firstimage2 = json['firstimage2'];
    _mapx = (json['mapx']).toString();
    _mapy = (json['mapy']).toString();
    _mlevel = json['mlevel'];
    _modifiedtime = json['modifiedtime'];
    _readcount = json['readcount'];
    _sigungucode = json['sigungucode'];
    _title = json['title'];
  }
  String _addr1;
  String _addr2;
  int _areacode;
  int _booktour;
  String _cat1;
  String _cat2;
  String _cat3;
  int _contentid;
  int _contenttypeid;
  int _createdtime;
  int _dist;
  String _firstimage;
  String _firstimage2;
  String _mapx;
  String _mapy;
  int _mlevel;
  int _modifiedtime;
  int _readcount;
  int _sigungucode;
  String _title;

  String get addr1 => _addr1;
  String get addr2 => _addr2;
  int get areacode => _areacode;
  int get booktour => _booktour;
  String get cat1 => _cat1;
  String get cat2 => _cat2;
  String get cat3 => _cat3;
  int get contentid => _contentid;
  int get contenttypeid => _contenttypeid;
  int get createdtime => _createdtime;
  int get dist => _dist;
  String get firstimage => _firstimage;
  String get firstimage2 => _firstimage2;
  String get mapx => _mapx;
  String get mapy => _mapy;
  int get mlevel => _mlevel;
  int get modifiedtime => _modifiedtime;
  int get readcount => _readcount;
  int get sigungucode => _sigungucode;
  String get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addr1'] = _addr1;
    map['addr2'] = _addr2;
    map['areacode'] = _areacode;
    map['booktour'] = _booktour;
    map['cat1'] = _cat1;
    map['cat2'] = _cat2;
    map['cat3'] = _cat3;
    map['contentid'] = _contentid;
    map['contenttypeid'] = _contenttypeid;
    map['createdtime'] = _createdtime;
    map['dist'] = _dist;
    map['firstimage'] = _firstimage;
    map['firstimage2'] = _firstimage2;
    map['mapx'] = _mapx;
    map['mapy'] = _mapy;
    map['mlevel'] = _mlevel;
    map['modifiedtime'] = _modifiedtime;
    map['readcount'] = _readcount;
    map['sigungucode'] = _sigungucode;
    map['title'] = _title;
    return map;
  }

  @override
  String toString() {
    return 'MoojangaeModel{_addr1: $_addr1, _addr2: $_addr2, _areacode: $_areacode'
        ', _booktour: $_booktour, _cat1: $_cat1, _cat2: $_cat2, _cat3: $_cat3, _contentid: $_contentid,'
        ' _contenttypeid: $_contenttypeid, _createdtime: $_createdtime, _dist: $_dist, _firstimage: $_firstimage,'
        ' _firstimage2: $_firstimage2, _mapx: $_mapx, _mapy: $_mapy, _mlevel: $_mlevel, _modifiedtime: $_modifiedtime,'
        ' _readcount: $_readcount, _sigungucode: $_sigungucode, _title: $_title}';
  }
}