import '../../features/swipe/domain/entities/user_profile.dart';
import '../../features/chat/domain/entities/chat_message.dart';

/// Сервис для моковых данных - позволяет тестировать UI без подключения к Supabase
class MockDataService {
  // ID текущего пользователя для тестирования
  static const String currentUserId = 'mock-user-001';

  // Моковый профиль текущего пользователя
  UserProfile get currentUserProfile => UserProfile(
        id: currentUserId,
        name: 'Тестовый Юзер',
        age: 20,
        faculty: 'Engineering',
        yearOfStudy: 2,
        imageUrl: 'https://i.pravatar.cc/400?img=12',
        interests: ['Программирование', 'Кофе', 'Аниме'],
        bio: 'Тестирую UI/UX 🚀',
        email: '240103001@sdu.edu.kz',
        gender: 'male',
        lookingFor: 'all',
        starsGiven: 5, // 🌟 Раздал 5 супер-лайков
      );

  // Список моковых профилей для свайпов
  List<UserProfile> get swipeProfiles => [
        UserProfile(
          id: 'mock-001',
          name: 'Айгерим',
          age: 19,
          faculty: 'Business School',
          yearOfStudy: 1,
          imageUrl: 'https://i.pravatar.cc/400?img=5',
          interests: ['Маркетинг', 'Йога', 'Путешествия'],
          bio: 'Люблю кофе и новые знакомства ☕️',
          email: '240103002@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'male',
        ),
        UserProfile(
          id: 'mock-002',
          name: 'Данияр',
          age: 21,
          faculty: 'Engineering',
          yearOfStudy: 3,
          imageUrl: 'https://i.pravatar.cc/400?img=8',
          interests: ['AI/ML', 'Баскетбол', 'Шахматы'],
          bio: 'Data Science энтузиаст, ищу единомышленников',
          email: '220103001@sdu.edu.kz',
          gender: 'male',
          lookingFor: 'female',
        ),
        UserProfile(
          id: 'mock-003',
          name: 'Камила',
          age: 20,
          faculty: 'Humanities',
          yearOfStudy: 2,
          imageUrl: 'https://i.pravatar.cc/400?img=9',
          interests: ['Искусство', 'Книги', 'Музыка'],
          bio: 'Artistic soul looking for deep conversations 🎨',
          email: '230103015@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'all',
        ),
        UserProfile(
          id: 'mock-004',
          name: 'Нурлан',
          age: 22,
          faculty: 'Sciences',
          yearOfStudy: 4,
          imageUrl: 'https://i.pravatar.cc/400?img=13',
          interests: ['Физика', 'Фотография', 'Хайкинг'],
          bio: 'Physics nerd, coffee addict, nature lover',
          email: '210103042@sdu.edu.kz',
          gender: 'male',
          lookingFor: 'female',
        ),
        UserProfile(
          id: 'mock-005',
          name: 'Сауле',
          age: 19,
          faculty: 'Engineering',
          yearOfStudy: 1,
          imageUrl: 'https://i.pravatar.cc/400?img=10',
          interests: ['Программирование', 'K-Pop', 'Аниме'],
          bio: 'CS freshman, anime lover, let\'s code together! 💻',
          email: '240103078@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'all',
        ),
        UserProfile(
          id: 'mock-006',
          name: 'Арман',
          age: 21,
          faculty: 'Business School',
          yearOfStudy: 3,
          imageUrl: 'https://i.pravatar.cc/400?img=15',
          interests: ['Стартапы', 'Футбол', 'Инвестиции'],
          bio: 'Future entrepreneur, always looking for opportunities',
          email: '220103099@sdu.edu.kz',
          gender: 'male',
          lookingFor: 'female',
        ),
        UserProfile(
          id: 'mock-007',
          name: 'Диана',
          age: 20,
          faculty: 'Sciences',
          yearOfStudy: 2,
          imageUrl: 'https://i.pravatar.cc/400?img=16',
          interests: ['Химия', 'Теннис', 'Волонтёрство'],
          bio: 'Science enthusiast, tennis player, volunteer 🎾🧪',
          email: '230103112@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'male',
        ),
        UserProfile(
          id: 'mock-008',
          name: 'Бекзат',
          age: 23,
          faculty: 'Engineering',
          yearOfStudy: 4,
          imageUrl: 'https://i.pravatar.cc/400?img=33',
          interests: ['Кибербезопасность', 'Гейминг', 'Электронная музыка'],
          bio: 'Ethical hacker by day, gamer by night 🎮🔒',
          email: '210103033@sdu.edu.kz',
          gender: 'male',
          lookingFor: 'all',
        ),
      ];

  // Моковые матчи (люди с которыми мы уже совпали)
  List<UserProfile> get matchedProfiles => [
        UserProfile(
          id: 'mock-001',
          name: 'Айгерим',
          age: 19,
          faculty: 'Business School',
          yearOfStudy: 1,
          imageUrl: 'https://i.pravatar.cc/400?img=5',
          interests: ['Маркетинг', 'Йога', 'Путешествия'],
          bio: 'Люблю кофе и новые знакомства ☕️',
          email: '240103002@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'male',
        ),
        UserProfile(
          id: 'mock-003',
          name: 'Камила',
          age: 20,
          faculty: 'Humanities',
          yearOfStudy: 2,
          imageUrl: 'https://i.pravatar.cc/400?img=9',
          interests: ['Искусство', 'Книги', 'Музыка'],
          bio: 'Artistic soul looking for deep conversations 🎨',
          email: '230103015@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'all',
        ),
        UserProfile(
          id: 'mock-005',
          name: 'Сауле',
          age: 19,
          faculty: 'Engineering',
          yearOfStudy: 1,
          imageUrl: 'https://i.pravatar.cc/400?img=10',
          interests: ['Программирование', 'K-Pop', 'Аниме'],
          bio: 'CS freshman, anime lover, let\'s code together! 💻',
          email: '240103078@sdu.edu.kz',
          gender: 'female',
          lookingFor: 'all',
        ),
      ];

  // Моковые сообщения для чата
  Map<String, List<ChatMessage>> get chatMessages => {
        'mock-001': [
          ChatMessage(
            id: 'msg-001',
            senderId: 'mock-001',
            text: 'Привет! Как дела?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-002',
            senderId: currentUserId,
            text: 'Привет! Отлично, спасибо! Ты как?',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-003',
            senderId: 'mock-001',
            text: 'Тоже хорошо! Увидела что ты тоже любишь программирование',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-004',
            senderId: currentUserId,
            text: 'Да! На каком курсе учишься?',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-005',
            senderId: 'mock-001',
            text: 'На первом, Business School. А ты?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            isRead: false,
          ),
        ],
        'mock-003': [
          ChatMessage(
            id: 'msg-101',
            senderId: 'mock-003',
            text: 'Hey! Видела ты интересуешься искусством',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-102',
            senderId: currentUserId,
            text: 'Да, немного! Сам больше в tech, но ценю хорошее искусство',
            timestamp: DateTime.now().subtract(const Duration(hours: 23)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-103',
            senderId: 'mock-003',
            text: 'Круто! Может сходим в Esentai Gallery как-нибудь?',
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
            isRead: false,
          ),
        ],
        'mock-005': [
          ChatMessage(
            id: 'msg-201',
            senderId: currentUserId,
            text: 'Привет! Увидел что ты тоже любишь аниме 😄',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-202',
            senderId: 'mock-005',
            text: 'Да!! Что последнее смотрел?',
            timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-203',
            senderId: currentUserId,
            text: 'Attack on Titan финал был огонь 🔥',
            timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
            isRead: true,
          ),
          ChatMessage(
            id: 'msg-204',
            senderId: 'mock-005',
            text: 'Согласна! А Demon Slayer новый сезон смотрел?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            isRead: false,
          ),
        ],
      };

  // Получить сообщения для конкретного матча
  List<ChatMessage> getMessagesForMatch(String matchId) {
    return chatMessages[matchId] ?? [];
  }

  // Получить количество непрочитанных сообщений
  int getUnreadCount(String matchId) {
    final messages = chatMessages[matchId] ?? [];
    return messages
        .where((msg) => msg.senderId != currentUserId && !msg.isRead)
        .length;
  }

  // Получить последнее сообщение для матча
  ChatMessage? getLastMessage(String matchId) {
    final messages = chatMessages[matchId];
    if (messages == null || messages.isEmpty) return null;
    return messages.last;
  }

  // Симуляция добавления нового сообщения
  void addMessage(String matchId, String text) {
    if (chatMessages.containsKey(matchId)) {
      chatMessages[matchId]!.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          senderId: currentUserId,
          text: text,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
    }
  }

  // Доступные факультеты
  List<String> get faculties => [
        'Engineering',
        'Business School',
        'Sciences',
        'Humanities',
        'Law',
        'Education',
      ];

  // Популярные интересы
  List<String> get popularInterests => [
        'Программирование',
        'AI/ML',
        'Кофе',
        'Книги',
        'Музыка',
        'Спорт',
        'Йога',
        'Путешествия',
        'Фотография',
        'Искусство',
        'Кино',
        'Аниме',
        'K-Pop',
        'Игры',
        'Cooking',
        'Баскетбол',
        'Футбол',
        'Теннис',
        'Хайкинг',
        'Волонтёрство',
      ];
}
