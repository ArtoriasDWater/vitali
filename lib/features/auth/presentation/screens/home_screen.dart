import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/core/di/injection.dart';
import 'package:proyecto_hospital/core/theme/app_theme.dart';
import '../provider/auth_provider.dart';

//Importacion de las pantallas y providers para el navigatorBar
import '../../../medications/presentation/screens/medication_list_screen.dart';
import '../../../medications/presentation/screens/medication_form_screen.dart';
import '../../../medications/presentation/providers/medication_provider.dart';
import 'package:proyecto_hospital/features/caregivers/presentation/providers/caregivers_provider.dart';
import 'package:proyecto_hospital/features/caregivers/presentation/screens/caregivers_form_screen.dart';
import 'package:proyecto_hospital/features/caregivers/presentation/screens/caregivers_list_screen.dart';
import 'package:proyecto_hospital/features/chat/presentation/providers/chat_provider.dart';
import 'package:proyecto_hospital/features/chat/presentation/screens/chat_screen.dart';
import 'package:proyecto_hospital/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:proyecto_hospital/features/reminders/presentation/screens/reminder_form_screen.dart';
import 'package:proyecto_hospital/features/reminders/presentation/screens/reminders_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  Future<void> _logout(AuthProvider auth) async {
    await auth.logOut();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VITALI',
          style: TextStyle(
            color: AppTheme.light.colorScheme.onPrimary,
            fontSize: AppFontSize.headline,
          ),
        ),
        backgroundColor: AppTheme.light.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(authProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            ChangeNotifierProvider.value(
              value: getIt<MedicationProvider>(),
              child: MedicationListScreen(userId: userId),
            ),
            ChangeNotifierProvider.value(
              value: getIt<ReminderProvider>(),
              child: RemindersScreen(userId: userId),
            ),
            ChangeNotifierProvider.value(
              value: getIt<CaregiversProvider>(),
              child: CaregiversListScreen(userId: userId),
            ),
            ChangeNotifierProvider.value(
              value: getIt<ChatProvider>(),
              child: ChatScreen(userId: userId),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 3
          ? null
          : FloatingActionButton(
              tooltip: 'Agregar medicamento',
              onPressed: () {
                switch (_currentIndex) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MedicationFormScreen(userId: widget.userId),
                      ),
                    );
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReminderFormScreen(userId: widget.userId),
                      ),
                    );
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CaregiversFormScreen(userId: widget.userId),
                      ),
                    );
                }
              },
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Medication',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.cases_outlined),
            selectedIcon: Icon(Icons.cases),
            label: 'Caregivers',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
