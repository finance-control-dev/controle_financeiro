import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              user?.displayName ?? 'Usuário',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, color: AppTheme.primary)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('Dashboard'),
            onTap: () {
               Navigator.pop(context); // Close drawer
               Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('Transações'),
             onTap: () {
               Navigator.pop(context);
               Navigator.of(context).pushNamed('/transactions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_rounded),
            title: const Text('Metas'),
             onTap: () {
               Navigator.pop(context);
               Navigator.of(context).pushNamed('/goals');
            },
          ),
          const Divider(),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return SwitchListTile(
                 secondary: Icon(
                  appProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: Text(
                  appProvider.themeMode == ThemeMode.dark
                      ? 'Modo Escuro'
                      : 'Modo Claro',
                ),
                value: appProvider.themeMode == ThemeMode.dark,
                onChanged: (value) => appProvider.toggleTheme(),
              );
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.error),
            title: const Text('Sair', style: TextStyle(color: AppTheme.error)),
            onTap: () => authProvider.signOut(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
