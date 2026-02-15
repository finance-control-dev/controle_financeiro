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
      child: ListView(
        padding: EdgeInsets.zero,
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
              backgroundImage: NetworkImage(
                user?.photoURL ??
                    'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_rounded),
            title: const Text('Dashboard'),
            onTap: () {
               Navigator.pop(context); // Close drawer
               // Home is main route, maybe just pop
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
            leading: const Icon(Icons.search_rounded),
            title: const Text('Buscar'),
            onTap: () {
               Navigator.pop(context);
               Navigator.of(context).pushNamed('/transactions'); // Search is inside transactions for now
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
          ListTile(
            leading: const Icon(Icons.pie_chart_rounded),
            title: const Text('Gráficos'),
             onTap: () {
               Navigator.pop(context);
               Navigator.of(context).pushNamed('/charts');
            },
          ),
          const Divider(),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return ListTile(
                leading: Icon(
                  appProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: Text(
                  appProvider.themeMode == ThemeMode.dark
                      ? 'Modo Escuro'
                      : 'Modo Claro',
                ),
                trailing: Switch(
                  value: appProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) => appProvider.toggleTheme(),
                  activeColor: AppTheme.primary,
                ),
              );
            },
          ),
           ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            trailing: const Text('PT-BR'), // Mock for now
            onTap: () {
               // appProvider.toggleLanguage();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.danger),
            title: const Text('Sair', style: TextStyle(color: AppTheme.danger)),
            onTap: () => authProvider.signOut(),
          ),
        ],
      ),
    );
  }
}
