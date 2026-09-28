import 'dart:io';
import '../models/medication_model.dart';

abstract class RecipeOcrDataSource {
  Future<MedicationModel> processRecipeImage(File imageFile, String userId);
}
