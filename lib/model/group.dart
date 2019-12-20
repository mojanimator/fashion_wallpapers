class Group {
  final int id;
  final String name;
  final int number;
  final DateTime created_at;

  Group(this.id, this.name, this.number, this.created_at);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'created_at': created_at,
      };
  // int get id => _id;

  // set id(int value) {
  //   _id = value;
  // }

  // String get name => _name;

  // set name(String value) {
  //   _name = value;
  // }

  // int get num => _num;

  // set num(int value) {
  //   _num = value;
  // }

  // DateTime get created_at => _created_at;

  // set created_at(DateTime value) {
  //   _created_at = value;
  // }
}
