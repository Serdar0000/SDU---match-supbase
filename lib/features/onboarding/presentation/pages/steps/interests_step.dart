import 'package:flutter/material.dart';

class InterestsStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final List<String> interests = [
  'AI', 'Flutter', 'Mobile', 'Web', 'Design', 'UI/UX',
  'Стартапы', 'Финансы', 'Крипта', 'Маркетинг',
  'Спорт', 'Зал', 'Бег', 'Йога', 'Танцы',
  'Музыка', 'Кино', 'Аниме', 'Книги', 'Игры',
  'Путешествия', 'Кофе', 'Фотография', 'Искусство',
  'Волонтёрство', 'Дебаты', 'Шахматы', 'Кулинария',
  'Технологии', 'Чтение'
];

 InterestsStep({
    required this.onNext,
    required this.onBack,
    Key? key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual interests selection UI
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Выбери свои интересы',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          // Placeholder for interests selection
          Wrap(
            spacing: 8,
            children: interests
      .map((interest) => Chip(
            label: Text(interest),
          ))
      .toList(),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onBack,
                child: Text('Назад'),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: Text('Далее'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
