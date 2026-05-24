import 'dart:math';

import 'package:flutter/material.dart';

class FlyingReactionOverlay {
  const FlyingReactionOverlay._();

  static void show({
    required BuildContext context,
    required TickerProvider vsync,
    required GlobalKey fromKey,
    required GlobalKey toKey,
    required IconData icon,
    required Color color,
  }) {
    final start = _getWidgetCenter(fromKey);
    final end = _getWidgetCenter(toKey);
    final particles = _createParticles(icon: icon, color: color);
    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1550),
    );

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            const arriveAt = 0.68;
            final flightProgress = (controller.value / arriveAt).clamp(
              0.0,
              1.0,
            );
            final burstProgress =
                ((controller.value - arriveAt) / (1 - arriveAt)).clamp(
                  0.0,
                  1.0,
                );
            final t = Curves.easeInOutCubicEmphasized.transform(flightProgress);
            final current = controller.value < arriveAt
                ? _pointOnPath(start: start, end: end, progress: t)
                : end;
            final isBurst = controller.value >= arriveAt;
            final mainScale = isBurst
                ? 2.0 + Curves.elasticOut.transform(burstProgress) * 0.25
                : 0.75 + Curves.easeOutBack.transform(flightProgress) * 1.2;
            final mainOpacity = isBurst
                ? (1 - burstProgress * 2.4).clamp(0.0, 1.0)
                : 1.0;

            return Positioned(
              left: current.dx - 125,
              top: current.dy - 125,
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!isBurst)
                          for (var i = 1; i <= 7; i++)
                            ReactionTrailIcon(
                              icon: icon,
                              color: color,
                              offset:
                                  _pointOnPath(
                                    start: start,
                                    end: end,
                                    progress: (flightProgress - i * 0.045)
                                        .clamp(0.0, 1.0),
                                  ) -
                                  current,
                              opacity: (0.42 - i * 0.045).clamp(0.0, 1.0),
                              scale: 1 - i * 0.055,
                            ),
                        if (isBurst)
                          for (var i = 0; i < 3; i++)
                            ReactionBurstRing(
                              progress:
                                  ((burstProgress - i * 0.12) / (1 - i * 0.12))
                                      .clamp(0.0, 1.0),
                              color: color,
                              index: i,
                            ),
                        if (isBurst)
                          for (final particle in particles)
                            ReactionParticleView(
                              particle: particle,
                              progress:
                                  ((burstProgress - particle.delay) /
                                          (1 - particle.delay))
                                      .clamp(0.0, 1.0),
                              icon: icon,
                            ),
                        if (mainOpacity > 0)
                          ReactionMainIcon(
                            icon: icon,
                            color: color,
                            opacity: mainOpacity,
                            scale: mainScale.clamp(0.0, 2.4),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(entry);

    controller.forward().whenComplete(() {
      entry.remove();
      controller.dispose();
    });
  }

  static Offset _getWidgetCenter(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return Offset.zero;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    return Offset(
      position.dx + renderBox.size.width / 2,
      position.dy + renderBox.size.height / 2,
    );
  }

  static Offset _pointOnPath({
    required Offset start,
    required Offset end,
    required double progress,
  }) {
    final dx = start.dx + (end.dx - start.dx) * progress;
    final dy =
        start.dy + (end.dy - start.dy) * progress - 105 * sin(pi * progress);

    return Offset(dx, dy);
  }

  static List<ReactionParticle> _createParticles({
    required IconData icon,
    required Color color,
  }) {
    final random = Random();
    final isLoveReaction =
        icon == Icons.favorite || icon == Icons.favorite_rounded;
    final accentColors = [
      color,
      Colors.white,
      Colors.amberAccent,
      isLoveReaction ? Colors.pinkAccent : Colors.cyanAccent,
      isLoveReaction ? Colors.orangeAccent : Colors.lightBlueAccent,
    ];

    return List.generate(30, (index) {
      return ReactionParticle(
        angle: (2 * pi * index / 30) + random.nextDouble() * 0.5,
        distance: 45 + random.nextDouble() * 95,
        size: 7 + random.nextDouble() * 18,
        spin: (random.nextDouble() - 0.5) * pi * 5,
        delay: random.nextDouble() * 0.15,
        color: accentColors[index % accentColors.length],
        type: index % 4,
      );
    });
  }
}

class ReactionMainIcon extends StatelessWidget {
  const ReactionMainIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.opacity,
    required this.scale,
  });

  final IconData icon;
  final Color color;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  color.withValues(alpha: 0.30),
                  color.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 42,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: scale,
            child: Icon(
              icon,
              color: color,
              size: 58,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReactionTrailIcon extends StatelessWidget {
  const ReactionTrailIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.offset,
    required this.opacity,
    required this.scale,
  });

  final IconData icon;
  final Color color;
  final Offset offset;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Icon(icon, color: color.withValues(alpha: 0.85), size: 46),
        ),
      ),
    );
  }
}

class ReactionBurstRing extends StatelessWidget {
  const ReactionBurstRing({
    super.key,
    required this.progress,
    required this.color,
    required this.index,
  });

  final double progress;
  final Color color;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final t = Curves.easeOutCubic.transform(progress);

    return Opacity(
      opacity: (1 - progress).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.35 + t * (2.0 + index * 0.45),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.75),
              width: 3 - index * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class ReactionParticleView extends StatelessWidget {
  const ReactionParticleView({
    super.key,
    required this.particle,
    required this.progress,
    required this.icon,
  });

  final ReactionParticle particle;
  final double progress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final t = Curves.easeOutCubic.transform(progress);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    final offset = Offset(
      cos(particle.angle) * particle.distance * t,
      sin(particle.angle) * particle.distance * t + 26 * progress * progress,
    );

    return Transform.translate(
      offset: offset,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: particle.spin * t,
          child: Transform.scale(
            scale: (1 - progress * 0.25).clamp(0.0, 1.0),
            child: particle.type == 0
                ? Icon(
                    Icons.star_rounded,
                    color: particle.color,
                    size: particle.size,
                  )
                : particle.type == 1
                ? Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      color: particle.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: particle.color.withValues(alpha: 0.35),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  )
                : Icon(icon, color: particle.color, size: particle.size),
          ),
        ),
      ),
    );
  }
}

class ReactionParticle {
  const ReactionParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.spin,
    required this.delay,
    required this.color,
    required this.type,
  });

  final double angle;
  final double distance;
  final double size;
  final double spin;
  final double delay;
  final Color color;
  final int type;
}
