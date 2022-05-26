import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item({
    this.id,
    required this.name,
    required this.email,
    this.createAt,
  });

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'create_at')
  String? createAt;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  Item copyWith({
    String? name,
    String? email,
  }) {
    return Item(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      createAt: createAt,
    );
  }
}
