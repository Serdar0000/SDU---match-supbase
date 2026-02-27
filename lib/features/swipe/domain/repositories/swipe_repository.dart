import '../../domain/entities/user_profile.dart';

abstract class SwipeRepository {
  List<UserProfile> getProfiles();
}
