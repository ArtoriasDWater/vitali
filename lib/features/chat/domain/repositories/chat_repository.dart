abstract class ChatRepository {
  Future<String> askMedicationQuestion(
    String question, {
    List<String>? medicationNames,
    String? userId,
  });
}
