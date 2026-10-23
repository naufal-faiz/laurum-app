abstract class PhotoPicker {
  Future<String?> pickPhoto();
}

class FakePhotoPicker implements PhotoPicker {
  FakePhotoPicker({this.defaultPath = 'assets/photos/sample_expense.jpg'});

  final String? defaultPath;
  int pickPhotoCallCount = 0;

  @override
  Future<String?> pickPhoto() async {
    pickPhotoCallCount++;
    return defaultPath;
  }
}
