import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';

class UserSettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String defTitle;
  final bool hasOffset;
  final bool dizabel;
  final Widget? icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isArea;

  const UserSettingsTile({
    Key? key,
    required this.title,
    required this.defTitle,
    required this.subtitle,
    required this.controller,
    this.dizabel = false,
    this.inputFormatters,
    this.keyboardType,
    this.hasOffset = false,
    this.isArea = false,
    this.icon,
  }) : super(key: key);

  @override
  State<UserSettingsTile> createState() => _UserSettingsTileState();
}

class _UserSettingsTileState extends State<UserSettingsTile> {
  @override
  void initState() {
    final _value = widget.subtitle.trim();
    widget.controller.text = _value.isNotEmpty ? _value : widget.defTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: widget.icon!,
            ),
          if (widget.icon == null) const SizedBox(width: 44),
          Expanded(
            child: TextField(
              enabled: !widget.dizabel,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              controller: widget.controller,
              maxLines: widget.isArea ? null : 1,
              maxLength: widget.isArea ? 70 : null,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                height: 24 / 16,
              ),
              decoration: InputDecoration(
                alignLabelWithHint: false,
                counterStyle: const TextStyle(color: AppColors.text),
                contentPadding: EdgeInsets.zero,
                floatingLabelStyle: const TextStyle(
                  color: AppColors.textInfo,
                  fontSize: 20,
                  height: 1,
                ),
                labelText: widget.title,
                labelStyle: const TextStyle(
                  color: AppColors.textInfo,
                  fontSize: 14,
                  height: 24 / 14,
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
