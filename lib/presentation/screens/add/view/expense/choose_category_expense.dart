import 'package:flutter/material.dart';
import 'package:itd_2/core/constants/app_colors.dart';
import 'package:itd_2/core/constants/app_text.dart';
import 'package:itd_2/routes/app_router.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../data/datasources/local/storage_service.dart';
import '../../../../components/components/nav_bar.dart';
import '../../../settings/view/settings_screen.dart';
import '../add_screen.dart';
import 'add_notes_expense.dart';

class ChooseCategoryExpense extends StatefulWidget {
  static const routeName = 'categoryExpense';

  const ChooseCategoryExpense({super.key});

  @override
  State<ChooseCategoryExpense> createState() => _ChooseCategoryExpenseState();
}

class _ChooseCategoryExpenseState extends State<ChooseCategoryExpense> {
  int _tab = 2;

  void _onCategoryTap(String subCategory) async {
    final storage = StorageService();
    await storage.setSelectedExpenseCategory('expense');
    await storage.setSelectedExpenseSubCategory(subCategory);
    if (!mounted) return;
    context.pushNamedAndRemoveUntil(AddNotesExpense.routeName);
  }

  @override
  Widget build(BuildContext context) {
    const categories = <String>[
      'Shopping',
      'Restaurants & Cafes',
      'Bills',
      'Entertainment',
      'Education',
      'Beauty',
      'Hobbies',
      'Transportation',
      'Clothing',
      'Tourism',
      'Health',
      'Pets',
      'Home',
      'Gifts',
      'Donations',
      'Other',
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
          onPressed: () => context.pushNamedAndRemoveUntil(AddedScreen.routeName),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: double.infinity,
                  color: AppColors.topYellow100,
                  child: Center(
                    child: Text(
                      AppTexts.expense,
                      style: AppStyles.mediumWhite,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 15,
                          childAspectRatio: 2.2,
                        ),
                    itemBuilder: (context, index) {
                      final title = categories[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _onCategoryTap(title),
                        child: Container(padding: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/bg_components/main_with_border.webp',
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            title.toUpperCase(),
                            style: AppStyles.smallYel.copyWith(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
