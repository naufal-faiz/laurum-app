abstract class ExternalLauncher {
  Future<bool> launchWhatsApp({required String phone, required String message});
  Future<bool> launchUrl(String url);
}

class FakeExternalLauncher implements ExternalLauncher {
  final List<({String phone, String message})> whatsAppCalls = [];
  final List<String> launchedUrls = [];
  bool shouldSucceed = true;

  @override
  Future<bool> launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    whatsAppCalls.add((phone: phone, message: message));
    return shouldSucceed;
  }

  @override
  Future<bool> launchUrl(String url) async {
    launchedUrls.add(url);
    return shouldSucceed;
  }
}
