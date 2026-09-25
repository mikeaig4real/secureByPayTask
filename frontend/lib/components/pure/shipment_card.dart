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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 650;
                  return Row(
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
                                      fontSize: 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.trackingId,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF5A65AB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sender',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.sender,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF3A3A3A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receiver',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: const Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    shipment.receiver,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
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
                        size: 24,
                        color: const Color(0xFF003701),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF0F2F5)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick Up From',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: const Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const NigeriaFlagIcon(),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shipment.pickUp,
                                style: GoogleFonts.dmSans(
                                   fontSize: 14,
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
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery To',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: const Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const NigeriaFlagIcon(),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shipment.deliveryTo,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
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
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: const Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedAmount,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF171717),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: const Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatusBadge(status: shipment.status),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF0F2F5)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processing time',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: const Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Color(0xFF3A3A3A),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            shipment.processingTime.isNotEmpty
                                ? shipment.processingTime
                                : '-',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'View More',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF262A48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      if (shipment.isPaid)
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              'Paid',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF808080),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: widget.onPayPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF262A48),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Pay Now',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
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
  }
}
