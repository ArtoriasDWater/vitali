import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/ask_medication_question_usecase.dart';

@lazySingleton
class ChatProvider extends ChangeNotifier {
  final AskMedicationQuestionUseCase _askMedicationQuestionUseCase;

  ChatProvider(this._askMedicationQuestionUseCase);

  final List<ChatMessage> _messages = [
    ChatMessage.assistant(
      'Hola, soy tu asistente de medicamentos. Puedes preguntarme sobre dosis, horarios, efectos secundarios o interacciones.',
    ),
  ];

  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(
    String question, {
    List<String>? medicationNames,
    String? userId,
  }) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;

    _messages.add(ChatMessage.user(trimmed));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final reply = await _askMedicationQuestionUseCase(
        trimmed,
        medicationNames: medicationNames,
        userId: userId,
      );

      _messages.add(ChatMessage.assistant(reply));
    } catch (e) {
      _messages.add(
        ChatMessage.assistant(
          'No pude responder tu pregunta en este momento. Intenta de nuevo con otra consulta.',
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
