import 'package:flutter/material.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_dimensions.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_text_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.label,
    required this.clearLabel,
    super.key,
    this.value = '',
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
  });
  final String label, clearLabel, value;
  final String? hint;
  final ValueChanged<String>? onChanged, onSubmitted;
  final bool enabled;
  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) => TextField(
        controller: _controller,
        enabled: widget.enabled,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: AppTextStyles.input.copyWith(color: widget.enabled ? AppColors.ink : AppColors.ink3),
        cursorColor: AppColors.primary,
        decoration: AppInputStyles.decoration(hint: widget.hint, enabled: widget.enabled).copyWith(
          prefixIconConstraints: AppInputStyles.iconConstraints,
          prefixIcon: const Padding(
            padding: AppInputStyles.iconPadding,
            child: AppIcon(AppIcons.search, size: AppDimensions.iconAction),
          ),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  tooltip: widget.clearLabel,
                  icon: const AppIcon(AppIcons.close, size: AppDimensions.iconAction),
                  onPressed: !widget.enabled
                      ? null
                      : () {
                          _controller.clear();
                          widget.onChanged?.call('');
                        },
                ),
        ),
      ),
    ),
  );
}
