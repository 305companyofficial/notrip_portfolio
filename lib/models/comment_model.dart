/// id : 4
/// memberId : 1
/// communityId : 28
/// topReply : null
/// nickName : "스테이블영"
/// children : []
/// memo : "커뮤니티 댓글 내용"
/// block : false
/// deleteStatus : false
/// modifyAt : null
/// deleteAt : null
/// createdAt : "2021-11-12T09:01:17"
/// isCommunityReport : false

class CommentModel {
  CommentModel({
      int id, 
      int memberId, 
      int communityId, 
      dynamic topReply, 
      String nickName, 
      List<CommentModel> children,
      String memo, 
      bool block, 
      bool deleteStatus, 
      dynamic modifyAt, 
      dynamic deleteAt, 
      String createdAt, 
      bool isCommunityReport,}){
    _id = id;
    _memberId = memberId;
    _communityId = communityId;
    _topReply = topReply;
    _nickName = nickName;
    _children = children;
    _memo = memo;
    _block = block;
    _deleteStatus = deleteStatus;
    _modifyAt = modifyAt;
    _deleteAt = deleteAt;
    _createdAt = createdAt;
    _isCommunityReport = isCommunityReport;
}

  CommentModel.fromJson(dynamic json) {
    _id = json['id'];
    _memberId = json['memberId'];
    _communityId = json['communityId'];
    _topReply = json['topReply'];
    _nickName = json['nickName'];
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children.add(CommentModel.fromJson(v));
      });
    }
    _memo = json['memo'];
    _block = json['block'];
    _deleteStatus = json['deleteStatus'];
    _modifyAt = json['modifyAt'];
    _deleteAt = json['deleteAt'];
    _createdAt = json['createdAt'];
    _isCommunityReport = json['isCommunityReport'];
  }
  int _id;
  int _memberId;
  int _communityId;
  dynamic _topReply;
  String _nickName;
  List<CommentModel> _children;
  String _memo;
  bool _block;
  bool _deleteStatus;
  dynamic _modifyAt;
  dynamic _deleteAt;
  String _createdAt;
  bool _isCommunityReport;

  int get id => _id;
  int get memberId => _memberId;
  int get communityId => _communityId;
  dynamic get topReply => _topReply;
  String get nickName => _nickName;
  List<CommentModel> get children => _children;
  String get memo => _memo;
  bool get block => _block;
  bool get deleteStatus => _deleteStatus;
  dynamic get modifyAt => _modifyAt;
  dynamic get deleteAt => _deleteAt;
  String get createdAt => _createdAt;
  bool get isCommunityReport => _isCommunityReport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['memberId'] = _memberId;
    map['communityId'] = _communityId;
    map['topReply'] = _topReply;
    map['nickName'] = _nickName;
    if (_children != null) {
      map['children'] = _children.map((v) => v.toJson()).toList();
    }
    map['memo'] = _memo;
    map['block'] = _block;
    map['deleteStatus'] = _deleteStatus;
    map['modifyAt'] = _modifyAt;
    map['deleteAt'] = _deleteAt;
    map['createdAt'] = _createdAt;
    map['isCommunityReport'] = _isCommunityReport;
    return map;
  }

}