import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pantalla Lista de Inspecciones
class InspeccionesListScreen extends StatefulWidget {
  @override
  _InspeccionesListScreenState createState() => _InspeccionesListScreenState();
}

class _InspeccionesListScreenState extends State<InspeccionesListScreen> {
  final List<Map<String, dynamic>> _inspecciones = [
    {
      'id': '001',
      'dni': '12345678',
      'beneficiario': 'Juan Pérez',
      'fecha': '2024-09-15',
      'estado': 'enviado',
      'ubicacion': 'San Juan de Lurigancho',
    },
    {
      'id': '002',
      'dni': '23456789',
      'beneficiario': 'María García',
      'fecha': '2024-09-16',
      'estado': 'pendiente',
      'ubicacion': 'Villa El Salvador',
    },
    {
      'id': '003',
      'dni': '34567890',
      'beneficiario': 'Carlos López',
      'fecha': '2024-09-17',
      'estado': 'borrador',
      'ubicacion': 'Ate Vitarte',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspecciones Realizadas'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sincronizando inspecciones...')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _inspecciones.length,
          itemBuilder: (context, index) {
            final inspeccion = _inspecciones[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: _getEstadoColor(inspeccion['estado']),
                  child: Icon(
                    _getEstadoIcon(inspeccion['estado']),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  inspeccion['beneficiario'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DNI: ${inspeccion['dni']}'),
                    Text('Ubicación: ${inspeccion['ubicacion']}'),
                    Text('Fecha: ${inspeccion['fecha']}'),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getEstadoColor(
                          inspeccion['estado'],
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getEstadoText(inspeccion['estado']),
                        style: TextStyle(
                          color: _getEstadoColor(inspeccion['estado']),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.visibility),
                        title: Text('Ver'),
                        onTap: () {
                          Navigator.pop(context);
                          _showInspeccionDetails(context, inspeccion);
                        },
                      ),
                    ),
                    if (inspeccion['estado'] != 'enviado')
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/inspeccion');
                          },
                        ),
                      ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Eliminar'),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteDialog(context, inspeccion['id']);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/inspeccion');
        },
        backgroundColor: Colors.purple.shade600,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'enviado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'borrador':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'enviado':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.schedule;
      case 'borrador':
        return Icons.drafts;
      default:
        return Icons.help;
    }
  }

  String _getEstadoText(String estado) {
    switch (estado) {
      case 'enviado':
        return 'ENVIADO';
      case 'pendiente':
        return 'PENDIENTE';
      case 'borrador':
        return 'BORRADOR';
      default:
        return 'DESCONOCIDO';
    }
  }

  void _showInspeccionDetails(
    BuildContext context,
    Map<String, dynamic> inspeccion,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.assignment,
                    color: Colors.purple.shade600,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Detalles de Inspección',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailCard('ID', inspeccion['id']),
                    _buildDetailCard(
                      'Beneficiario',
                      inspeccion['beneficiario'],
                    ),
                    _buildDetailCard('DNI', inspeccion['dni']),
                    _buildDetailCard('Ubicación', inspeccion['ubicacion']),
                    _buildDetailCard('Fecha', inspeccion['fecha']),
                    _buildDetailCard(
                      'Estado',
                      _getEstadoText(inspeccion['estado']),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Datos de la Inspección:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildDetailCard('Coordenadas', '-12.046373, -77.042754'),
                    _buildDetailCard('Pendiente', '15%'),
                    _buildDetailCard('Zona de Riesgo', 'No'),
                    _buildDetailCard('Medidas Correctas', 'Sí'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmar Eliminación'),
          ],
        ),
        content: Text('¿Está seguro que desea eliminar esta inspección?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _inspecciones.removeWhere(
                  (inspeccion) => inspeccion['id'] == id,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Inspección eliminada')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
