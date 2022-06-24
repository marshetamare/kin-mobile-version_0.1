import 'package:json_annotation/json_annotation.dart';

part 'podcastEpisode.g.dart';

@JsonSerializable()
class PodCastEpisode {
  final int id;
  final String title;
  final String duration;
  final String audio;

  PodCastEpisode(
      {required this.id,
      required this.title,
      required this.duration,
      required this.audio});

  factory PodCastEpisode.fromJson(Map<String, dynamic> json) {
    return _$PodCastEpisodeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodCastEpisodeToJson(this);
}
