enum Background {
  blank,
  blurHash,
}

extension BackgroundExt on Background {
  String toStringName() {
    if (this == Background.blurHash) {
      return 'blurHash';
    }
    return 'blank';
  }
}
