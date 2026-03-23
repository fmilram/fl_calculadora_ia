import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:math_expressions/math_expressions.dart';

class IAService {
  final textRecognizer = TextRecognizer();

  Future<String> reconocerTexto(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    return recognizedText.text;
  }

  String resolverOperacion(String texto) {
    texto = texto.replaceAll(' ', '');
    texto = texto.replaceAll('\n', '');
    texto = texto.replaceAll('x', '*');
    texto = texto.replaceAll('X', '*');
    texto = texto.replaceAll('.', '*');
    texto = texto.replaceAll('÷', '/');
    texto = texto.replaceAll('O', '0');
    texto = texto.replaceAll('l', '1');
    texto = texto.replaceAll(RegExp(r'[^0-9+\-*/()]'), '');

    try {
      final parser = GrammarParser();
      final expression = parser.parse(texto);
      final context = ContextModel();
      final evaluator = RealEvaluator(context);
      final result = evaluator.evaluate(expression);

      return result.toString();
    } catch (e) {
      return 'Error al calcular';
    }
  }

  void dispose() {
    textRecognizer.close();
  }
}
