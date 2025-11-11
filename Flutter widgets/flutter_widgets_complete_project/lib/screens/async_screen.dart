import 'package:flutter/material.dart';

class AsyncScreen extends StatelessWidget {
  const AsyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async - العمليات غير المتزامنة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FutureBuilderExample(),
          SizedBox(height: 24),
          _StreamBuilderExample(),
        ],
      ),
    );
  }
}

class _FutureBuilderExample extends StatelessWidget {
  const _FutureBuilderExample();

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'تم تحميل البيانات بنجاح! 🎉';
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
              '⏳ FutureBuilder',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري التحميل...'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('خطأ: ${snapshot.error}'),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle, size: 60, color: Colors.green),
                        const SizedBox(height: 16),
                        Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamBuilderExample extends StatelessWidget {
  const _StreamBuilderExample();

  Stream<int> _countStream() async* {
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
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
              '📡 StreamBuilder',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            const Text('عداد من 1 إلى 10 (كل ثانية):'),
            const SizedBox(height: 16),
            StreamBuilder<int>(
              stream: _countStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('في انتظار البيانات...'),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('خطأ: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final count = snapshot.data!;
                  return Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(value: count / 10),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text(
                      'اكتمل! ✅',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
