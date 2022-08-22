import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends Equatable {
  final double? fontSize;
  final double? borderRadius;
  final bool? isNightTheme;
  final ImageCache? imageBg;
  final Locale? locale;

  const SettingsModel({
    this.fontSize,
    this.borderRadius,
    this.isNightTheme,
    this.imageBg,
    this.locale,
  });

  SettingsModel copyWith({
    double? fontSize,
    double? borderRadius,
    bool? isNightTheme,
    ImageCache? imageBg,
    Locale? locale,
  }) {
    return SettingsModel(
      fontSize: fontSize ?? this.fontSize,
      borderRadius: borderRadius ?? this.borderRadius,
      isNightTheme: isNightTheme ?? this.isNightTheme,
      imageBg: imageBg ?? this.imageBg,
      locale: locale ?? this.locale,
    );
  }

  Future<void> saveSettingsOnDevice() async {
    final pref = await SharedPreferences.getInstance();
    fontSize != null
        ? await pref.setDouble(SettingsModelKeys.fontSize, fontSize!)
        : 0;

    borderRadius != null
        ? await pref.setDouble(SettingsModelKeys.radius, borderRadius!)
        : 0;

    isNightTheme != null
        ? await pref.setBool(SettingsModelKeys.theme, isNightTheme!)
        : 0;

    final lang = locale?.countryCode;
    lang != null ? await pref.setString(SettingsModelKeys.locale, lang) : 0;
  }

  static Future<SettingsModel> getSettingsOnDevice() async {
    final pref = await SharedPreferences.getInstance();

    final size = pref.getDouble(SettingsModelKeys.fontSize);
    final radius = pref.getDouble(SettingsModelKeys.radius);
    final theme = pref.getBool(SettingsModelKeys.theme);
    final locale = pref.getString(SettingsModelKeys.locale);

    return SettingsModel(
      fontSize: size,
      borderRadius: radius,
      isNightTheme: theme,
      locale: locale != null ? Locale(locale) : null,
    );
  }

  @override
  List<Object?> get props => [
        imageBg,
        fontSize,
        borderRadius,
        isNightTheme,
        locale,
      ];
}

abstract class SettingsModelKeys {
  static const fontSize = '_font-size_';
  static const theme = '_theme_';
  static const radius = '_border-radius_';
  static const locale = '_locale_';
  static const image = '_image_';
}
