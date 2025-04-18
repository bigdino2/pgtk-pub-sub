import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgtk_common/pgtk_common.dart';

part 'subscription_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Subscription extends Equatable {
  const Subscription({required this.name, required this.connectionString});

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  @StringConverter()
  final String name;

  @StringConverter()
  final String connectionString;

  @override
  List<Object> get props => [name, connectionString];

  @override
  bool get stringify => true;
}
