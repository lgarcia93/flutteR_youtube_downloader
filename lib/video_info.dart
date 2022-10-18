import 'package:flutter/material.dart';
import 'package:youtube_downloader_flutter/progress_data_info.dart';
import 'package:youtube_downloader_flutter/video_info_model.dart';

class VideoInfo extends StatelessWidget {
  final List<VideoInfoModel> videoInfo;
  final void Function(VideoInfoModel) onDownloadPressed;
  final void Function(String) onGetVideoPressed;

  final Map<String, ProgressDataInfo> progressMap;

  const VideoInfo({
    Key? key,
    required this.videoInfo,
    required this.onDownloadPressed,
    required this.progressMap,
    required this.onGetVideoPressed,
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
            children: videoInfo.map((e) {
              if (progressMap[e.qualityLabel]?.status ==
                  DownloadStatus.finished) {
                print(progressMap[e.qualityLabel]?.downloadLink);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  if (progressMap[e.qualityLabel] == null)
                    Container(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          onDownloadPressed(e);
                        },
                        child: const Text('Download'),
                      ),
                    ),
                  if (progressMap[e.qualityLabel]?.status ==
                      DownloadStatus.started)
                    SizedBox(
                      width: 130,
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        color: Colors.green,
                        backgroundColor: Colors.black,
                        value: progressMap[e.qualityLabel]?.progress ?? 0,
                      ),
                    ),
                  if (progressMap[e.qualityLabel]?.status ==
                      DownloadStatus.finished)
                    SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          onGetVideoPressed(
                              progressMap[e.qualityLabel]?.downloadLink ?? '');
                        },
                        child: const Text('Get the video'),
                      ),
                    ),
                ],
              );
            }).fold(
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
