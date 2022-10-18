import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:youtube_downloader_flutter/api_controller.dart';
import 'package:youtube_downloader_flutter/progress_data_info.dart';
import 'package:youtube_downloader_flutter/video_info.dart';
import 'package:youtube_downloader_flutter/video_info_model.dart';
import 'package:youtube_downloader_flutter/websocket/client_messages.dart';
import 'package:youtube_downloader_flutter/websocket/server_messages.dart';

/*
* flutter run -d chrome --web-renderer html // to run the app

flutter build web --web-renderer html --release // to generate a production build
* */
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiController apiController = ApiController();
  final TextEditingController _controller = TextEditingController();

  bool isLoading = false;
  List<VideoInfoModel> videoInfo = [];

  Map<String, ProgressDataInfo> progressMap = {};

  late final WebSocketChannel channel;
  String sessionId = "";
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:5000/ws'),
    );

    channel.stream.listen((event) {
      var serverMessage = ServerMessage.fromMap(jsonDecode(event));

      switch (serverMessage.messageType) {
        case ServerMessageType.sessionCreated:
          var sessionCreated = OnSessionCreatedMessage.fromMap(
            jsonDecode(
              serverMessage.messageBody,
            ),
          );

          setState(() {
            sessionId = sessionCreated.sessionId.toString();
          });
          break;
        case ServerMessageType.downloadStarted:
          var downloadStarted = OnDownloadStartedMessage.fromMap(
            jsonDecode(
              serverMessage.messageBody,
            ),
          );

          break;
        case ServerMessageType.downloadProgress:
          var downloadProgress = OnDownloadProgressMessage.fromMap(
            jsonDecode(
              serverMessage.messageBody,
            ),
          );

          if (progressMap[downloadProgress.qualityLabel]?.status ==
              DownloadStatus.finished) {
            break;
          }

          setState(() {
            progressMap[downloadProgress.qualityLabel] = ProgressDataInfo(
              status: DownloadStatus.started,
              downloadLink: '',
              progress: downloadProgress.progress,
            );
          });
          break;
        case ServerMessageType.downloadFinished:
          var downloadFinished = OnDownloadFinishedMessage.fromMap(
            jsonDecode(
              serverMessage.messageBody,
            ),
          );

          setState(() {
            progressMap[downloadFinished.qualityLabel] = ProgressDataInfo(
              status: DownloadStatus.finished,
              downloadLink: downloadFinished.downloadLink,
              progress: 1.0,
            );

            progressMap = <String, ProgressDataInfo>{}..addAll(progressMap);

            print('Download finished');
            print(downloadFinished.qualityLabel);
            print(progressMap[downloadFinished.qualityLabel]?.downloadLink);
            print(progressMap[downloadFinished.qualityLabel]?.status);
          });

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              Text(progress.toString()),
              const Text(
                'Youtube downloader',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 800,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Form(
                        child: SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                      height: 0,
                    ),
                    if (isLoading) const CircularProgressIndicator(),
                    if (!isLoading)
                      Container(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            videoInfo = await apiController.fetchVideoInfo(
                              link: _controller.text,
                            );

                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: const Text('Search'),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              if (videoInfo.isNotEmpty)
                Expanded(
                  child: VideoInfo(
                    progressMap: progressMap,
                    onDownloadPressed: (videoInfo) async {
                      var startDownladMessage = StartDownloadMessage(
                        link: videoInfo.link,
                        qualityLabel: videoInfo.qualityLabel,
                      );

                      var message = ClientMessage(
                        messageeType: ClientMessageeType.startDownload,
                        messageBody: jsonEncode(startDownladMessage.toJson()),
                      );

                      channel.sink.add(jsonEncode(message.toJson()));
                    },
                    videoInfo: videoInfo,
                    onGetVideoPressed: (downloadLink) {
                      if (downloadLink.isEmpty) {
                        return;
                      }

                      var finalLink =
                          'http://localhost:5000/download_video?link=$downloadLink&sessionId=$sessionId';
                      html.AnchorElement(href: finalLink)
                        ..setAttribute('download', 'downloaded_file_name.pdf')
                        ..click();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
