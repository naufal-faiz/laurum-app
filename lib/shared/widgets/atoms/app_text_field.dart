import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laurum/core/icons/app_icons.dart';
import 'package:laurum/core/theme/app_colors.dart';
import 'package:laurum/core/theme/app_field_styles.dart';
import 'package:laurum/shared/widgets/atoms/app_icon.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.value = '',
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.selectAllOnFocus = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
    this.leadingIcon,
    this.trailing,
    this.dense = false,
  }) : assert(minLines > 0 && maxLines >= minLines),
       assert(!obscureText || maxLines == 1);
  final String label, value;
  final String? hint, errorText;
  final ValueChanged<String>? onChanged, onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled, readOnly, obscureText, selectAllOnFocus, dense;
  final AppIcons? leadingIcon;
  final Widget? trailing;
  final int minLines, maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

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
    if (oldWidget.value == widget.value) return;
    _controller.text = widget.value;
    _controller.selection = TextSelection.collapsed(offset: widget.value.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  InputDecoration get _decoration => AppFieldStyles.of(
    dense: widget.dense,
    hint: widget.hint,
    error: widget.errorText,
    enabled: widget.enabled,
    prefixIcon: widget.leadingIcon == null
        ? null
        : AppIcon(widget.leadingIcon!, size: 16, color: AppColors.authLabel),
    suffixIcon: widget.trailing,
  );
  @override
  Widget build(BuildContext context) => Semantics(
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
      scrollPadding: widget.dense ? const EdgeInsets.only(bottom: 330) : const EdgeInsets.all(20),
      style: AppFieldStyles.textStyle(dense: widget.dense, enabled: widget.enabled),
      cursorColor: AppColors.primary,
      decoration: _decoration,
    ),
  );
}
