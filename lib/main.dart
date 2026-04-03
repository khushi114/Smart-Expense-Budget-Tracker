/// main.dart – Entry point of Smart Expense Tracker.
/// Sets up routes and Material theme.

import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/expense_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartExpenseApp());
}

class SmartExpenseApp extends StatelessWidget {
  const SmartExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // Blue primary
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/add_expense': (_) => const AddEditScreen(),
        '/expense_list': (_) => const ExpenseListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit_expense') {
          return MaterialPageRoute(
            builder: (_) => AddEditScreen(expense: settings.arguments as dynamic),
          );
        }
        return null;
      },
    );
  }
}
