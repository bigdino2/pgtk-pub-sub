import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/chunk_settings_model.dart';

part 'config_model.g.dart';

@CopyWith()
class Config {
  Config({
    required this.publisher,
    required this.publication,
    required this.subscriber,
    required this.subscription,
    required this.chunkSettings,
  });

  /// Custom fromJson method for the nested [chunkSettings].
  factory Config.fromJson(Map<String, dynamic> json) {
    final publisherJson = json['publisher'] as Map<String, dynamic>;
    final subscriberJson = json['subscriber'] as Map<String, dynamic>;
    final publicationJson =
        publisherJson['publication'] as Map<String, dynamic>;
    return Config(
      publisher: PostgresConnectionInfo.fromJson(publisherJson),
      publication: Publication.fromJson(publicationJson),
      subscriber: PostgresConnectionInfo.fromJson(subscriberJson),
      subscription: Subscription.fromJson(
        subscriberJson['subscription'] as Map<String, dynamic>,
      ),
      chunkSettings:
          (publicationJson['tables'] as List<dynamic>).map((e) {
            final tableJson = e as Map<String, dynamic>;

            return ChunkSettings.fromJson(
              tableJson['chunk_settings'] as Map<String, dynamic>,
            );
          }).toList(),
    );
  }

  final PostgresConnectionInfo publisher;
  final Publication publication;
  final PostgresConnectionInfo subscriber;
  final Subscription subscription;
  final List<ChunkSettings> chunkSettings;
}
