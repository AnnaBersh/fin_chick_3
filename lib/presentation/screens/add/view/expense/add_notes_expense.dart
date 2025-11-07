import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itd_2/core/constants/app_colors.dart';
import 'package:itd_2/routes/app_router.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/constants/app_text.dart';
import '../../../../../data/datasources/local/achievement_service.dart';
import '../../../../../data/datasources/local/sound_service.dart';
import '../../../../../data/datasources/local/storage_service.dart';
import '../../../../../data/repositories/finance_repository_impl.dart';
import '../../../../../domain/entities/expense.dart';
import '../../../../components/components/nav_bar.dart';
import '../../../main/main_screen.dart';
import '../../../settings/view/settings_screen.dart';
import 'choose_category_expense.dart';

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 8; i++) {
      buffer.write(digits[i]);
      if (i == 1 || i == 3) buffer.write('-');
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class AddNotesExpense extends StatefulWidget {
  static const routeName = 'expenseNotes';

  const AddNotesExpense({super.key});

  @override
  State<AddNotesExpense> createState() => _AddNotesExpenseState();
}

class _AddNotesExpenseState extends State<AddNotesExpense> {
  int _tab = 2;
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _notesFocus = FocusNode();
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _dateController.text = _storage.getDraftExpenseDate() ?? '';
    _amountController.text = _storage.getDraftExpenseAmount() ?? '';
    _notesController.text = _storage.getDraftExpenseDescription() ?? '';
    _dateFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _dateFocus.dispose();
    _amountFocus.dispose();
    _notesFocus.dispose();
    super.dispose();
  }

  bool _isValidDate(String s) {
    final m = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(s);
    if (m == null) return false;
    final d = int.tryParse(m.group(1)!) ?? 0;
    final mo = int.tryParse(m.group(2)!) ?? 0;
    final y = int.tryParse(m.group(3)!) ?? 0;
    if (mo < 1 || mo > 12) return false;
    if (d < 1) return false;
    final lastDay = DateTime(y, mo + 1, 0).day;
    if (d > lastDay) return false;
    return true;
  }

  Future<void> _save() async {
    final date = _dateController.text.trim();
    final amount = _amountController.text.trim();
    final description = _notesController.text.trim();

    final datePatternOk = RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(date);
    final dateOk = datePatternOk && _isValidDate(date);
    final amountOk = RegExp(r'^\d{1,6}$').hasMatch(amount);

    if (!dateOk || !amountOk) {
      // Simple validation: keep focus on the first invalid field
      if (!dateOk)
        _dateFocus.requestFocus();
      else
        _amountFocus.requestFocus();
      return;
    }

    final subCategory = _storage.getSelectedExpenseSubCategory() ?? '';
    final amt = double.tryParse(amount.replaceAll(',', '.')) ?? 0;

    final expense = Expense.create(
      subCategory: subCategory,
      date: date,
      amount: amt,
      description: description.isEmpty ? null : description,
    );

    final repo = FinanceRepository();
    await repo.addExpense(expense);
    await AchievementService.onExpenseAdded(expense);
    await _storage.clearSelectedExpense();
    await _storage.clearDraftExpense();
    await SoundService().playAsset('sounds/spinning-coin-on-table-352448.mp3');

    if (!mounted) return;
    context.pushNamedAndRemoveUntil(MainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () =>
                context.pushNamedAndRemoveUntil(SettingsScreen.routeName),
            icon: Image.asset('assets/general_buttons/setting_icon.webp'),
          ),
        ],
        leading: IconButton(
          onPressed: () async {
            _dateController.clear();
            _amountController.clear();
            _notesController.clear();
            await _storage.clearDraftExpense();
            if (!mounted) return;
            context.pushNamedAndRemoveUntil(ChooseCategoryExpense.routeName);
          },
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_in_game/bg_1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.45,
                      width: size.width * 0.80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/bg_components/main_item_bg.webp',
                          ),
                          fit: BoxFit.fill,
                        ),
                        border: Border.all(color: AppColors.borderColor, width: 3),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/yellow_bg.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _dateController,
                              focusNode: _dateFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                DateTextInputFormatter(),
                              ],
                              textAlign: TextAlign.center,
                              style: AppStyles.mediumSecondBlue,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _dateFocus.hasFocus
                                    ? ''
                                    : 'dd-mm-yyyy',
                                hintStyle: AppStyles.mediumSecondBlue,
                                counterText: '',
                              ),
                              onChanged: (v) => _storage.setDraftExpenseDate(v),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/yellow_bg.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              textAlign: TextAlign.center,
                              style: AppStyles.mediumSecondBlue,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: AppStyles.mediumSecondBlue,
                                counterText: '',
                              ),
                              onChanged: (v) =>
                                  _storage.setDraftExpenseAmount(v),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: size.height * 0.12,
                            width: size.width * 0.7,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/bg_components/yellow_bg.webp',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: TextField(
                              controller: _notesController,
                              focusNode: _notesFocus,
                              keyboardType: TextInputType.text,
                              maxLength: 45,
                              maxLines: 2,
                              style: AppStyles.mediumSecondBlue.copyWith(fontSize: 16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppTexts.notes,
                                hintStyle: AppStyles.mediumSecondBlue.copyWith(fontSize: 14),
                                counterText: '',
                              ),
                              onChanged: (v) =>
                                  _storage.setDraftExpenseDescription(v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    Center(
                      child: GestureDetector(
                        onTap: _save,
                        child: Image.asset(
                          'assets/general_buttons/save_button.webp',
                          height: size.height * 0.08,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
