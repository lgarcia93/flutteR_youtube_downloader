enum ClientMessageeType {
  startDownload,
}

class StartDownloadMessage {
  final String link;
  final String qualityLabel;

  StartDownloadMessage({
    required this.link,
    required this.qualityLabel,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'link': link,
      'qualityLabel': qualityLabel,
    };
  }
}

class ClientMessage {
  final ClientMessageeType messageeType;
  final String messageBody;

  ClientMessage({
    required this.messageeType,
    required this.messageBody,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'messageBody': messageBody,
      'messageType': messageeType.name,
    };
  }
}
