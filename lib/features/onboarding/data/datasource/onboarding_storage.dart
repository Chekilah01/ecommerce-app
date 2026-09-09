import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStorage {
  static const String _onboardingCompletedKey =
      'onboarding_completed';

  Future<bool> isOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _onboardingCompletedKey,
      true,
    );
  }
}