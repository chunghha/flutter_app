import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  String name;
  String capital;
  int population;
  String subregion;
  String flag;

  Country(
      {this.name, this.capital, this.population, this.subregion, this.flag});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
