import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/ingredient_provider.dart';
import 'providers/transaction_provider.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/product_screen.dart';
import 'screens/ingredient_screen.dart';
import 'screens/transaction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };

  runApp(const EsPointApp());
}

class EsPointApp extends StatelessWidget {
  const EsPointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'esPoint',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const AppEntryPoint(),
        routes: {
          '/products': (_) => const ProductScreen(),
          '/ingredients': (_) => const IngredientScreen(),
          '/transactions': (_) => const TransactionScreen(),
        },
      ),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return auth.isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}
