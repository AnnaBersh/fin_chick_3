
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../presentation/screens/achievements/view/achievemets_screen.dart';
import '../presentation/screens/add/view/add_screen.dart';
import '../presentation/screens/add/view/expense/add_notes_expense.dart';
import '../presentation/screens/add/view/expense/choose_category_expense.dart';
import '../presentation/screens/add/view/income/add_notes_income.dart';
import '../presentation/screens/add/view/income/choose_category_income.dart';
import '../presentation/screens/history/view/choose_month_history.dart';
import '../presentation/screens/history/view/choose_period_history.dart';
import '../presentation/screens/history/view/history_list_screen.dart';
import '../presentation/screens/history/view/history_screen_main.dart';
import '../presentation/screens/main/daily_bonus/daily_bonus/daily_bonus_screen.dart';
import '../presentation/screens/main/loading/loading/loading_screen.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/onboarding/view/onboarding_quiz.dart';
import '../presentation/screens/onboarding/view/post_onboarding.dart';
import '../presentation/screens/onboarding/view/pre_onboarding_screen.dart';
import '../presentation/screens/settings/view/privacy_screen.dart';
import '../presentation/screens/settings/view/settings_screen.dart';
import '../presentation/screens/settings/view/terms_screen.dart';
import '../presentation/screens/shop/view/shop_screen.dart';
import '../presentation/screens/statistic/view/choose_month_screen.dart';
import '../presentation/screens/statistic/view/choose_period_screen.dart';
import '../presentation/screens/statistic/view/result_statistic_screen.dart';
import '../presentation/screens/statistic/view/statistic_screen.dart';



sealed class AppNavigator {
  const AppNavigator._();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
          child: const LoadScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case LoadScreen.routeName:
        return PageTransition(
          child: const LoadScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PreOnboardingScreen.routeName:
        return PageTransition(
          child: const PreOnboardingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case OnboardingQuiz.routeName:
        return PageTransition(
          child: const OnboardingQuiz(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PostOnboardingScreen.routeName:
        return PageTransition(
          child: const PostOnboardingScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case MainScreen.routeName:
        return PageTransition(
          child: const MainScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );


      case DailyBonusScreen.routeName:
        return PageTransition(
          child: const DailyBonusScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddedScreen.routeName:
        return PageTransition(
          child: AddedScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case ShopScreen.routeName:
        return PageTransition(
          child: const ShopScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case AchievsScreen.routeName:
        return PageTransition(
          child: const AchievsScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case HistoryMain.routeName:
        return PageTransition(
          child: const HistoryMain(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case HistoryListScreen.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: HistoryListScreen(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

      case ChooseMonthHistory.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: ChooseMonthHistory(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

      case ChoosePeriodHistory.routeName:
        {
          final arg = settings.arguments;
          final mode = (arg is String && (arg == 'income' || arg == 'expense')) ? arg : 'expense';
          return PageTransition(
            child: ChoosePeriodHistory(mode: mode),
            opaque: false,
            duration: Durations.medium2,
            type: PageTransitionType.fade,
          );
        }

        case StatisticScreen.routeName:
        return PageTransition(
          child: const StatisticScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case ChooseMonthScreen.routeName:
        return PageTransition(
          child: const ChooseMonthScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case ChoosePeriodScreen.routeName:
        return PageTransition(
          child: const ChoosePeriodScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case ResultStatisticScreen.routeName:
        return PageTransition(
          child: const ResultStatisticScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

        case ChooseCategoryIncome.routeName:
        return PageTransition(
          child: const ChooseCategoryIncome(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddNotesIncome.routeName:
        return PageTransition(
          child: AddNotesIncome(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case ChooseCategoryExpense.routeName:
        return PageTransition(
          child: const ChooseCategoryExpense(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case AddNotesExpense.routeName:
        return PageTransition(
          child: AddNotesExpense(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case SettingsScreen.routeName:
        return PageTransition(
          child: const SettingsScreen(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case TermsOfUse.routeName:
        return PageTransition(
          child: const TermsOfUse(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );

      case PrivacyPolicy.routeName:
        return PageTransition(
          child: const PrivacyPolicy(),
          opaque: false,
          duration: Durations.medium2,
          type: PageTransitionType.fade,
        );


      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}

extension NavigationExtension on BuildContext {
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName, {
        Object? arguments,
        bool Function(Route<dynamic>)? predicate,
      }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
 }
