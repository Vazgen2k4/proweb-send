import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/app_hero_tags.dart';
import 'package:proweb_send/ui/widgets/settings/settings_button.dart';
import 'package:proweb_send/ui/widgets/settings/user_data_settings_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPageContent extends StatelessWidget {
  final ProUser user;
  const SettingsPageContent({
    Key? key,
    required this.user,
  }) : super(key: key);

  void _languageChose(BuildContext context) async {
    await showCupertinoModalPopup(
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        return const LangPopap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: 36,
        horizontal: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            UserDataSettingsWidget(user: user),
            const SizedBox(height: 32),
            SettingsButton(
              icon: Icons.add_circle_outline_rounded,
              title: S.of(context).add_account,
              action: () {
                print(1);
              },
            ),
            const SizedBox(height: 24),
            _btns(context)
          ],
        ),
      ),
    );
  }

  Widget _btns(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: AppHeroTags.themeTitle,
            child: SettingsButton(
              setCenter: true,
              icon: Icons.palette_outlined,
              title: S.of(context).theme,
              action: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.settingsTheme,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SettingsButton(
            setCenter: true,
            icon: Icons.language_outlined,
            title: S.of(context).language,
            action: () => _languageChose(context),
          ),
        ),
      ],
    );
  }
}

class LangPopap extends StatelessWidget {
  const LangPopap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _langs = <SettingsLanguageBtnData>[
      SettingsLanguageBtnData(lang: 'ru', title: 'Русский'),
      SettingsLanguageBtnData(lang: 'en', title: 'English'),
      SettingsLanguageBtnData(lang: 'ru', title: 'Русский'),
      SettingsLanguageBtnData(lang: 'en', title: 'English'),
      SettingsLanguageBtnData(lang: 'ru', title: 'Русский'),
      SettingsLanguageBtnData(lang: 'en', title: 'English'),
      SettingsLanguageBtnData(lang: 'ru', title: 'Русский'),
      SettingsLanguageBtnData(lang: 'en', title: 'English'),
      SettingsLanguageBtnData(lang: 'ru', title: 'Русский'),
      SettingsLanguageBtnData(lang: 'en', title: 'English'),
    ];
    final curentLang = S.of(context).locale;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 250),
        decoration: BoxDecoration(
          color: AppColors.greyPrimaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemCount: _langs.length,
          itemBuilder: (context, index) {
            final _btn = _langs[index];
            return SizedBox(
              width: double.infinity,
              child: SettingsButton(
                setCenter: true,
                title: _btn.title,
                action: () {
                  if (curentLang == _btn.lang) return;
                  context
                      .read<SettingsBloc>()
                      .add(SetLocale(locale: _btn.lang));
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsLanguageBtnData {
  final String title;
  final String lang;

  SettingsLanguageBtnData({required this.title, required this.lang});
}
