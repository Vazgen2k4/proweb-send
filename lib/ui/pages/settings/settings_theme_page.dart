import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/settings_bloc/settings_bloc.dart';
import 'package:proweb_send/domain/models/settings_model.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/app_hero_tags.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';
import 'package:proweb_send/ui/widgets/constains.dart';
import 'package:proweb_send/ui/widgets/settings/settings_button.dart';

class SettingsThemePage extends StatelessWidget {
  const SettingsThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppHeroTags.themeTitle,
      child: Scaffold(
        appBar: AppBar(
          leading: Center(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.text,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  final state = context.read<SettingsBloc>().state;
                  if (state is! SettingsBlocLoded) return;

                  await state.settings.saveSettingsOnDevice();
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context).done,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Color(0xffE6E1E5),
                  ),
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 64,
          title: Text(
            S.of(context).theme,
            style: const TextStyle(
              color: Color(0xffe6e6e6),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Column(
              children: <Widget>[
                SettingsButton(
                  icon: Icons.palette_outlined,
                  title: S.of(context).theme,
                  traling: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xffD6B3F1),
                  ),
                  action: () {},
                ),
                const SizedBox(height: 16),
                SettingsButton(
                  icon: Icons.photo_library_outlined,
                  title: S.of(context).bg,
                  traling: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xffD9D9D9),
                  ),
                  action: () {},
                ),
                const SizedBox(height: 16),
                SettingsButton(
                  icon: Icons.nightlight_outlined,
                  title: S.of(context).night_theme,
                  traling: SizedBox(
                    height: 20,
                    child: Switch(
                      trackColor: MaterialStateProperty.all(
                        const Color(0xff5856D6).withOpacity(.5),
                      ),
                      thumbColor: MaterialStateProperty.all(
                        const Color(0xff5856D6),
                      ),
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  action: () {},
                ),
                const SizedBox(height: 16),
                const MessengerControllWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessengerControllWidget extends StatelessWidget {
  const MessengerControllWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return BgContainer(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<SettingsBloc, SettingsBlocState>(
        builder: (context, state) {
          if (state is! SettingsBlocLoded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final settings = state.settings;

          return Column(
            children: [
              SettingsThemeSliderWidget(
                icon: Icons.dashboard_outlined,
                maximun: Constains.fontSizeMax,
                minimum: Constains.fontSizeMin,
                init: settings.fontSize ?? Constains.fontSizeInit,
                title: S.of(context).font_size,
                onChangeEnd: (fontSize) {
                  settingsBloc.add(SetFontSize(fontSize: fontSize));
                },
              ),
              const SizedBox(height: 32),
              SettingsThemeSliderWidget(
                icon: Icons.messenger_outline_rounded,
                maximun: Constains.borderRadiusMax,
                minimum: Constains.borderRadiusMin,
                init: settings.borderRadius ?? Constains.borderRadiusInit,
                title: S.of(context).corners_message,
                onChangeEnd: (radius) {
                  settingsBloc.add(
                    SetBorderRadius(borderRadius: radius),
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 156,
                  minWidth: 311,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(AppImages.beaer),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    MessageWidget(
                      key: UniqueKey(),
                      itsMe: true,
                      message: 'Добрый день',
                      time: '4:18',
                      settings: settings,
                    ),
                    MessageWidget(
                      key: UniqueKey(),
                      itsMe: false,
                      message: 'Да, здравствуйте ',
                      time: '4:18',
                      settings: settings,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SettingsThemeSliderWidget extends StatefulWidget {
  final void Function(double value)? onChangeEnd;
  final double minimum;
  final double maximun;
  final double init;
  final IconData icon;
  final String title;

  const SettingsThemeSliderWidget({
    Key? key,
    this.onChangeEnd,
    required this.minimum,
    required this.maximun,
    required this.icon,
    required this.title,
    required this.init,
  }) : super(key: key);

  @override
  State<SettingsThemeSliderWidget> createState() =>
      _SettingsThemeSliderWidgetState();
}

class _SettingsThemeSliderWidgetState extends State<SettingsThemeSliderWidget> {
  late double value;

  @override
  void initState() {
    value = widget.init;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                widget.icon,
                color: AppColors.akcent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                height: 24 / 16,
                fontWeight: FontWeight.w500,
                color: AppColors.akcent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SliderTheme(
            data: const SliderThemeData(
              thumbColor: Color(0xfff2f2f7),
              activeTrackColor: Color(0xff7c7c80),
              inactiveTrackColor: Color(0xff7c7c80),
              inactiveTickMarkColor: AppColors.akcent,
              activeTickMarkColor: AppColors.akcent,
              trackHeight: 6,
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: Slider(
              max: widget.maximun,
              min: widget.minimum,
              value: value,
              label: '${value.round()}',
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });

                final action = widget.onChangeEnd;
                action == null ? 0 : action(newValue);
              },
            ),
          ),
        )
      ],
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final bool itsMe;
  final String time;
  final SettingsModel settings;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.itsMe,
    required this.time,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = settings.borderRadius ?? Constains.borderRadiusInit;
    final fontSize = settings.fontSize ?? Constains.fontSizeInit;
    final deviceWidth = MediaQuery.of(context).size.width;
    const widthPrecent = .8;
    final maxWidth = deviceWidth * widthPrecent;

    const kefPadding = .7;
    final paddingValue = borderRadius * kefPadding;
    final padding = paddingValue < 10
        ? 10.0
        : paddingValue > 20
            ? 16.0
            : paddingValue;

    return Align(
      alignment: itsMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            itsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          ClipPath(
            clipper: MessageClipper(itsMe: itsMe, radius: borderRadius),
            child: AnimatedContainer(
              padding: EdgeInsets.only(
                bottom: padding,
                top: padding,
                left: !itsMe ? padding + 4 : padding,
                right: itsMe ? padding + 4 : padding,
              ),
              constraints: BoxConstraints(maxWidth: maxWidth),
              duration: const Duration(milliseconds: 300),
              color: itsMe ? AppColors.message : AppColors.messageSecondary,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.21,
                  color: const Color(0xff151515),
                ),
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              height: 24 / 10,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageClipper extends CustomClipper<Path> {
  final bool itsMe;
  final double radius;
  const MessageClipper({
    required this.itsMe,
    required this.radius,
  });

  @override
  getClip(Size size) {
    const cilpWidth = 4.0;

    if (itsMe) {
      Path path = Path()
        ..lineTo(size.width - radius - cilpWidth, 0)
        ..arcTo(
          Rect.fromCircle(
            center: Offset(size.width - radius - cilpWidth, radius),
            radius: radius,
          ),
          -pi / 2, // startAngle,
          pi / 2, // sweepAngle,
          false, // forceMoveTo,
        )
        ..lineTo(size.width - cilpWidth, size.height - radius)
        ..lineTo(size.width - cilpWidth + .5, size.height - 5.5)
        ..lineTo(size.width - cilpWidth + 2, size.height - 2.5)
        ..lineTo(size.width - cilpWidth + 4, size.height)
        ..lineTo(radius, size.height)
        ..arcTo(
          Rect.fromCircle(
            center: Offset(radius, size.height - radius),
            radius: radius,
          ),
          pi / 2, // startAngle,
          pi / 2, // sweepAngle,
          false, // forceMoveTo,
        )
        ..lineTo(0, radius)
        ..arcTo(
          Rect.fromCircle(
            center: Offset(radius, radius),
            radius: radius,
          ),
          pi, // startAngle,
          pi / 2, // sweepAngle,
          false, // forceMoveTo,
        );

      return path;
    }

    Path path = Path()
      ..lineTo(size.width - radius, 0)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(size.width - radius, radius),
          radius: radius,
        ),
        -pi / 2, // startAngle,
        pi / 2, // sweepAngle,
        false, // forceMoveTo,
      )
      ..lineTo(size.width + cilpWidth, size.height - radius)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(size.width - radius, size.height - radius),
          radius: radius,
        ),
        0, // startAngle,
        pi / 2, // sweepAngle,
        false, // forceMoveTo,
      )
      ..lineTo(0, size.height)
      ..lineTo(2, size.height - 2)
      ..lineTo(3.5, size.height - 5.5)
      // ..lineTo(size.width + 4, size.height)
      // ..arcTo(
      //   Rect.fromCircle(
      //     center: Offset(radius, size.height - radius),
      //     radius: radius,
      //   ),
      //   pi / 2, // startAngle,
      //   pi / 2, // sweepAngle,
      //   false, // forceMoveTo,
      // )
      ..lineTo(cilpWidth, size.height - 8)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(radius + cilpWidth, radius),
          radius: radius,
        ),
        pi, // startAngle,
        pi / 2, // sweepAngle,
        false, // forceMoveTo,
      );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
