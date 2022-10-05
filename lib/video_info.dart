import 'package:flutter/material.dart';
import 'package:youtube_downloader_flutter/video_info_model.dart';

class VideoInfo extends StatelessWidget {
  final List<VideoInfoModel> videoInfo;
  final void Function(VideoInfoModel) onDownloadPressed;

  const VideoInfo({
    Key? key,
    required this.videoInfo,
    required this.onDownloadPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    videoInfo.sort((a, b) {
      var aStr = a.qualityLabel.replaceAll(RegExp(r'[^0-9]'), '');
      var bStr = b.qualityLabel.replaceAll(RegExp(r'[^0-9]'), '');

      return int.parse(aStr) > int.parse(bStr) ? -1 : 1;
    });

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                videoInfo[0].title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Image.network(
                fit: BoxFit.fitHeight,
                videoInfo[0].biggestThumbnail().url,
                width: 400,
                height: 400,
              ),
            ],
          ),
          const SizedBox(
            width: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: videoInfo
                .map(
              (e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      e.qualityLabel,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onDownloadPressed(e);
                    },
                    child: const Text('Download'),
                  ),
                ],
              ),
            )
                .fold(
              <Widget>[],
              (previousValue, element) => [
                ...previousValue,
                Container(
                  height: 30,
                ),
                element
              ],
            ).toList(),
          )
        ],
      ),
    );
  }
}
