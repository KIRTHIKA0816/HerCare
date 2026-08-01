import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';

/// Premium rounded text field with floating label + optional password toggle.
/// Public API unchanged: label / controller / obscureText / keyboardType.
class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure = widget.obscureText;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: _focused
              ? [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, 6))]
              : [BoxShadow(color: AppColors.shadowSoft, blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText ? _obscure : false,
          keyboardType: widget.keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: _focused ? AppColors.primary : AppColors.textMuted, size: 20)
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
