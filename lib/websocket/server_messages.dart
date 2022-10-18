enum ServerMessageType {
  sessionCreated,
  downloadStarted,
  downloadProgress,
  downloadFinished,
}

class OnSessionCreatedMessage {
  final String sessionId;

  OnSessionCreatedMessage({
    required this.sessionId,
  });

  factory OnSessionCreatedMessage.fromMap(Map<String, dynamic> map) {
    return OnSessionCreatedMessage(sessionId: '');
  }
}

class OnDownloadStartedMessage {
  final String videoLink;
  final String qualityLabel;

  OnDownloadStartedMessage({
    required this.videoLink,
    required this.qualityLabel,
  });

  factory OnDownloadStartedMessage.fromMap(Map<String, dynamic> map) {
    return OnDownloadStartedMessage(
      videoLink: map['videoLink'],
      qualityLabel: map['qualityLabel'],
    );
  }
}

class OnDownloadProgressMessage {
  final double progress;
  final String videoLink;
  final String qualityLabel;

  OnDownloadProgressMessage({
    required this.progress,
    required this.videoLink,
    required this.qualityLabel,
  });

  factory OnDownloadProgressMessage.fromMap(Map<String, dynamic> map) {
    return OnDownloadProgressMessage(
      progress: map['progress'],
      videoLink: map['videoLink'],
      qualityLabel: map['qualityLabel'],
    );
  }
}

class OnDownloadFinishedMessage {
  final String videoLink;
  final String qualityLabel;
  final String downloadLink;

  OnDownloadFinishedMessage({
    required this.videoLink,
    required this.qualityLabel,
    required this.downloadLink,
  });

  factory OnDownloadFinishedMessage.fromMap(Map<String, dynamic> map) {
    return OnDownloadFinishedMessage(
      videoLink: map['videoLink'],
      qualityLabel: map['qualityLabel'],
      downloadLink: map['downloadLink'],
    );
  }
}

class ServerMessage {
  final ServerMessageType messageType;
  final String messageBody;

  ServerMessage({
    required this.messageType,
    required this.messageBody,
  });

  factory ServerMessage.fromMap(Map<String, dynamic> map) {
    return ServerMessage(
      messageType: ServerMessageType.values.byName(
        map['messageType'],
      ),
      messageBody: map['messageBody'],
    );
  }
}
