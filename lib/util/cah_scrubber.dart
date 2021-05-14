class CahScrubber {
  CahScrubber._();

  static String scrub(String name) {
    return name.replaceAll("CAH : ", "")
        .replaceAll("CAH: ", "")
        .replaceAll("CAH ", "")
        .replaceAll("Cards Against Humanity", "")
        .trim();
  }
}
