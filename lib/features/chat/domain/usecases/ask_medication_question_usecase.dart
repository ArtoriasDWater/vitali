import 'package:injectable/injectable.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class AskMedicationQuestionUseCase {
  final ChatRepository _chatRepository;

  AskMedicationQuestionUseCase(this._chatRepository);

  Future<String> call(
    String question, {
    List<String>? medicationNames,
    String? userId,
  }) async {
    if (question.trim().isEmpty) {
      return 'Escribe una pregunta sobre tus medicamentos para que pueda ayudarte.';
    }

    return _chatRepository.askMedicationQuestion(
      question,
      medicationNames: medicationNames,
      userId: userId,
    );
  }
}
