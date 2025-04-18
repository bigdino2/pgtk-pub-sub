// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConfigCWProxy {
  Config publisher(PostgresConnectionInfo publisher);

  Config publication(Publication publication);

  Config subscriber(PostgresConnectionInfo subscriber);

  Config subscription(Subscription subscription);

  Config chunkSettings(List<ChunkSettings> chunkSettings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Config(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Config(...).copyWith(id: 12, name: "My name")
  /// ````
  Config call({
    PostgresConnectionInfo publisher,
    Publication publication,
    PostgresConnectionInfo subscriber,
    Subscription subscription,
    List<ChunkSettings> chunkSettings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConfig.copyWith.fieldName(...)`
class _$ConfigCWProxyImpl implements _$ConfigCWProxy {
  const _$ConfigCWProxyImpl(this._value);

  final Config _value;

  @override
  Config publisher(PostgresConnectionInfo publisher) =>
      this(publisher: publisher);

  @override
  Config publication(Publication publication) => this(publication: publication);

  @override
  Config subscriber(PostgresConnectionInfo subscriber) =>
      this(subscriber: subscriber);

  @override
  Config subscription(Subscription subscription) =>
      this(subscription: subscription);

  @override
  Config chunkSettings(List<ChunkSettings> chunkSettings) =>
      this(chunkSettings: chunkSettings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Config(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Config(...).copyWith(id: 12, name: "My name")
  /// ````
  Config call({
    Object? publisher = const $CopyWithPlaceholder(),
    Object? publication = const $CopyWithPlaceholder(),
    Object? subscriber = const $CopyWithPlaceholder(),
    Object? subscription = const $CopyWithPlaceholder(),
    Object? chunkSettings = const $CopyWithPlaceholder(),
  }) {
    return Config(
      publisher:
          publisher == const $CopyWithPlaceholder()
              ? _value.publisher
              // ignore: cast_nullable_to_non_nullable
              : publisher as PostgresConnectionInfo,
      publication:
          publication == const $CopyWithPlaceholder()
              ? _value.publication
              // ignore: cast_nullable_to_non_nullable
              : publication as Publication,
      subscriber:
          subscriber == const $CopyWithPlaceholder()
              ? _value.subscriber
              // ignore: cast_nullable_to_non_nullable
              : subscriber as PostgresConnectionInfo,
      subscription:
          subscription == const $CopyWithPlaceholder()
              ? _value.subscription
              // ignore: cast_nullable_to_non_nullable
              : subscription as Subscription,
      chunkSettings:
          chunkSettings == const $CopyWithPlaceholder()
              ? _value.chunkSettings
              // ignore: cast_nullable_to_non_nullable
              : chunkSettings as List<ChunkSettings>,
    );
  }
}

extension $ConfigCopyWith on Config {
  /// Returns a callable class that can be used as follows: `instanceOfConfig.copyWith(...)` or like so:`instanceOfConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConfigCWProxy get copyWith => _$ConfigCWProxyImpl(this);
}
