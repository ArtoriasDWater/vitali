import '../../domain/entities/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationModel extends Medication {
  MedicationModel({
    required super.uid,
    required super.name,
    required super.numberOfPills,
    required super.frequency,
    required super.observations,
    required super.userId,
  });

  factory MedicationModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicationModel(
      uid: doc.id,
      name: data['name'] ?? '',
      numberOfPills: data['numberOfPills'] ?? 0,
      frequency: data['frequency'] ?? '',
      observations: data['observations'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  /// Convierte el modelo a un Map para enviar a la colección de Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'numberOfPills': numberOfPills,
      'frequency': frequency,
      'observations': observations,
      'userId': userId,
    };
  }

  /// Mapea de la capa de datos (Model) a la entidad de dominio (Entity)
  Medication toEntity() {
    return Medication(
      uid: uid,
      name: name,
      numberOfPills: numberOfPills,
      frequency: frequency,
      observations: observations,
      userId: userId,
    );
  }

  /// Permite crear una instancia de Model a partir de una Entity
  factory MedicationModel.fromEntity(Medication medication) {
    return MedicationModel(
      uid: medication.uid,
      name: medication.name,
      numberOfPills: medication.numberOfPills,
      frequency: medication.frequency,
      observations: medication.observations,
      userId: medication.userId,
    );
  }
}
