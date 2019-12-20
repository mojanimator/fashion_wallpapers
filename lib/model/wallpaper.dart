import 'dart:convert';

class Wallpaper {
  final int id;
  final int group_id;
  final String path;
  final int size;
  final String created_at;

  Wallpaper(this.id, this.group_id, this.path, this.size, this.created_at);

  Wallpaper.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        group_id = json['group_id'],
        path = json['path'],
        size = json['size'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': group_id,
        'path': path,
        'size': size,
        'created_at': created_at,
      };

  // int get id => _id;

  // set id(int value) {
  //   _id = value;
  // }

  // int get group_id => _group_id;

  // set group_id(int value) {
  //   _group_id = value;
  // }

  // String get path => _path;

  // set path(String value) {
  //   _path = value;
  // }

  // int get size => _size;

  // set size(int value) {
  //   _size = value;
  // }

  // DateTime get created_at => _created_at;

  // set created_at(DateTime value) {
  //   _created_at = value;
  // }
}
