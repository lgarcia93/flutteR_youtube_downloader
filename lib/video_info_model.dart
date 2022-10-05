class VideoInfoModel {
  final String title;
  final String format;
  final String qualityLabel;
  final String quality;
  final List<Thumbnail> thumbnails;
  final String link;

  VideoInfoModel({
    required this.title,
    required this.format,
    required this.qualityLabel,
    required this.quality,
    required this.thumbnails,
    required this.link,
  });

  Thumbnail biggestThumbnail() {
    var tempThumb = thumbnails;

    tempThumb.sort((a, b) {
      return a.height * a.width > b.height * b.width ? -1 : 1;
    });

    return tempThumb.first;
  }

  factory VideoInfoModel.fromMap(Map<String, dynamic> map) {
    return VideoInfoModel(
      title: map['title'],
      format: map['format'],
      qualityLabel: map['quality_label'],
      quality: map['quality'],
      link: map['link'],
      thumbnails: (map['thumbnails'] as List)
          .map(
            (e) => Thumbnail.fromMap(e),
          )
          .toList(),
    );
  }
}

class Thumbnail {
  final int width;
  final int height;
  final String url;

  Thumbnail({
    required this.width,
    required this.height,
    required this.url,
  });

  factory Thumbnail.fromMap(Map<String, dynamic> map) {
    return Thumbnail(
      width: map['width'],
      height: map['height'],
      url: map['url'],
    );
  }
}
