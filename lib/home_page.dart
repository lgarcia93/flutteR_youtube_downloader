import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:youtube_downloader_flutter/api_controller.dart';
import 'package:youtube_downloader_flutter/video_info.dart';
import 'package:youtube_downloader_flutter/video_info_model.dart';

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

  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:5000/ws'),
    );

    channel.stream.listen((event) {
      print(event);
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
                            videoInfo = await apiController
                                .fetchVideoInfo(_controller.text);

                            setState(() {
                              isLoading = false;
                              videoInfo;
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
                    onDownloadPressed: (videoInfo) {
                      var finalLink =
                          'http://localhost:5000/download_video?link=${videoInfo.link}';

                      html.AnchorElement anchorElement = html.AnchorElement(
                        href: finalLink,
                      );
                      anchorElement.target = "_blank";
                      anchorElement.download = finalLink;
                      anchorElement.click();
                    },
                    videoInfo: videoInfo,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
