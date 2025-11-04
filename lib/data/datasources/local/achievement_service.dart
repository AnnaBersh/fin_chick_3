import 'dart:convert';

import 'package:itd_2/data/datasources/local/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/achievements.dart';
import '../../../domain/entities/expense.dart';

class AchievementService {
  const AchievementService._();

  // SharedPreferences key used by AchievementsBloc
  static const String _prefsKey = 'achievements_progress';

  static List<AchievBase> loadBase() => const [
    AchievBase(
      title: 'First Egg Laid',
      description:
          'Record your very first expense and start growing your nest of financial habits.',
    ),
    AchievBase(
      title: 'Seven Sunrise Streak',
      description:
          'Log into the app for 7 consecutive days and keep your farmyard momentum strong.',
    ),
    AchievBase(
      title: 'Loyal Rooster',
      description:
          'Reach a 30-day login streak and prove you’re a devoted keeper of the coop.',
    ),
    AchievBase(
      title: 'Legendary Farmer',
      description:
          'Hit a 100-day login streak and become a true master of your financial barnyard.',
    ),
    AchievBase(
      title: 'Market Expert',
      description:
          'Track 50 shopping expenses and show you know every grain that leaves your feed bin.',
    ),
    AchievBase(
      title: 'Feeding Time Regular',
      description:
          'Log 25 dining or café expenses, proving you can enjoy good meals while keeping track of every crumb.',
    ),
    AchievBase(
      title: 'Bill Tamer',
      description:
          'Record 20 bill payments and show you keep your farm running like clockwork.',
    ),
    AchievBase(
      title: 'Barnyard Entertainer',
      description:
          'Track 30 entertainment expenses and balance fun with your saving goals.',
    ),
    AchievBase(
      title: 'Field Scholar',
      description:
          'Log 10 education-related expenses and invest in the greatest crop of all — knowledge.',
    ),
    AchievBase(
      title: 'Feather & Flair',
      description:
          'Record 15 self-care expenses, showing you know when to preen your feathers without plucking your savings.',
    ),
    AchievBase(
      title: 'Hobby Harvester',
      description:
          'Track 20 hobby expenses and prove you can enjoy your pastures responsibly.',
    ),
    AchievBase(
      title: 'Road Rooster',
      description:
          'Log 40 transportation expenses and show you account for every mile you travel.',
    ),
    AchievBase(
      title: 'Style in the Coop',
      description:
          'Record 25 clothing expenses while keeping both your wardrobe and wallet tidy.',
    ),
    AchievBase(
      title: 'Farm Explorer',
      description:
          'Track 5 travel expenses and prove you can wander far without emptying your nest.',
    ),
    AchievBase(
      title: 'Health Hen',
      description:
          'Log 20 health-related expenses, showing you invest wisely in your most valuable asset — yourself.',
    ),
    AchievBase(
      title: 'Animal Caretaker',
      description:
          'Record 15 pet or livestock expenses and show you care for every creature under your roof.',
    ),
    AchievBase(
      title: 'Coop Builder',
      description:
          'Track 30 home or farm upkeep expenses while crafting your dream homestead with smart planning.',
    ),
    AchievBase(
      title: 'Kindhearted Giver',
      description:
          'Log 10 gift expenses and prove you can share your harvest while still saving seed for tomorrow.',
    ),
    AchievBase(
      title: 'Charitable Chicken',
      description:
          'Record 5 donation expenses and show your heart is as golden as your grain.',
    ),
    AchievBase(
      title: 'Master of the Coop',
      description:
          'Complete 500 total expense entries across all categories and become the true guardian of your financial farm.',
    ),
  ];

  static List<Achievement> loadBaseForUI() =>
      loadBase().map(Achievement.fromBase).toList();

  // Map app subCategory -> achievement title (for category-specific counters)
  static const Map<String, String> _categoryToAchievementTitle = {
    'Shopping': 'Market Expert',
    'Restaurants & Cafes': 'Feeding Time Regular',
    'Bills': 'Bill Tamer',
    'Entertainment': 'Barnyard Entertainer',
    'Education': 'Field Scholar',
    'Beauty': 'Feather & Flair',
    'Hobbies': 'Hobby Harvester',
    'Transportation': 'Road Rooster',
    'Clothing': 'Style in the Coop',
    'Tourism': 'Farm Explorer',
    'Health': 'Health Hen',
    'Pets': 'Animal Caretaker',
    'Home': 'Coop Builder',
    'Gifts': 'Kindhearted Giver',
    'Donations': 'Charitable Chicken',
  };

  static String _idForTitle(String title) => Achievement.idFromTitle(title);

  static Future<Map<String, dynamic>> _readSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Future<void> _writeSaved(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(map));
  }

  static Achievement? _findBaseById(String id) {
    for (final a in loadBaseForUI()) {
      if (a.id == id) return a;
    }
    return null;
  }

  // Sets absolute progress for achievement id, capping at the goal
  static Future<void> setProgress(String id, int value) async {
    final base = _findBaseById(id);
    if (base == null) return;
    final goal = base.goalValue;
    final newVal = value < 0 ? 0 : (value > goal ? goal : value);

    final saved = await _readSaved();
    final updated = base.copyWith(
      currentValue: newVal,
      isCompleted: newVal >= goal,
    );
    saved[id] = updated.toPrefs();
    await _writeSaved(saved);
  }

  // Increments progress for achievement id by [by]
  static Future<void> increment(String id, [int by = 1]) async {
    final base = _findBaseById(id);
    if (base == null) return;
    final saved = await _readSaved();
    int current = 0;
    final v = saved[id];
    if (v is Map<String, dynamic>) {
      final a = Achievement.fromPrefs(v, base);
      current = a.currentValue;
    }
    await setProgress(id, current + by);
  }

  // Call when a new expense is added
  static Future<void> onExpenseAdded(Expense expense) async {
    // First expense (goal=1)
    await increment(_idForTitle('First Egg Laid'));

    // Total entries across all categories
    await increment(_idForTitle('Master of the Coop'));

    // Category-specific mapping
    final title = _categoryToAchievementTitle[expense.subCategory];
    if (title != null) {
      await increment(_idForTitle(title));
    }
  }

  // Update login streak achievements based on today open
  static Future<void> updateLoginStreakForToday(StorageService storage) async {
    final now = DateTime.now();
    final dateKey =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final lastOpen = storage.getLastOpenDate();

    int streak = storage.getLoginStreak();
    if (lastOpen == null) {
      streak = 1;
    } else if (lastOpen == dateKey) {
      // already counted for today
    } else {
      try {
        final parts = lastOpen.split('-').map(int.parse).toList();
        final lastDate = DateTime(parts[0], parts[1], parts[2]);
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        if (lastDate.year == yesterday.year &&
            lastDate.month == yesterday.month &&
            lastDate.day == yesterday.day) {
          streak = streak + 1;
        } else {
          streak = 1;
        }
      } catch (_) {
        streak = 1;
      }
    }

    await storage.setLoginStreak(streak);
    await storage.setLastOpenDate(dateKey);

    // Apply to the three streak achievements
    await setProgress(_idForTitle('Seven Sunrise Streak'), streak);
    await setProgress(_idForTitle('Loyal Rooster'), streak);
    await setProgress(_idForTitle('Legendary Farmer'), streak);
  }
}
