import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thefood/features/compoments/models/meals.dart';

part 'search.g.dart';

@JsonSerializable()
class Search with EquatableMixin {
  Search({
    this.meals,
  });
  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);
  @JsonKey(name: 'meals')
  List<Meals>? meals;

  Map<String, dynamic> toJson() => _$SearchToJson(this);

  @override
  List<Object?> get props => [meals];

  Search copyWith({
    List<Meals>? meals,
  }) {
    return Search(
      meals: meals ?? this.meals,
    );
  }
}
