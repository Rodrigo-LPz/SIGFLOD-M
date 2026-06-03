// Representa una pregunta concreta asociada a un bloque de Comprensión.
class ComprehensionQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  const ComprehensionQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  ComprehensionQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctOptionIndex,
  }) {
    return ComprehensionQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory ComprehensionQuestion.fromMap(Map<String, dynamic> map) {
    return ComprehensionQuestion(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? const []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
    );
  }
}

// Representa un bloque completo de Comprensión: un texto y sus preguntas asociadas.
class ComprehensionBlock {
  final String id;
  final String text;
  final String? audioUrl;
  final List<ComprehensionQuestion> questions;

  const ComprehensionBlock({
    required this.id,
    required this.text,
    this.audioUrl,
    required this.questions,
  });

  ComprehensionBlock copyWith({
    String? id,
    String? text,
    String? audioUrl,
    List<ComprehensionQuestion>? questions,
    bool clearAudio = false,
  }) {
    return ComprehensionBlock(
      id: id ?? this.id,
      text: text ?? this.text,
      audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl),
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'audioUrl': audioUrl,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  factory ComprehensionBlock.fromMap(Map<String, dynamic> map) {
    return ComprehensionBlock(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      audioUrl: map['audioUrl'] as String?,
      questions: ((map['questions'] as List?) ?? const [])
          .map(
            (q) => ComprehensionQuestion.fromMap(Map<String, dynamic>.from(q)),
          )
          .toList(),
    );
  }
}
