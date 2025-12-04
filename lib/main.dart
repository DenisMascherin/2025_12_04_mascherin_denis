import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Review {
  final String nome;
  final String? dettagli;
  final int rating;

  Review({
    required this.nome,
    this.dettagli,
    required this.rating,
  }) : assert(rating >= 1 && rating <= 5);

  factory Review.fromData(Map<String, Object?> payload) {
    return Review(
      nome: payload['nome'] as String,
      dettagli: payload['dettagli'] as String?,
      rating: payload['valore'] as int,
    );
  }

  Map<String, Object?> toFormPayload() {
    return {
      'nome': nome,
      'dettagli': dettagli,
      'valore': rating,
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFork Ristoranti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Review> _reviews = [
    Review(nome: 'Bar Pasticceria Lella', dettagli: 'Siamo stati benissimo, cibo semplice ma buonissimo.', rating: 5),
    Review(nome: 'Pizzeria da Gino', dettagli: 'Ottimo per la colazione al volo, personale gentile.', rating: 3),
  ];

  void _handleNewEntry() async {
    final result = await Navigator.of(context).push<Map<String, Object?>>(
      MaterialPageRoute(
        builder: (ctx) => const ReviewFormScreen(),
      ),
    );

    if (result != null) {
      final newReview = Review.fromData(result);
      setState(() {
        _reviews.insert(0, newReview);
      });
    }
  }

  void _handleEdit(Review reviewToEdit, int index) async {
    final result = await Navigator.of(context).push<Map<String, Object?>>(
      MaterialPageRoute(
        builder: (ctx) => ReviewFormScreen(initialReview: reviewToEdit),
      ),
    );

    if (result != null) {
      final updatedReview = Review.fromData(result);
      setState(() {
        _reviews[index] = updatedReview;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fork App'),
        backgroundColor: Colors.blue, 
        foregroundColor: Colors.white,
      ),
      body: _reviews.isEmpty
          ? const Center(child: Text('Aggiungi la tua prima recensione!'))
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (ctx, index) {
                final review = _reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.nome, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87)),
                              const SizedBox(height: 4),
                              review.dettagli != null && review.dettagli!.isNotEmpty
                                  ? Text(review.dettagli!)
                                  : const Text('Nessun dettaglio.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                              const SizedBox(height: 8), 
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < review.rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_note, size: 28, color: Colors.blue),
                          onPressed: () => _handleEdit(review, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNewEntry,
        tooltip: 'Nuovo Locale',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}

class ReviewFormScreen extends StatelessWidget {
  final Review? initialReview;

  const ReviewFormScreen({super.key, this.initialReview});

  FormGroup _creaLaForm() {
    final initialValues = initialReview?.toFormPayload() ?? {'nome': '', 'dettagli': '', 'valore': 5};

    return fb.group({
      'nome': FormControl<String>(
        value: initialValues['nome'] as String,
        validators: [Validators.required, Validators.minLength(2), Validators.maxLength(35)],
      ),
      'dettagli': FormControl<String>(
        value: initialValues['dettagli'] as String?,
        validators: [Validators.maxLength(180)],
      ),
      'valore': FormControl<int>(
        value: initialValues['valore'] as int,
        validators: [
          Validators.required,
          Validators.min(1),
          Validators.max(5),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(initialReview == null ? 'Nuova Recensione' : 'Modifica Dettagli'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ReactiveFormBuilder(
          form: _creaLaForm,
          builder: (context, form, child) {
            final valoreControl = form.control('valore'); 
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ReactiveTextField<String>(
                  formControlName: 'nome',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nome Locale ',
                    hintText: 'Pizzeria, Caffetteria, etc.',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Nome obbligatorio.',
                    ValidationMessage.maxLength: (error) => 'Troppo lungo (max 35).',
                    ValidationMessage.minLength: (error) => 'Nome troppo corto (min 2).',
                  },
                ),
                const SizedBox(height: 20.0),
                ReactiveTextField<String>(
                  formControlName: 'dettagli',
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'La Tua Recensione (Opzionale)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validationMessages: {
                    ValidationMessage.maxLength: (error) => 'Troppo lungo, massimo 180 caratteri.',
                  },
                ),
                const SizedBox(height: 25.0),
                
                Text('Valutazione (1 a 5):', style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),

                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    final currentRating = form.control('valore').value?.round() ?? 1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        final ratingValue = index + 1;
                        final isSelected = ratingValue == currentRating;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: ratingValue == 1 || ratingValue == 5 ? 0 : 4),
                            child: ElevatedButton(
                              onPressed: () {
                                form.control('valore').updateValue(ratingValue);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? Colors.blue : Colors.blueGrey.shade100,
                                foregroundColor: isSelected ? Colors.white : Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: isSelected ? 4 : 1,
                              ),
                              child: Text('$ratingValue', style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    return ElevatedButton.icon(
                      onPressed: form.valid
                          ? () {
                              Navigator.of(context).pop(form.value);
                            }
                          : null,
                      icon: const Icon(Icons.send_time_extension),
                      label: Text(initialReview == null ? 'Registra recensione' : 'Aggiorna'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}