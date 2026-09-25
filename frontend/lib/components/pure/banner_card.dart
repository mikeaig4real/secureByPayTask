import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/responsive.dart';

class BannerCard extends StatefulWidget {
  final VoidCallback? onAction;

  const BannerCard({super.key, this.onAction});

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<Map<String, String>> _slides = [
    {
      'title': 'KEEP UP WITH YOUR\nBUSINESS NEEDS',
      'image': 'assets/images/earth_boxes.png',
    },
    {
      'title': 'TRACK, PAY & CLEAR\nIN ONE UNIFIED HUB',
      'image': 'assets/images/earth_boxes.png',
    },
    {
      'title': 'INSTANT SETTLEMENTS\n& ESCROW PROTECTION',
      'image': 'assets/images/earth_boxes.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (_currentPage == page) return;
    setState(() {
      _currentPage = page;
    });
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final bannerHeight = isMobile ? 180.0 : 245.0;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: bannerHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF262A48),
            borderRadius: BorderRadius.circular(14),
            image: const DecorationImage(
              image: AssetImage('assets/images/banner_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x404F5C9E),
                        Colors.transparent,
                        Color(0x600B0D18),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                    PointerDeviceKind.stylus,
                  },
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    if (_currentPage != index) {
                      setState(() {
                        _currentPage = index;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: isMobile ? 8 : 36,
                          top: isMobile ? null : -10,
                          bottom: 0,
                          child: Image.asset(
                            slide['image']!,
                            height: isMobile ? 150 : 265,
                            width: isMobile ? 150 : 265,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                        ),

                        Positioned(
                          left: isMobile ? 20 : 36,
                          bottom: isMobile ? 20 : 36,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isMobile ? 220 : 520,
                            ),
                            child: Text(
                              slide['title']!,
                              style: GoogleFonts.dmSans(
                                fontSize: isMobile ? 22 : 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.08,
                                letterSpacing: -0.85,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            return _DotItem(
              index: index,
              isActive: _currentPage == index,
              onTap: () => _goToPage(index),
            );
          }),
        ),
      ],
    );
  }
}

class _DotItem extends StatefulWidget {
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _DotItem({
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DotItem> createState() => _DotItemState();
}

class _DotItemState extends State<_DotItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        key: Key('banner_dot_${widget.index}'),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? const Color(0xFF32385E)
                  : (_isHovered
                      ? const Color(0xFFAAAAAA)
                      : const Color(0xFFD4D4D4)),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
