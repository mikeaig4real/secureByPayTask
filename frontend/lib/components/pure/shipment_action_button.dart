import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ShipmentActionButtonVariant {
  outline,
  primary,
  disabled,
}

class ShipmentActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ShipmentActionButtonVariant variant;
  final bool isNarrow;
  final bool isLoading;
  final double? width;
  final double? height;

  const ShipmentActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ShipmentActionButtonVariant.primary,
    this.isNarrow = false,
    this.isLoading = false,
    this.width,
    this.height,
  });

  factory ShipmentActionButton.viewMore({
    Key? key,
    VoidCallback? onPressed,
    bool isNarrow = false,
    double? width,
    double? height,
  }) {
    return ShipmentActionButton(
      key: key,
      label: 'View More',
      onPressed: onPressed,
      variant: ShipmentActionButtonVariant.outline,
      isNarrow: isNarrow,
      width: width,
      height: height,
    );
  }

  factory ShipmentActionButton.payNow({
    Key? key,
    VoidCallback? onPressed,
    bool isNarrow = false,
    bool isLoading = false,
    double? width,
    double? height,
  }) {
    return ShipmentActionButton(
      key: key,
      label: 'Pay Now',
      onPressed: onPressed,
      variant: ShipmentActionButtonVariant.primary,
      isNarrow: isNarrow,
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  factory ShipmentActionButton.disabled({
    Key? key,
    String label = 'Paid',
    bool isNarrow = false,
    double? width,
    double? height,
  }) {
    return ShipmentActionButton(
      key: key,
      label: label,
      onPressed: null,
      variant: ShipmentActionButtonVariant.disabled,
      isNarrow: isNarrow,
      width: width,
      height: height,
    );
  }

  factory ShipmentActionButton.paid({
    Key? key,
    bool isNarrow = false,
    double? width,
    double? height,
  }) {
    return ShipmentActionButton.disabled(
      key: key,
      label: 'Paid',
      isNarrow: isNarrow,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? (isNarrow ? 94.0 : 106.0);
    final effectiveHeight = height ?? (isNarrow ? 32.0 : 36.0);
    final fontSize = isNarrow ? 11.5 : 12.5;
    final borderRadius = BorderRadius.circular(8);

    Color backgroundColor;
    Color foregroundColor;
    Border? border;

    switch (variant) {
      case ShipmentActionButtonVariant.outline:
        backgroundColor = Colors.white;
        foregroundColor = const Color(0xFF262A48);
        border = Border.all(
          color: const Color(0xFF262A48),
          width: 1.5,
        );
        break;

      case ShipmentActionButtonVariant.primary:
        backgroundColor = const Color(0xFF262A48);
        foregroundColor = Colors.white;
        border = null;
        break;

      case ShipmentActionButtonVariant.disabled:
        backgroundColor = const Color(0xFFEDEDED);
        foregroundColor = const Color(0xFF667085);
        border = null;
        break;
    }

    final isInteractive = onPressed != null && !isLoading && variant != ShipmentActionButtonVariant.disabled;

    final childWidget = isLoading
        ? SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          );

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInteractive ? onPressed : null,
          borderRadius: borderRadius,
          child: Center(
            child: childWidget,
          ),
        ),
      ),
    );
  }
}
