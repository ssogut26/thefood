import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'area.g.dart';

@JsonSerializable()
class Area with EquatableMixin {
  Area({
    this.meals,
  });
  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
  final List<MealsArea>? meals;
  Map<String, dynamic> toJson() => _$AreaToJson(this);

  @override
  List<Object?> get props => [meals];
}

@JsonSerializable()
class MealsArea with EquatableMixin {
  MealsArea({
    this.strArea,
  });
  factory MealsArea.fromJson(Map<String, dynamic> json) => _$MealsAreaFromJson(json);
  String? strArea;

  Map<String, dynamic> toJson() => _$MealsAreaToJson(this);

  @override
  List<Object?> get props => [strArea];
}
