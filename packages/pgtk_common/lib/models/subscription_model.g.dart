// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
  name: const StringConverter().fromJson(json['name']),
  connectionString: const StringConverter().fromJson(json['connection_string']),
);

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'name': const StringConverter().toJson(instance.name),
      'connection_string': const StringConverter().toJson(
        instance.connectionString,
      ),
    };
