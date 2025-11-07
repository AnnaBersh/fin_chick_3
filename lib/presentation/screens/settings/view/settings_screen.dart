import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itd_2/routes/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_text.dart';
import '../../../blocs/settings_bloc/bloc.dart';
import '../../../blocs/settings_bloc/state.dart';
import '../../../components/components/nav_bar.dart';
import '../../main/main_screen.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _tab = 9;
  late final SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc();
    _bloc.load();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _showAvatarSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        return Container(
          height: size.height * 0.28,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSheetButton(
                label: AppTexts.gallery,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await Future.delayed(const Duration(milliseconds: 120));
                  await _bloc.pickAvatar(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
              _buildSheetButton(
                label: AppTexts.camera,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await Future.delayed(const Duration(milliseconds: 120));
                  await _bloc.pickAvatar(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
              _buildSheetButton(
                label: AppTexts.cancel.toLowerCase(),
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/bg_components/quiz_item.webp'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppStyles.mediumSecondWhite),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppTexts.settings.toUpperCase(),
          style: AppStyles.titleAppBarYel,
        ),
        leading: IconButton(
          onPressed: () =>
              context.pushNamedAndRemoveUntil(MainScreen.routeName),
          icon: Image.asset('assets/general_buttons/back_icon.webp'),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _tab,
        onTap: (index) {
          setState(() => _tab = index);
        },
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_in_game/bg_1.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(color: AppColors.mainBlack.withOpacity(0.2)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state.loading) {
                    return Center(
                      child: Text(
                        AppTexts.loading,
                        style: AppStyles.mediumYel,
                      ),
                    );
                  }
                  return ListView(
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: _showAvatarSheet,
                          child: Container(
                            width: size.width * 0.32,
                            height: size.width * 0.32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 5,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: state.avatarPath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image: FileImage(File(state.avatarPath!)),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/general_buttons/ava_defoult.webp',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        AppTexts.myProfile,
                        style: AppStyles.mediumYel.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        height: size.height * 0.2,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/bg_components/main_item_bg.webp',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SettingTile(
                              title: AppTexts.sound,
                              value: state.soundEnabled,
                              onChanged: (v) => _bloc.setSound(v),
                            ),

                            _SettingTile(
                              title: AppTexts.notification,
                              value: state.notificationsEnabled,
                              onChanged: (v) async {
                                final granted = await _bloc.setNotifications(v);
                                if (v && !granted && mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: AppColors.topBlue80,
                                      title: Text(
                                        AppTexts.enableNotif,
                                        style: AppStyles.statListWhite.copyWith(
                                          fontSize: 20,
                                        ),
                                      ),
                                      content: Text(
                                        AppTexts.notifMessage,
                                        style: AppStyles.statListWhite,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            AppTexts.ok,
                                            style: AppStyles.statListWhite.copyWith(
                                              fontSize: 20,
                                              color: AppColors.mainTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _NavButton(
                        label: AppTexts.privacy,
                        onTap: () => context.pushNamedAndRemoveUntil(
                          PrivacyPolicy.routeName,
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      _NavButton(
                        label: AppTexts.termsOfUse,
                        onTap: () => context.pushNamedAndRemoveUntil(
                          TermsOfUse.routeName,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.transparent),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.statListWhite,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.mainWhite,
            activeTrackColor: AppColors.mainOrange,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56, width: 350,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/bg_components/main_with_border.webp'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label.toUpperCase(), style: AppStyles.titleAppBarYel),
      ),
    );
  }
}
