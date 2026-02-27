import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../swipe/domain/entities/user_profile.dart';

/// Попап появляется поверх SwipePage при взаимном лайке
class MatchPopup extends StatefulWidget {
  final UserProfile matchedProfile;
  final UserProfile? myProfile;
  final String matchId;

  const MatchPopup({
    super.key,
    required this.matchedProfile,
    required this.matchId,
    this.myProfile,
  });

  @override
  State<MatchPopup> createState() => _MatchPopupState();
}

class _MatchPopupState extends State<MatchPopup>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _heartsController;

  late Animation<double> _bgFadeAnim;
  late Animation<double> _titleScaleAnim;
  late Animation<double> _avatarsScaleAnim;
  late Animation<double> _buttonsSlideAnim;

  final List<_HeartParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 18; i++) {
      _particles.add(_HeartParticle(random: _random));
    }

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _heartsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _bgFadeAnim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    _titleScaleAnim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
    );

    _avatarsScaleAnim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.35, 0.85, curve: Curves.elasticOut),
    );

    _buttonsSlideAnim = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _heartsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matched = widget.matchedProfile;
    final me = widget.myProfile;

    final matchedImageUrl = matched.imageUrl.isNotEmpty
        ? CloudinaryService.getOptimizedUrl(matched.imageUrl, width: 300, height: 300)
        : '';
    final myImageUrl = (me != null && me.imageUrl.isNotEmpty)
        ? CloudinaryService.getOptimizedUrl(me.imageUrl, width: 300, height: 300)
        : '';

    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _bgFadeAnim,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Тёмный фон с градиентом
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.92),
                    const Color(0xFF1A1035).withValues(alpha: 0.97),
                  ],
                ),
              ),
            ),

            // Летящие сердечки
            AnimatedBuilder(
              animation: _heartsController,
              builder: (_, __) => CustomPaint(
                painter: _HeartParticlesPainter(
                  particles: _particles,
                  progress: _heartsController.value,
                ),
              ),
            ),

            // Контент
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Заголовок
                  ScaleTransition(
                    scale: _titleScaleAnim,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                          ).createShader(bounds),
                          child: const Text(
                            '💕 Это матч!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Вы и ${matched.name} понравились друг другу',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 44),

                  // Аватарки
                  ScaleTransition(
                    scale: _avatarsScaleAnim,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAvatar(
                          imageUrl: myImageUrl,
                          name: me?.name ?? 'Я',
                          borderColor: AppColors.primaryBlue,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: AnimatedBuilder(
                            animation: _heartsController,
                            builder: (_, __) {
                              final pulse = (sin(_heartsController.value * 2 * pi) * 0.12 + 1.0);
                              return Transform.scale(
                                scale: pulse,
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.favorite, color: Colors.white, size: 28),
                                ),
                              );
                            },
                          ),
                        ),
                        _buildAvatar(
                          imageUrl: matchedImageUrl,
                          name: matched.name,
                          borderColor: const Color(0xFFFF6B9D),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 52),

                  // Кнопки
                  AnimatedBuilder(
                    animation: _buttonsSlideAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, 40 * (1 - _buttonsSlideAnim.value)),
                      child: Opacity(opacity: _buttonsSlideAnim.value, child: child),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B9D).withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  context.push('/chat/${widget.matchId}', extra: matched);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Написать сообщение 💬',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Продолжить свайпать',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({
    required String imageUrl,
    required String name,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 62,
        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
        backgroundColor: Colors.grey.shade800,
        child: imageUrl.isEmpty
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Частицы сердечек
// ─────────────────────────────────────────────

class _HeartParticle {
  late double x;
  late double startY;
  late double size;
  late double speed;
  late double opacity;
  late double phase;

  _HeartParticle({required Random random}) {
    x = random.nextDouble();
    startY = 0.85 + random.nextDouble() * 0.15;
    size = 10.0 + random.nextDouble() * 20.0;
    speed = 0.15 + random.nextDouble() * 0.25;
    opacity = 0.3 + random.nextDouble() * 0.5;
    phase = random.nextDouble();
  }
}

class _HeartParticlesPainter extends CustomPainter {
  final List<_HeartParticle> particles;
  final double progress;

  _HeartParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final dy = size.height * (p.startY - t * 1.1);
      final dx = size.width * p.x + sin(t * 2 * pi + p.phase * 6) * 20;
      final alpha = p.opacity * (1 - t);
      if (alpha <= 0) continue;

      final paint = Paint()
        ..color = const Color(0xFFFF6B9D).withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      _drawHeart(canvas, Offset(dx, dy), p.size, paint);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final s = size * 0.5;
    final path = Path()
      ..moveTo(center.dx, center.dy + s * 0.5)
      ..cubicTo(
        center.dx - s * 1.2, center.dy - s * 0.3,
        center.dx - s * 2.0, center.dy - s * 1.5,
        center.dx, center.dy - s * 0.8,
      )
      ..cubicTo(
        center.dx + s * 2.0, center.dy - s * 1.5,
        center.dx + s * 1.2, center.dy - s * 0.3,
        center.dx, center.dy + s * 0.5,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeartParticlesPainter old) => old.progress != progress;
}
