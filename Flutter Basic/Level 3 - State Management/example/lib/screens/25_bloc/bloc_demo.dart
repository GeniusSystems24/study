import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// شاشة عرض BLoC - الموضوع 25
class BlocDemo extends StatelessWidget {
  const BlocDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => WeatherBloc()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => TimerBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLoC Pattern'),
        ),
        body: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'مقدمة'),
                  Tab(text: 'Counter'),
                  Tab(text: 'Weather API'),
                  Tab(text: 'Login Form'),
                  Tab(text: 'Timer'),
                  Tab(text: 'Multi-BLoC'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _IntroTab(),
                    _CounterTab(),
                    _WeatherTab(),
                    _LoginTab(),
                    _TimerTab(),
                    _MultiBlockTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Events
abstract class CounterEvent {}

class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// State
class CounterState {
  final int count;
  const CounterState(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.count + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.count - 1)));
    on<Reset>((event, emit) => emit(const CounterState(0)));
  }
}

// ========== Weather BLoC ==========
abstract class WeatherEvent {}
class LoadWeather extends WeatherEvent {
  final String city;
  LoadWeather(this.city);
}

abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final String city;
  final String temperature;
  final String description;
  final String icon;
  WeatherLoaded(this.city, this.temperature, this.description, this.icon);
}
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<LoadWeather>((event, emit) async {
      emit(WeatherLoading());
      
      try {
        // محاكاة استدعاء API
        await Future.delayed(const Duration(seconds: 2));
        
        // بيانات وهمية
        final temp = (20 + (event.city.length % 15)).toString();
        final weathers = ['☀️ مشمس', '⛅ غائم جزئياً', '🌧️ ممطر', '⛈️ عاصف'];
        final description = weathers[event.city.length % weathers.length];
        
        emit(WeatherLoaded(event.city, temp, description, description.split(' ')[0]));
      } catch (e) {
        emit(WeatherError('فشل جلب بيانات الطقس'));
      }
    });
  }
}

// ========== Login BLoC ==========
abstract class LoginEvent {}
class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}
class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}
class LoginSubmitted extends LoginEvent {}
class LoginLogout extends LoginEvent {}

class LoginState {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;
  
  LoginState({
    this.email = '',
    this.password = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorMessage,
  });
  
  LoginState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage,
    );
  }
  
  bool get isFormValid => isEmailValid && isPasswordValid && email.isNotEmpty && password.isNotEmpty;
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final isValid = event.email.contains('@') && event.email.length > 3;
      emit(state.copyWith(email: event.email, isEmailValid: isValid));
    });
    
    on<LoginPasswordChanged>((event, emit) {
      final isValid = event.password.length >= 6;
      emit(state.copyWith(password: event.password, isPasswordValid: isValid));
    });
    
    on<LoginSubmitted>((event, emit) async {
      if (!state.isFormValid) return;
      
      emit(state.copyWith(isSubmitting: true));
      
      try {
        await Future.delayed(const Duration(seconds: 2));
        
        if (state.password == '123456') {
          emit(state.copyWith(
            isSubmitting: false,
            isSuccess: true,
            isFailure: false,
          ));
        } else {
          emit(state.copyWith(
            isSubmitting: false,
            isSuccess: false,
            isFailure: true,
            errorMessage: 'كلمة المرور خاطئة! حاول 123456',
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isSubmitting: false,
          isFailure: true,
          errorMessage: 'حدث خطأ',
        ));
      }
    });
    
    on<LoginLogout>((event, emit) {
      emit(LoginState());
    });
  }
}

// ========== Timer BLoC ==========
abstract class TimerEvent {}
class TimerStarted extends TimerEvent {
  final int duration;
  TimerStarted(this.duration);
}
class TimerTicked extends TimerEvent {
  final int duration;
  TimerTicked(this.duration);
}
class TimerPaused extends TimerEvent {}
class TimerResumed extends TimerEvent {}
class TimerReset extends TimerEvent {}

abstract class TimerState {
  final int duration;
  const TimerState(this.duration);
}

class TimerInitial extends TimerState {
  const TimerInitial(super.duration);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);
}

class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  
  TimerBloc() : super(const TimerInitial(_duration)) {
    on<TimerStarted>((event, emit) async {
      emit(TimerRunInProgress(event.duration));
      for (int i = event.duration; i > 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (state is! TimerRunInProgress) break;
        if (i == 1) {
          add(TimerReset());
        } else {
          add(TimerTicked(i - 1));
        }
      }
    });
    
    on<TimerTicked>((event, emit) {
      emit(TimerRunInProgress(event.duration));
    });
    
    on<TimerPaused>((event, emit) {
      if (state is TimerRunInProgress) {
        emit(TimerRunPause(state.duration));
      }
    });
    
    on<TimerResumed>((event, emit) {
      if (state is TimerRunPause) {
        emit(TimerRunInProgress(state.duration));
      }
    });
    
    on<TimerReset>((event, emit) {
      emit(const TimerInitial(_duration));
    });
  }
}

// التاب الأول: مقدمة
class _IntroTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 BLoC Pattern',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'BLoC (Business Logic Component) هو pattern لفصل Business Logic '
                  'عن UI باستخدام Streams.\n\n'
                  'تم تطويره من Google ويعتمد على:\n'
                  '• Events (الأحداث)\n'
                  '• States (الحالات)\n'
                  '• Streams (التدفقات)',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 المكونات الأساسية',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('1. Events → ما يحدث (مثل: Increment, Decrement)'),
                const Text('2. States → الحالة الحالية (مثل: CounterState)'),
                const Text('3. BLoC → معالج الأحداث ومُصدر الحالات'),
                const Text('4. UI → عرض الحالة وإرسال الأحداث'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ المزايا',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const Text('✓ فصل تام بين UI و Business Logic'),
                const Text('✓ سهولة اختبار الكود (Testability)'),
                const Text('✓ إعادة استخدام البيانات'),
                const Text('✓ مثالي للتطبيقات الكبيرة'),
                const Text('✓ DevTools ممتازة'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.orange.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'الهيكل الأساسي',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '// 1. تعريف الأحداث\n'
                      'class Increment extends CounterEvent {}\n\n'
                      '// 2. تعريف الحالات\n'
                      'class CounterState {\n'
                      '  final int count;\n'
                      '}\n\n'
                      '// 3. BLoC\n'
                      'class CounterBloc extends Bloc<CounterEvent, CounterState> {\n'
                      '  on<Increment>((event, emit) => emit(CounterState(state.count + 1)));\n'
                      '}\n\n'
                      '// 4. إرسال الأحداث\n'
                      'context.read<CounterBloc>().add(Increment());',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الثاني: Counter
class _CounterTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💼 BLoC Pattern',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'BLoC (Business Logic Component) هو pattern يفصل Business Logic '
                  'عن UI باستخدام Streams.\n\n'
                  'مثالي للتطبيقات المعقدة والكبيرة.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 المفاهيم الأساسية',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('1️⃣ Events - أحداث من UI'),
                const Text('2️⃣ BLoC - معالجة الأحداث'),
                const Text('3️⃣ States - حالات للـ UI'),
                const Text('4️⃣ BlocBuilder - بناء UI'),
                const Text('5️⃣ BlocProvider - تزويد BLoC'),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Counter Example
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'مثال: Counter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                BlocBuilder<CounterBloc, CounterState>(
                  builder: (context, state) {
                    return Text(
                      '${state.count}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterBloc>().add(Decrement());
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('تقليل'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterBloc>().add(Reset());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CounterBloc>().add(Increment());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('زيادة'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ المزايا',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text('✓ فصل تام بين UI و Logic'),
                const Text('✓ Testable بشكل ممتاز'),
                const Text('✓ Stream-based'),
                const Text('✓ مثالي للتطبيقات الكبيرة'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// التاب الثالث: Weather API
class _WeatherTab extends StatefulWidget {
  @override
  State<_WeatherTab> createState() => _WeatherTabState();
}

class _WeatherTabState extends State<_WeatherTab> {
  final _controller = TextEditingController(text: 'الرياض');
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'اسم المدينة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<WeatherBloc>().add(LoadWeather(_controller.text));
                },
                icon: const Icon(Icons.search),
                label: const Text('بحث'),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherInitial) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_outlined, size: 100, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'ابحث عن طقس مدينة',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<WeatherBloc>().add(LoadWeather('الرياض'));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('جلب طقس الرياض'),
                      ),
                    ],
                  ),
                );
              } else if (state is WeatherLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('جاري جلب بيانات الطقس...'),
                    ],
                  ),
                );
              } else if (state is WeatherLoaded) {
                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.icon,
                            style: const TextStyle(fontSize: 100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.city,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.temperature}°C',
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.description,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is WeatherError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 80, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

// التاب الرابع: Login Form
class _LoginTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم تسجيل الدخول بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isSuccess) {
            return Center(
              child: Card(
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 100, color: Colors.green),
                      const SizedBox(height: 16),
                      const Text(
                        'مرحباً!',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.email,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<LoginBloc>().add(LoginLogout());
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('تسجيل الخروج'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                '🔐 تسجيل الدخول',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  errorText: state.email.isNotEmpty && !state.isEmailValid
                      ? 'بريد إلكتروني غير صحيح'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<LoginBloc>().add(LoginEmailChanged(value));
                },
              ),
              
              const SizedBox(height: 16),
              
              TextField(
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  errorText: state.password.isNotEmpty && !state.isPasswordValid
                      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                      : null,
                ),
                obscureText: true,
                onChanged: (value) {
                  context.read<LoginBloc>().add(LoginPasswordChanged(value));
                },
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: state.isFormValid && !state.isSubmitting
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      : null,
                  icon: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(state.isSubmitting ? 'جاري الدخول...' : 'تسجيل الدخول'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Card(
                color: Colors.blue.withOpacity(0.1),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text('💡 للتجربة:'),
                      Text('كلمة المرور: 123456'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// التاب الخامس: Timer
class _TimerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⏱️',
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              Text(
                _formatDuration(state.duration),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 32),
              
              if (state is TimerInitial) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TimerBloc>().add(TimerStarted(state.duration));
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('ابدأ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
              ] else if (state is TimerRunInProgress) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TimerBloc>().add(TimerPaused());
                      },
                      icon: const Icon(Icons.pause),
                      label: const Text('إيقاف مؤقت'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TimerBloc>().add(TimerReset());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: (60 - state.duration) / 60,
                ),
              ] else if (state is TimerRunPause) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TimerBloc>().add(TimerResumed());
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('استئناف'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<TimerBloc>().add(TimerReset());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ] else if (state is TimerRunComplete) ...[
                const Text(
                  '🎉 انتهى الوقت!',
                  style: TextStyle(fontSize: 32, color: Colors.green),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TimerBloc>().add(TimerReset());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة البدء'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  
  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

// التاب السادس: Multi-BLoC
class _MultiBlockTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔗 Multi-BLoC Communication',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'يمكن للـ BLoCs التفاعل مع بعضها والاستماع لتغييرات بعضها البعض.',
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        BlocBuilder<CounterBloc, CounterState>(
          builder: (context, counterState) {
            return BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, weatherState) {
                return Card(
                  color: Colors.purple.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '📊 ملخص الحالات',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.numbers, color: Colors.blue),
                          title: const Text('Counter'),
                          trailing: Text(
                            '${counterState.count}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.cloud, color: Colors.orange),
                          title: const Text('Weather'),
                          trailing: Text(
                            weatherState is WeatherLoaded
                                ? weatherState.icon
                                : '—',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, loginState) {
                            return ListTile(
                              leading: Icon(
                                loginState.isSuccess ? Icons.check_circle : Icons.account_circle,
                                color: loginState.isSuccess ? Colors.green : Colors.grey,
                              ),
                              title: const Text('Login'),
                              trailing: Text(
                                loginState.isSuccess ? '✓ Logged In' : '✗ Logged Out',
                                style: TextStyle(
                                  color: loginState.isSuccess ? Colors.green : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<TimerBloc, TimerState>(
                          builder: (context, timerState) {
                            return ListTile(
                              leading: const Icon(Icons.timer, color: Colors.red),
                              title: const Text('Timer'),
                              trailing: Text(
                                timerState is TimerRunInProgress
                                    ? 'Running'
                                    : timerState is TimerRunPause
                                        ? 'Paused'
                                        : 'Stopped',
                                style: TextStyle(
                                  color: timerState is TimerRunInProgress
                                      ? Colors.green
                                      : timerState is TimerRunPause
                                          ? Colors.orange
                                          : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        Card(
          color: Colors.green.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'فوائد Multi-BLoC',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('✓ كل BLoC مستقل تماماً'),
                const Text('✓ يمكن إعادة استخدام كل BLoC'),
                const Text('✓ سهولة الاختبار'),
                const Text('✓ BLoCs يمكنها الاستماع لبعضها'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
