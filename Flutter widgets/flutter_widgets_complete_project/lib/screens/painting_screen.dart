import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class PaintingScreen extends StatelessWidget {
  const PaintingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painting & Effects')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _OpacitySection(),
          SizedBox(height: 24),
          _ClipSection(),
          SizedBox(height: 24),
          _BackdropFilterSection(),
          SizedBox(height: 24),
          _TransformSection(),
          SizedBox(height: 24),
          _CustomPaintSection(),
        ],
      ),
    );
  }
}

class _OpacitySection extends StatefulWidget {
  const _OpacitySection();

  @override
  State<_OpacitySection> createState() => _OpacitySectionState();
}

class _OpacitySectionState extends State<_OpacitySection> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👻 Opacity - الشفافية',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Opacity(
                opacity: _opacity,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.image, size: 80, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _opacity,
              onChanged: (value) => setState(() => _opacity = value),
              label: '${(_opacity * 100).round()}%',
            ),
          ],
        ),
      ),
    );
  }
}

class _ClipSection extends StatelessWidget {
  const _ClipSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✂️ Clip Widgets - القص',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('ClipRRect'),
                  ],
                ),
                Column(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('ClipOval'),
                  ],
                ),
                Column(
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.5,
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('ClipRect'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropFilterSection extends StatelessWidget {
  const _BackdropFilterSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌫️ BackdropFilter - تأثير ضبابي',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.pink, Colors.purple],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 200,
                        height: 80,
                        color: Colors.white.withOpacity(0.2),
                        child: const Center(
                          child: Text(
                            'خلفية ضبابية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransformSection extends StatefulWidget {
  const _TransformSection();

  @override
  State<_TransformSection> createState() => _TransformSectionState();
}

class _TransformSectionState extends State<_TransformSection> {
  double _rotation = 0;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔄 Transform - التحويلات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Transform.rotate(
                angle: _rotation,
                child: Transform.scale(
                  scale: _scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.star, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('التدوير:'),
            Slider(
              value: _rotation,
              min: 0,
              max: 2 * math.pi,
              onChanged: (value) => setState(() => _rotation = value),
            ),
            const Text('التحجيم:'),
            Slider(
              value: _scale,
              min: 0.5,
              max: 2.0,
              onChanged: (value) => setState(() => _scale = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomPaintSection extends StatelessWidget {
  const _CustomPaintSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎨 CustomPaint - رسم مخصص',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: _SmileyPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // وجه
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      80,
      paint,
    );

    // عيون
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width / 2 - 25, size.height / 2 - 20), 8, paint);
    canvas.drawCircle(Offset(size.width / 2 + 25, size.height / 2 - 20), 8, paint);

    // ابتسامة
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2 + 10), radius: 40),
      0,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
