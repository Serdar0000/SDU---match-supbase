import '../../domain/entities/user_profile.dart';

abstract class MockSwipeDataSource {
  List<UserProfile> getMockProfiles();
}

class MockSwipeDataSourceImpl implements MockSwipeDataSource {
  // Заполняем мок-данные через модельку
  final List<UserProfile> _mockProfiles = [
    const UserProfile(
      id: '1',
      name: 'Айза',
      age: 20,
      faculty: 'School of Engineering',
      yearOfStudy: 2,
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=800&auto=format&fit=crop',
      interests: ['AI', 'Кофе', 'Аниме'],
      bio: 'Ищу напарника для хакатона. Люблю кодить по ночам ☕️',
    ),
    const UserProfile(
      id: '2',
      name: 'Данияр',
      age: 21,
      faculty: 'School of Business',
      yearOfStudy: 3,
      imageUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=800&auto=format&fit=crop',
      interests: ['Стартапы', 'Спорт', 'Книги'],
      bio: 'Делаю свой стартап. Давай обсудим идеи за чашкой кофе.',
    ),
    const UserProfile(
      id: '3',
      name: 'Мадина',
      age: 19,
      faculty: 'School of Law',
      yearOfStudy: 1,
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=800&auto=format&fit=crop',
      interests: ['Дебаты', 'Путешествия', 'Музыка'],
      bio: 'Первокурсница. Ищу друзей, чтобы вместе изучать кампус!',
    ),
    const UserProfile(
      id: '4',
      name: 'Алихан',
      age: 22,
      faculty: 'School of Engineering',
      yearOfStudy: 4,
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=800&auto=format&fit=crop',
      interests: ['Киберспорт', 'Математика', 'Игры'],
      bio: 'Пишу дипломку. Если ты тоже, давай страдать вместе 😅',
    ),
  ];

  @override
  List<UserProfile> getMockProfiles() {
    return _mockProfiles;
  }
}
