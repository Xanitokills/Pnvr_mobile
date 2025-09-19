import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnvr/loginScreen.dart';

// Pantalla de Menú Principal
class MenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> modules = [
    {
      'title': 'Módulo UGS',
      'icon': Icons.location_on,
      'color': Colors.blue,
      'route': '/ugs',
    },
    {
      'title': 'Módulo Expediente',
      'icon': Icons.folder,
      'color': Colors.green,
      'route': '/expediente',
    },
    {
      'title': 'Geovisor V6 Supervisores',
      'icon': Icons.map,
      'color': Colors.orange,
      'route': '/geovisor',
    },
    {
      'title': 'Módulo UATS',
      'icon': Icons.engineering,
      'color': Colors.purple,
      'route': '/uats',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          // Perfil de usuario
          PopupMenuButton(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue.shade600),
                  ),
                  SizedBox(width: 8),
                  Text('Usuario', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Ver Perfil'),
                  onTap: () => _showProfileDialog(context),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión'),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    if (module['route'] == '/expediente') {
                      Navigator.pushNamed(context, '/expediente');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${module['title']} - En desarrollo'),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          module['color'].withOpacity(0.8),
                          module['color'].withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(module['icon'], size: 48, color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          module['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.blue.shade600),
            SizedBox(width: 8),
            Text('Perfil de Usuario'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue.shade600,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('Usuario: admin@sistema.com', style: TextStyle(fontSize: 16)),
            Text('Perfil: Administrador', style: TextStyle(fontSize: 16)),
            Text(
              'Última conexión: ${DateTime.now().toString().substring(0, 16)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
