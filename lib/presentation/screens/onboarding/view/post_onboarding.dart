import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_text.dart';
import 'package:itd_2/data/datasources/local/storage_service.dart';
import '../../main/main_screen.dart';

class PostOnboardingScreen extends StatefulWidget {
  static const routeName = '/post_onboarding';

  const PostOnboardingScreen({super.key});

  @override
  State<PostOnboardingScreen> createState() => _PostOnboardingScreenState();
}

class _PostOnboardingScreenState extends State<PostOnboardingScreen> {
  final _scroll = ScrollController();
  final _savingKey = GlobalKey();
  final _limitKey = GlobalKey();
  final _savingFocus = FocusNode();
  final _limitFocus = FocusNode();
  final _savingCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _savingFocus.addListener(() {
      if (_savingFocus.hasFocus) _ensureVisible(_savingKey);
    });
    _limitFocus.addListener(() {
      if (_limitFocus.hasFocus) _ensureVisible(_limitKey);
    });
    final storage = StorageService();
    _savingCtrl.text = storage.getSavingGoal() ?? '';
    _limitCtrl.text = storage.getLimitGoal() ?? '';
  }

  @override
  void dispose() {
    _scroll.dispose();
    _savingFocus.dispose();
    _limitFocus.dispose();
    _savingCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  void _ensureVisible(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          alignment: 0.3,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/bg_in_game/bg_1.webp',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.25)),
          ),
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        AppTexts.postOnboardingTitle2,
                        textAlign: TextAlign.center,
                        style: AppStyles.mediumYel.copyWith(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    KeyedSubtree(
                      key: _savingKey,
                      child: _GoalCard(
                        title: AppTexts.savingGoal,
                        hintText: AppTexts.yourGoal,
                        controller: _savingCtrl,
                        focusNode: _savingFocus,
                        onChanged: (v) async {
                          await StorageService().setSavingGoal(v);
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    KeyedSubtree(
                      key: _limitKey,
                      child: _GoalCard(
                        title: AppTexts.spendingLimit,
                        hintText: AppTexts.spendingLimit,
                        controller: _limitCtrl,
                        focusNode: _limitFocus,
                        onChanged: (v) async {
                          await StorageService().setLimitGoal(v);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final storage = StorageService();
                        await storage.setSavingGoal(_savingCtrl.text.trim());
                        await storage.setLimitGoal(_limitCtrl.text.trim());
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          MainScreen.routeName,
                          (route) => false,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/bg_components/main_with_border.webp',
                            width: size.width * 0.6,
                           // height: size.height * 0.12,
                          ),
                          Text(
                            AppTexts.main,
                            style: AppStyles.bigButtonYel,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
          ),
          )
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final String hintText;

  const _GoalCard({
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Column(
        children: [
          Center(child: Text(title, style: AppStyles.onboardingMainTextYel)),
          SizedBox(height: 5,),
          Container(
            width: size.width * 0.95, height: size.height*0.18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_components/main_with_border.webp'),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.45,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: false,
                      maxLength: 7,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: AppStyles.mediumSecondBlue,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: AppStyles.mediumSecondBlue.copyWith(fontSize: 12),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.topYellow100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,)
        ],
      ),
    );
  }
}
