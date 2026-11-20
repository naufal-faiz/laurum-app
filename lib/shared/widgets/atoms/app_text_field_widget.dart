part of 'app_text_field.dart';

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
    this.prefixText,
  }) : assert(minLines > 0 && maxLines >= minLines && (!obscureText || maxLines == 1));
  final String label, value;
  final String? hint, errorText, prefixText;
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
