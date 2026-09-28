import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  Future<String> _getLocalFallback(
    String question, {
    List<String>? medicationNames,
  }) async {
    final normalized = question.trim();
    final lower = normalized.toLowerCase();
    final medicines = (medicationNames ?? const <String>[])
        .map((name) => name.toLowerCase())
        .toList();

    if (normalized.isEmpty) {
      return 'Escribe una pregunta sobre tus medicamentos.';
    }

    final medicationContext = medicines.isNotEmpty
        ? 'Estás consultando sobre: ${medicines.join(', ')}.'
        : 'No tengo un medicamento concreto en contexto.';

    if (lower.contains('dosis') ||
        lower.contains('dose') ||
        lower.contains('cuánto')) {
      if (medicines.any((name) => lower.contains(name))) {
        return 'La dosis correcta debe seguir la indicación de tu médico o la receta. En general, toma solo la cantidad especificada en la caja o en la receta y no cambies la dosis sin consultar al profesional.';
      }
      return 'La dosis depende del medicamento, la edad, el peso y la indicación médica. Lo más seguro es seguir la receta y no ajustar la dosis por tu cuenta.';
    }

    if (lower.contains('cuando') ||
        lower.contains('horario') ||
        lower.contains('hora')) {
      return 'Lo ideal es tomarlos en los horarios indicados por la receta o por tu profesional de salud. Si se te olvidó una dosis, no tomes dos de golpe; sigue el horario siguiente y consulta a tu médico si tienes dudas.';
    }

    if (lower.contains('olvid') ||
        lower.contains('pasé') ||
        lower.contains('salté')) {
      return 'Si te olvidaste una dosis, toma la siguiente según el horario habitual. No tomes una dosis extra para “compensar” una que se te pasó, salvo que tu médico te lo haya indicado específicamente.';
    }

    if (lower.contains('efecto secundario') ||
        lower.contains('mareo') ||
        lower.contains('náusea') ||
        lower.contains('vómito') ||
        lower.contains('dolor')) {
      return 'Si aparecen efectos secundarios como mareo, náuseas, dolor fuerte o reacción rara, deja de tomarlo y consulta a tu profesional de salud o a una farmacia. En caso de emergencia, busca atención inmediata.';
    }

    if (lower.contains('interacc') ||
        lower.contains('alcohol') ||
        lower.contains('otro medicamento') ||
        lower.contains('con otros')) {
      return 'Algunos medicamentos interactúan entre sí o con alcohol, suplementos o analgésicos. Consulta siempre el prospecto o pregunta a tu médico antes de combinar medicamentos.';
    }

    if (lower.contains('paracetamol') ||
        lower.contains('acetaminofén') ||
        lower.contains('tylenol')) {
      return 'El paracetamol suele usarse para dolor o fiebre. No excedas la dosis recomendada en el envase o la receta, y evita mezclarlo con otros medicamentos que contengan acetaminofén.';
    }

    if (lower.contains('ibuprofeno') ||
        lower.contains('advil') ||
        lower.contains('nurofen')) {
      return 'El ibuprofeno puede ayudar con dolor o inflamación, pero puede irritar el estómago. Si tienes gastritis, úlceras o estás tomando otros medicamentos, consulta antes de usarlo.';
    }

    if (lower.contains('antibiótico') || lower.contains('antibiotico')) {
      return 'Los antibióticos deben tomarse completos según la indicación médica aunque te sientas mejor antes. Si aparece alergia, urticaria o dificultad para respirar, consulta de inmediato.';
    }

    if (lower.contains('alergia') ||
        lower.contains('picazón') ||
        lower.contains('hinchazón')) {
      return 'Si tienes alergia, picazón, urticaria o hinchazón, suspende el medicamento y consulta a tu médico o farmacia. En caso de dificultades respiratorias, busca atención urgente.';
    }

    if (lower.contains('ayuda') ||
        lower.contains('hola') ||
        lower.contains('qué puedes hacer')) {
      return 'Puedo ayudarte con dudas comunes sobre dosis, horarios, efectos secundarios, alergias e interacciones. Pregúntame por un medicamento o por una situación concreta.';
    }

    return 'Puedo responder dudas frecuentes sobre medicamentos: dosis, horarios, efectos secundarios, alergias e interacciones. $medicationContext También puedes preguntarme por un medicamento concreto como paracetamol, ibuprofeno o antibióticos.';
  }

  @override
  Future<String> askMedicationQuestion(
    String question, {
    List<String>? medicationNames,
    String? userId,
  }) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return 'Escribe una pregunta sobre tus medicamentos.';
    }

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'askMedicationQuestion',
      );

      final response = await callable.call<Map<String, dynamic>>({
        'question': trimmed,
        'medicationNames': medicationNames ?? const <String>[],
        'userId': userId ?? '',
      });

      final answer = response.data['answer'] as String?;
      if (answer != null && answer.trim().isNotEmpty) {
        return answer.trim();
      }

      return await _getLocalFallback(trimmed, medicationNames: medicationNames);
    } catch (_) {
      return await _getLocalFallback(trimmed, medicationNames: medicationNames);
    }
  }
}
