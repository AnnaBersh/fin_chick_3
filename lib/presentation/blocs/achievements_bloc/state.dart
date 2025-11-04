

import '../../../domain/entities/achievements.dart';

class AchievsState {
  final bool loading;
  final List<Achievement> achievements;

  const AchievsState({required this.loading, required this.achievements});

  AchievsState copyWith({
    bool? loading,
    List<Achievement>? achievements,
  }) => AchievsState(
    loading: loading ?? this.loading,
    achievements: achievements ?? this.achievements,
  );

  static const empty = AchievsState(loading: true, achievements: []);
}
