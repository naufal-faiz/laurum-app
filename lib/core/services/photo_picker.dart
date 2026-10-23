abstract class PhotoPicker {
  Future<String?> pickPhoto();
}

class FakePhotoPicker implements PhotoPicker {
  FakePhotoPicker({this.defaultPath});

  final String? defaultPath;
  int pickPhotoCallCount = 0;

  @override
  Future<String?> pickPhoto() async {
    pickPhotoCallCount++;
    return defaultPath;
  }
}
