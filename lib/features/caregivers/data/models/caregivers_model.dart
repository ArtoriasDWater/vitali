import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/caregivers.dart';

class CaregiversModel extends Caregiver {
  CaregiversModel({
    required super.uid,
    required super.userId,
    required super.name,
    required super.email,
    required super.phone,
    required super.relationship,
    super.isPrimary,
    super.active,
    super.createdAt,
  });

  factory CaregiversModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiversModel(
      uid: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      relationship: data['relationship'] ?? '',
      isPrimary: data['isPrimary'] ?? false,
      active: data['active'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Caregiver toEntity() {
    return Caregiver(
      uid: uid,
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      relationship: relationship,
      isPrimary: isPrimary,
      active: active,
      createdAt: createdAt,
    );
  }

  factory CaregiversModel.fromEntity(Caregiver caregiver) {
    return CaregiversModel(
      uid: caregiver.uid,
      userId: caregiver.userId,
      name: caregiver.name,
      email: caregiver.email,
      phone: caregiver.phone,
      relationship: caregiver.relationship,
      isPrimary: caregiver.isPrimary,
      active: caregiver.active,
      createdAt: caregiver.createdAt,
    );
  }
}
