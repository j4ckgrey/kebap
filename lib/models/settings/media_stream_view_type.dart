enum MediaStreamViewType {
  dropdown,
  carousel;

  String get label {
    switch (this) {
      case MediaStreamViewType.dropdown:
        return 'Dropdown';
      case MediaStreamViewType.carousel:
        return 'Carousel';
    }
  }
}
