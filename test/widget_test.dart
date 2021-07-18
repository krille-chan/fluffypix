import 'package:fluffypix/model/fluffy_pix.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluffypix/main.dart';

import 'mock_http.dart';

void main() {
  testWidgets('Test if the app starts', (WidgetTester tester) async {
    final fluffyPix = FluffyPix(httpClient: MockHttpClient());
    await fluffyPix.initialized;
    await tester.pumpWidget(FluffyPixApp(fluffyPix: fluffyPix));
  });
}
