import 'package:dio/dio.dart';
import 'package:youtube_downloader_flutter/video_info_model.dart';

class ApiController {
  final Dio dio = Dio();

  Future<List<VideoInfoModel>> fetchVideoInfo({
    required String link,
  }) async {
    final response = await dio.get(
      "http://localhost:5000/video_info",
      queryParameters: {
        'link': link,
      },
    );

    var list =
        (response.data as List).map((e) => VideoInfoModel.fromMap(e)).toList();

    Map<String, VideoInfoModel> singleInfo = {};

    for (var info in list) {
      singleInfo[info.qualityLabel] = info;
    }

    return singleInfo.values.map((e) => e).toList();
  }

  Future<void> downlioadVideo({
    required String link,
    required String sessionId,
  }) async {
    final response = await dio.get(
      "http://localhost:5000/download_video",
      queryParameters: {
        'link': link,
        'sessionId': sessionId,
      },
    );
  }
}
