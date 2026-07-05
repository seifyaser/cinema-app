import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/di/dependency_injection.dart' as di;
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Cinematic Immersive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF131313),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF131313),
          onSurface: Color(0xFFE5E2E1),
          onSurfaceVariant: Color(0xFFD3C5AC),
          primary: Color(0xFFFFD165),
          onPrimary: Color(0xFF3F2E00),
          outline: Color(0xFF9B8F79),
          outlineVariant: Color(0xFF4F4633),
          error: Color(0xFFFFB4AB),
        ),
      ),
      routerConfig: AppRouter.router(),
    );
  }
}
