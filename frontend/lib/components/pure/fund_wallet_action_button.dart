import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

enum FundWalletActionButtonVariant {
  primary,
  outline,
}

class FundWalletActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FundWalletActionButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const FundWalletActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FundWalletActionButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 40,
  });

  factory FundWalletActionButton.cancel({
    Key? key,
    VoidCallback? onPressed,
    double? width,
    double height = 40,
  }) {
    return FundWalletActionButton(
      key: key,
      label: 'Cancel',
      onPressed: onPressed,
      variant: FundWalletActionButtonVariant.outline,
      width: width,
      height: height,
    );
  }

  factory FundWalletActionButton.confirm({
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    double height = 40,
  }) {
    return FundWalletActionButton(
      key: key,
      label: 'Confirm Funding',
      onPressed: onPressed,
      variant: FundWalletActionButtonVariant.primary,
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final borderRadius = BorderRadius.circular(8);

    Color backgroundColor;
    Color foregroundColor;
    Border? border;

    switch (variant) {
      case FundWalletActionButtonVariant.outline:
        backgroundColor = Colors.white;
        foregroundColor = isEnabled ? AppColors.primary : AppColors.textMuted;
        border = Border.all(
          color: isEnabled ? AppColors.primary : AppColors.border,
          width: 1.5,
        );
        break;

      case FundWalletActionButtonVariant.primary:
        backgroundColor = isEnabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5);
        foregroundColor = Colors.white;
        border = null;
        break;
    }

    final childWidget = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: borderRadius,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: childWidget,
            ),
          ),
        ),
      ),
    );
  }
}
