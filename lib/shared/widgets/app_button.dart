import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';


// 🔘 Botón reutilizable de la app
class AppButton extends StatelessWidget {

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {

    final button = ElevatedButton(
      onPressed: (isLoading) ? null : onPressed,

      child: isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text(
            label,
            style: AppTextStyles.body,
          ),
    );

    // 🔹 Expandido o tamaño natural
    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}