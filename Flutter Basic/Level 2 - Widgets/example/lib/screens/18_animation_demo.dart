import 'package:flutter/material.dart';

/// شاشة توضيحية للـ Animation (الموضوع 18)
class AnimationDemo extends StatelessWidget {
  const AnimationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('18. Animation'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Basic'),
              Tab(text: 'Advanced'),
              Tab(text: 'Hero'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BasicAnimationsTab(),
            _AdvancedAnimationsTab(),
            _HeroAnimationTab(),
          ],
        ),
      ),
    );
  }
}

// تبويب الحركات الأساسية
class _BasicAnimationsTab extends StatefulWidget {
  const _BasicAnimationsTab();

  @override
  State<_BasicAnimationsTab> createState() => _BasicAnimationsTabState();
}

class _BasicAnimationsTabState extends State<_BasicAnimationsTab> {
  bool _isExpanded = false;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AnimatedContainer
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AnimatedContainer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: _isExpanded ? 200 : 100,
                    height: _isExpanded ? 200 : 100,
                    decoration: BoxDecoration(
                      color: _isExpanded ? Colors.blue : Colors.red,
                      borderRadius: BorderRadius.circular(_isExpanded ? 100 : 20),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: _isExpanded ? 100 : 50,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(_isExpanded ? 'تصغير' : 'تكبير'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // AnimatedOpacity
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AnimatedOpacity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Center(
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.star, size: 80, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _opacity,
                  onChanged: (value) => setState(() => _opacity = value),
                  min: 0.0,
                  max: 1.0,
                ),
                Text('الشفافية: ${(_opacity * 100).round()}%'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// تبويب الحركات المتقدمة
class _AdvancedAnimationsTab extends StatefulWidget {
  const _AdvancedAnimationsTab();

  @override
  State<_AdvancedAnimationsTab> createState() => _AdvancedAnimationsTabState();
}

class _AdvancedAnimationsTabState extends State<_AdvancedAnimationsTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('AnimationController', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 2 * 3.14159,
                      child: Transform.scale(
                        scale: 0.5 + (_animation.value * 0.5),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.lerp(Colors.blue, Colors.red, _animation.value),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.rotate_right, size: 50, color: Colors.white),
                        ),
                      ),
                    );
                  },
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
        ),
      ],
    );
  }
}

// تبويب Hero Animation
class _HeroAnimationTab extends StatelessWidget {
  const _HeroAnimationTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Hero Animation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('اضغط على الصورة لرؤية انتقال Hero'),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const _HeroDetailPage()),
            ),
            child: Hero(
              tag: 'hero-demo',
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo, size: 80, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDetailPage extends StatelessWidget {
  const _HeroDetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Detail')),
      body: Center(
        child: Hero(
          tag: 'hero-demo',
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.photo, size: 150, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
