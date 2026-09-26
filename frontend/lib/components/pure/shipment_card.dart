import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/shipment_model.dart';
import 'status_badge.dart';
import 'nigeria_flag_icon.dart';

class ShipmentCard extends StatefulWidget {
  final ShipmentModel shipment;
  final VoidCallback? onPayPressed;
  final bool isPaying;

  const ShipmentCard({
    super.key,
    required this.shipment,
    this.onPayPressed,
    this.isPaying = false,
  });

  @override
  State<ShipmentCard> createState() => _ShipmentCardState();
}

class _ShipmentCardState extends State<ShipmentCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    final currencyFormatter = NumberFormat('#,##0', 'en_US');
    final formattedAmount = 'N${currencyFormatter.format(shipment.amount)}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 650;
        final cardHorizontalPadding = isNarrow ? 12.0 : 20.0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: cardHorizontalPadding,
                    vertical: isNarrow ? 12 : 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: isNarrow ? 9 : 6,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tracking ID',
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 11 : 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.trackingId,
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 12.5 : 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF5A65AB),
                                      letterSpacing: isNarrow ? -0.2 : 0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isNarrow ? 8 : 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sender',
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 11 : 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.sender,
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 13 : 15,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF3A3A3A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: isNarrow ? 8 : 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receiver',
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 11 : 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.receiver,
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 13 : 15,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF171717),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isNarrow) const Spacer(flex: 4),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: isNarrow ? 20 : 24,
                        color: const Color(0xFF003701),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                const Divider(height: 1, color: Color(0xFFF0F2F5)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: cardHorizontalPadding,
                    vertical: isNarrow ? 12 : 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: isNarrow ? 5 : 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pick Up From',
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 10.5 : 12,
                                color: const Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: isNarrow ? 3 : 4),
                            Row(
                              children: [
                                const NigeriaFlagIcon(),
                                SizedBox(width: isNarrow ? 4 : 6),
                                Expanded(
                                  child: Text(
                                    shipment.pickUp,
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 12 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF171717),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: isNarrow ? 5 : 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery To',
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 10.5 : 12,
                                color: const Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: isNarrow ? 3 : 4),
                            Row(
                              children: [
                                const NigeriaFlagIcon(),
                                SizedBox(width: isNarrow ? 4 : 6),
                                Expanded(
                                  child: Text(
                                    shipment.deliveryTo,
                                    style: GoogleFonts.dmSans(
                                      fontSize: isNarrow ? 12 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF171717),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: isNarrow ? 4 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount',
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 10.5 : 12,
                                color: const Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: isNarrow ? 3 : 4),
                            Text(
                              formattedAmount,
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 13.5 : 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF171717),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: isNarrow ? 4 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 10.5 : 12,
                                color: const Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: isNarrow ? 3 : 4),
                            StatusBadge(
                              status: shipment.status,
                              padding: EdgeInsets.symmetric(
                                horizontal: isNarrow ? 6 : 10,
                                vertical: isNarrow ? 3 : 4,
                              ),
                              fontSize: isNarrow ? 10.5 : 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF0F2F5)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: cardHorizontalPadding,
                    vertical: isNarrow ? 10 : 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing time',
                            style: GoogleFonts.dmSans(
                              fontSize: isNarrow ? 10.5 : 12,
                              color: const Color(0xFF808080),
                            ),
                          ),
                          SizedBox(height: isNarrow ? 3 : 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: isNarrow ? 14 : 16,
                                color: const Color(0xFF3A3A3A),
                              ),
                              SizedBox(width: isNarrow ? 4 : 6),
                              Text(
                                shipment.processingTime.isNotEmpty
                                    ? shipment.processingTime
                                    : '-',
                                style: GoogleFonts.dmSans(
                                  fontSize: isNarrow ? 12.5 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF3A3A3A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF262A48),
                              side: const BorderSide(color: Color(0xFFD0D5DD)),
                              padding: EdgeInsets.symmetric(
                                horizontal: isNarrow ? 10 : 16,
                                vertical: isNarrow ? 4 : 6,
                              ),
                              minimumSize: Size(0, isNarrow ? 28 : 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'View More',
                              style: GoogleFonts.dmSans(
                                fontSize: isNarrow ? 11 : 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF262A48),
                              ),
                            ),
                          ),
                          SizedBox(width: isNarrow ? 6 : 10),
                          if (shipment.isPaid)
                            Container(
                              height: isNarrow ? 28 : 32,
                              padding: EdgeInsets.symmetric(
                                  horizontal: isNarrow ? 14 : 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Paid',
                                  style: GoogleFonts.dmSans(
                                    fontSize: isNarrow ? 11 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF808080),
                                  ),
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: isNarrow ? 28 : 32,
                              child: ElevatedButton(
                                onPressed: widget.onPayPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF262A48),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 12 : 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: widget.isPaying
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Pay Now',
                                        style: GoogleFonts.dmSans(
                                          fontSize: isNarrow ? 11 : 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
