import 'package:flutter/material.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/pages/settings/settings_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/app_hero_tags.dart';

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
                onPressed: () {},
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
                      // splashRadius: 100,
                      trackColor: MaterialStateProperty.all(
                          const Color(0xff5856D6).withOpacity(.5)),
                      thumbColor:
                          MaterialStateProperty.all(const Color(0xff5856D6)),
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
    return BgContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SettingsThemeSliderWidget(
            icon: Icons.dashboard_outlined,
            maximun: 22,
            minimum: 12,
            title: S.of(context).font_size,
          ),
          const SizedBox(height: 32),
          SettingsThemeSliderWidget(
            icon: Icons.messenger_outline_rounded,
            maximun: 22,
            minimum: 12,
            title: S.of(context).corners_message,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 156),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage(AppImages.beaer),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              children: const <Widget>[
                MessageWidget(
                  itsMe: true,
                  message: 'Добрый день',
                  time: '4:18',
                ),
                MessageWidget(
                  itsMe: false,
                  message: 'Да, здравствуйте',
                  time: '4:18',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsThemeSliderWidget extends StatefulWidget {
  final VoidCallback? onChange;
  final double minimum;
  final double maximun;
  final IconData icon;
  final String title;

  const SettingsThemeSliderWidget({
    Key? key,
    this.onChange,
    required this.minimum,
    required this.maximun,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  State<SettingsThemeSliderWidget> createState() =>
      _SettingsThemeSliderWidgetState();
}

class _SettingsThemeSliderWidgetState extends State<SettingsThemeSliderWidget> {
  late double value;

  @override
  void initState() {
    value = widget.minimum;
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
              divisions: 5,
              max: widget.maximun,
              min: widget.minimum,
              value: value,
              label: '${value.round()}',
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
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
  const MessageWidget({
    Key? key,
    required this.message,
    required this.itsMe,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: itsMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            itsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: !itsMe ? const Color(0xffe2e2e2) : null,
              gradient: itsMe
                  ? const LinearGradient(
                      colors: [
                        Color(0xffD6B3F1),
                        Color(0xffAEC4EF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              borderRadius: itsMe
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                  : const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  color: Color(0xff151515),
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
