import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_field_decoration.dart';
import 'package:laurum/core/theme/app_input_styles.dart';
import 'package:laurum/core/theme/app_spacing.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';
import 'package:laurum/shared/widgets/atoms/app_text.dart';

part 'app_text_field_widget.dart';

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus || !widget.selectAllOnFocus) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_focusNode.hasFocus) return;
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      });
    });
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value || _controller.text == widget.value) return;
    _controller.text = widget.value;
    _controller.selection = TextSelection.collapsed(offset: widget.value.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leading = widget.prefixText != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
            child: Center(
              widthFactor: 1,
              child: AppText(
                widget.prefixText!.trimRight(),
                variant: AppTextVariant.input,
                color: AppColors.ink3,
              ),
            ),
          )
        : widget.leadingIcon == null
        ? null
        : AppIcon(widget.leadingIcon!, size: 16, color: AppColors.ink3);
    return Semantics(
      label: widget.label,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        scrollPadding: widget.dense ? AppInputStyles.denseScrollPadding : const EdgeInsets.all(20),
        style: AppFieldDecoration.style(dense: widget.dense, enabled: widget.enabled),
        cursorColor: AppColors.primary,
        decoration: AppFieldDecoration.of(
          prefixText: widget.prefixText,
          dense: widget.dense,
          hint: widget.hint,
          error: widget.errorText,
          enabled: widget.enabled,
          prefixIcon: leading,
          suffixIcon: widget.trailing,
        ),
      ),
    );
  }
}
