import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/dimensions.dart';
import '../theme/text_styles.dart';

/// Premium gradient pill button.
/// NOTE: public API (text / onPressed / isLoading) unchanged so every
/// existing screen that calls `CustomButton(...)` keeps working as-is.
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.isLoading;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
      transformAlignment: Alignment.center,
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        gradient: widget.outlined
            ? null
            : const LinearGradient(
                colors: AppColors.brandGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        border: widget.outlined ? Border.all(color: AppColors.primary, width: 1.6) : null,
        boxShadow: widget.outlined
            ? []
            : [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Center(
        child: widget.isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: widget.outlined ? AppColors.primary : Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.outlined ? AppColors.primary : Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: widget.outlined
                        ? AppTextStyles.button.copyWith(color: AppColors.primary)
                        : AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: disabled ? null : widget.onPressed,
      child: Opacity(opacity: disabled ? 0.75 : 1, child: child),
    );
  }
}
