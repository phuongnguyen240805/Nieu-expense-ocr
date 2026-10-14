import 'dart:js_interop';

@JS('expenseOcr.recognize')
external JSPromise<JSString> _recognize(JSString image);

/// Browser OCR runs locally in a Tesseract worker; receipt images are not uploaded.
class OcrService {
  Future<String> recognizeText(String imagePath) async {
    try {
      return (await _recognize(imagePath.toJS).toDart).toDart;
    } catch (_) {
      throw Exception(
        'Không thể nhận diện ảnh. Kiểm tra kết nối khi tải bộ nhận diện lần đầu và thử lại.',
      );
    }
  }

  // The browser bridge terminates its worker after each recognition.
  void dispose() {}
}
