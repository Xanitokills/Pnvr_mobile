import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnvr/loginScreen.dart';
import 'package:pnvr/menu.dart';

// Pantalla Módulo Expediente
class ExpedienteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Módulo Expediente'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        actions: [
          // Perfil sidebar
          Builder(
            builder: (context) => IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.green.shade600),
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildProfileSidebar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Selecciona el tipo de formulario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                  children: [
                    _buildFormCard(
                      context,
                      'Formulario de Trackeo',
                      Icons.track_changes,
                      Colors.blue,
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Formulario de Trackeo - En desarrollo',
                          ),
                        ),
                      ),
                    ),
                    _buildFormCard(
                      context,
                      'Formulario de Inspección',
                      Icons.assignment,
                      Colors.orange,
                      () => Navigator.pushNamed(context, '/inspeccion'),
                    ),
                    _buildFormCard(
                      context,
                      'Ver Inspecciones Realizadas',
                      Icons.list_alt,
                      Colors.purple,
                      () => Navigator.pushNamed(context, '/inspecciones-list'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Icon(icon, size: 48, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade600),
            accountName: Text('Usuario Admin'),
            accountEmail: Text('admin@sistema.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green.shade600, size: 40),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mi Perfil'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mi Perfil - En desarrollo')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Configuración - En desarrollo')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.sync),
            title: Text('Sincronizar'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sincronizando...')));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
