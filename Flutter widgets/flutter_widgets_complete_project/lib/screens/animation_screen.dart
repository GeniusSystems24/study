import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation & Motion')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ImplicitAnimationsSection(),
          SizedBox(height: 24),
          _ExplicitAnimationsSection(),
          SizedBox(height: 24),
          _HeroAnimationSection(),
        ],
      ),
    );
  }
}

// Implicit Animations
class _ImplicitAnimationsSection extends StatefulWidget {
  const _ImplicitAnimationsSection();

  @override
  State<_ImplicitAnimationsSection> createState() =>
      _ImplicitAnimationsSectionState();
}

class _ImplicitAnimationsSectionState
    extends State<_ImplicitAnimationsSection> {
  bool _expanded = false;
  double _opacity = 1.0;
  double _turns = 0.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ Implicit Animations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            
            // AnimatedContainer
            const Text('AnimatedContainer:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: _expanded ? 200 : 100,
                height: _expanded ? 200 : 100,
                decoration: BoxDecoration(
                  color: _expanded ? Colors.blue : Colors.red,
                  borderRadius: BorderRadius.circular(_expanded ? 100 : 20),
                ),
                child: const Center(
                  child: Text(
                    'انقر',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: const Text('تغيير الحجم'),
              ),
            ),
            const Divider(height: 32),
            
            // AnimatedOpacity
            const Text('AnimatedOpacity:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.green,
                  child: const Center(
                    child: Text('أنا أتلاشى', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: _opacity,
              onChanged: (value) => setState(() => _opacity = value),
            ),
            const Divider(height: 32),
            
            // AnimatedRotation
            const Text('AnimatedRotation:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: AnimatedRotation(
                turns: _turns,
                duration: const Duration(milliseconds: 500),
                child: const Icon(Icons.refresh, size: 80, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () => setState(() => _turns += 0.25),
                child: const Text('تدوير 90°'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Explicit Animations
class _ExplicitAnimationsSection extends StatefulWidget {
  const _ExplicitAnimationsSection();

  @override
  State<_ExplicitAnimationsSection> createState() =>
      _ExplicitAnimationsSectionState();
}

class _ExplicitAnimationsSectionState extends State<_ExplicitAnimationsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎬 Explicit Animations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.star, size: 50, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.forward(),
                  child: const Text('تشغيل'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.reverse(),
                  child: const Text('عكس'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.repeat(),
                  child: const Text('تكرار'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.stop(),
                  child: const Text('إيقاف'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Hero Animation
class _HeroAnimationSection extends StatelessWidget {
  const _HeroAnimationSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🦸 Hero Animation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            const Text('انقر على الصورة لرؤية انتقال Hero:'),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const _HeroDetailScreen(),
                  ),
                );
              },
              child: Hero(
                tag: 'hero-image',
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.image, size: 80, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroDetailScreen extends StatelessWidget {
  const _HeroDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحة التفاصيل')),
      body: Center(
        child: Hero(
          tag: 'hero-image',
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.cyan, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.image, size: 150, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
