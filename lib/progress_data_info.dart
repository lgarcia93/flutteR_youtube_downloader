enum DownloadStatus {
  started,
  finished,
}

class ProgressDataInfo {
  final DownloadStatus status;
  final String downloadLink;
  final double progress;

  ProgressDataInfo({
    required this.status,
    required this.downloadLink,
    required this.progress,
  });
}
