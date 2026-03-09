import 'package:flutter/material.dart';

class InterestsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<List<String>> onInterestsSelected;
  final List<String> initialSelected;

  const InterestsStep({
    required this.onNext,
    required this.onBack,
    required this.onInterestsSelected,
    this.initialSelected = const [],
    super.key,
  });

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  final List<String> interests = [
    'AI', 'Flutter', 'Mobile', 'Web', 'Design', 'UI/UX',
    'Стартапы', 'Финансы', 'Крипта', 'Маркетинг',
    'Спорт', 'Зал', 'Бег', 'Йога', 'Танцы',
    'Музыка', 'Кино', 'Аниме', 'Книги', 'Игры',
    'Путешествия', 'Кофе', 'Фотография', 'Искусство',
    'Волонтёрство', 'Дебаты', 'Шахматы', 'Кулинария',
    'Технологии', 'Чтение'
  ];

  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initialSelected);
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selected.contains(interest)) {
        _selected.remove(interest);
      } else {
        _selected.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Выбери свои интересы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: interests.map((interest) {
              final selected = _selected.contains(interest);
              return ChoiceChip(
                label: Text(interest),
                selected: selected,
                onSelected: (_) => _toggleInterest(interest),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: widget.onBack,
                child: const Text('Назад'),
              ),
              ElevatedButton(
                onPressed: _selected.isNotEmpty
                    ? () {
                        widget.onInterestsSelected(_selected.toList());
                        widget.onNext();
                      }
                    : null,
                child: const Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
