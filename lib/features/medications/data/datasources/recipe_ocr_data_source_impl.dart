import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../models/medication_model.dart';
import 'recipe_ocr_data_source.dart';

@LazySingleton(as: RecipeOcrDataSource)
class RecipeOcrDataSourceImpl implements RecipeOcrDataSource {
  @override
  Future<MedicationModel> processRecipeImage(
    File imageFile,
    String userId,
  ) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      // Reconocimiento de texto en el dispositivo vía ML Kit
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      final String rawText = recognizedText.text;

      if (rawText.trim().isEmpty) {
        throw const AppException(
          'No se pudo detectar texto inteligible en la receta.',
        );
      }

      // Procesamiento heurístico inicial del texto extraído
      final parsedData = _parseRecipeText(rawText);

      return MedicationModel(
        uid: '', // Se asignará cuando el usuario confirme y guarde en Firestore
        name: parsedData['name'] ?? '',
        numberOfPills: parsedData['numberOfPills'] ?? 1,
        frequency: parsedData['frequency'] ?? '',
        observations: rawText, // Guardamos el texto crudo para revisión
        userId: userId,
      );
    } catch (e) {
      throw AppException('Error al procesar la imagen de la receta: $e');
    } finally {
      // Liberación de memoria del procesador nativo de ML Kit
      textRecognizer.close();
    }
  }

  /// Método auxiliar con reglas para extraer campos clave del texto escaneado
  Map<String, dynamic> _parseRecipeText(String text) {
    final lines = text.split('\n');
    String detectedName = '';
    String detectedFrequency = '';
    int detectedPills = 1;

    if (lines.isNotEmpty) {
      // Asumimos que la primera línea relevante contiene el nombre del medicamento
      detectedName = lines.firstWhere(
        (line) => line.trim().length > 3,
        orElse: () => '',
      );
    }

    // Regla simple para detectar patrones de frecuencia (ej. "cada 8 horas", "8h", "cada 12 hrs")
    final frequencyRegExp = RegExp(
      r'(cada\s*\d+\s*(horas|hrs|h)|\d+\s*(horas|hrs|h))',
      caseSensitive: false,
    );
    final frequencyMatch = frequencyRegExp.firstMatch(text);
    if (frequencyMatch != null) {
      detectedFrequency = frequencyMatch.group(0) ?? '';
    }

    return {
      'name': detectedName,
      'numberOfPills': detectedPills,
      'frequency': detectedFrequency,
    };
  }
}
