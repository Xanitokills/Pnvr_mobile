import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pantalla Formulario de Inspección
class InspeccionFormScreen extends StatefulWidget {
  @override
  _InspeccionFormScreenState createState() => _InspeccionFormScreenState();
}

class _InspeccionFormScreenState extends State<InspeccionFormScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form field controllers and state variables
  String? _selectedDni;
  String _codigoConvenio = '';
  String _departamento = '';
  String _provincia = '';
  String _distrito = '';
  String _centroPoblado = '';
  String _comunidad = '';
  double? _latitud;
  double? _longitud;
  double? _latitudCarretera;
  double? _longitudCarretera;
  bool? _recibiInformacion;
  String _observacionesGenerales = '';
  bool? _documentosEnRegla;
  String _tipoDocumento = 'titulo_propiedad';
  String _otroDocumento = '';
  bool? _cumpleMedidas;
  double _pendienteTerreno = 0.0;
  bool? _zonaRiesgo;
  String _descripcionRiesgo = '';

  final List<String> _dnisList = [
    '12345678 - Juan Pérez',
    '23456789 - María García',
    '34567890 - Carlos López',
    '45678901 - Ana Martínez',
    '56789012 - Luis Rodríguez',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade800,
        title: Text(
          'Formulario de Inspección',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Modern Progress Indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_totalSteps, (index) {
                    return _buildStepIndicator(index);
                  }),
                ),
                SizedBox(height: 12),
                Text(
                  _getStepTitle(_currentStep),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          // Form Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentStep = page;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                children: [
                  _buildStep1(), // Beneficiario y ubicación
                  _buildStep2(), // Documentación
                  _buildStep3(), // Inspección técnica
                  _buildStep4(), // Finalizar
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousStep,
                      icon: Icon(Icons.arrow_back_ios, size: 16),
                      label: Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 16),
                Expanded(
                  flex: _currentStep > 0 ? 1 : 2,
                  child: ElevatedButton.icon(
                    onPressed: _currentStep < _totalSteps - 1
                        ? _nextStep
                        : _finalizeInspection,
                    icon: Icon(
                      _currentStep < _totalSteps - 1
                          ? Icons.arrow_forward_ios
                          : Icons.check_circle,
                      size: 16,
                    ),
                    label: Text(
                      _currentStep < _totalSteps - 1
                          ? 'Siguiente'
                          : 'Finalizar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    bool isActive = index <= _currentStep;
    bool isCurrent = index == _currentStep;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.orange.shade600 : Colors.grey.shade200,
        border: Border.all(
          color: isCurrent ? Colors.orange.shade800 : Colors.transparent,
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.orange.shade600.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: isActive
            ? Icon(
                index < _currentStep ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              )
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Beneficiario y Ubicación';
      case 1:
        return 'Documentación';
      case 2:
        return 'Inspección Técnica';
      case 3:
        return 'Finalización';
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _finalizeInspection() {
    // Show a selection dialog for save options
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Guardar Inspección',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            _buildSaveOption(
              icon: Icons.save_alt,
              title: 'Guardar Offline',
              subtitle: 'Sincronizar más tarde',
              color: Colors.orange.shade600,
              onTap: () {
                Navigator.pop(context);
                _showSaveDialog(context, 'offline');
              },
            ),
            SizedBox(height: 16),
            _buildSaveOption(
              icon: Icons.cloud_upload,
              title: 'Sincronizar Ahora',
              subtitle: 'Enviar al servidor',
              color: Colors.blue.shade600,
              onTap: () {
                Navigator.pop(context);
                _showSaveDialog(context, 'sync');
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({required Widget child, String? title}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }

  // STEP 1: Beneficiario y Ubicación
  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24),
          _buildModernCard(
            title: 'Seleccionar Beneficiario',
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'DNI del Beneficiario',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.orange.shade600,
                      ),
                    ),
                    value: _selectedDni,
                    items: _dnisList.map((dni) {
                      return DropdownMenuItem(value: dni, child: Text(dni));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDni = value;
                        _codigoConvenio = 'CONV-2024-001';
                        _departamento = 'Lima';
                        _provincia = 'Lima';
                        _distrito = 'San Juan de Lurigancho';
                        _centroPoblado = 'Zárate';
                        _comunidad = 'Los Olivos';
                      });
                    },
                  ),
                ),
                if (_selectedDni != null) ...[
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Datos Recuperados Automáticamente',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildInfoRow('Código Convenio', _codigoConvenio),
                        _buildInfoRow('Departamento', _departamento),
                        _buildInfoRow('Provincia', _provincia),
                        _buildInfoRow('Distrito', _distrito),
                        _buildInfoRow('Centro Poblado', _centroPoblado),
                        _buildInfoRow('Comunidad', _comunidad),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildModernCard(
            title: 'Ubicación del Terreno',
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 48,
                        color: Colors.blue.shade600,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Obtener ubicación GPS del terreno',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _latitud = -12.046373;
                            _longitud = -77.042754;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ubicación obtenida exitosamente'),
                              backgroundColor: Colors.green.shade600,
                            ),
                          );
                        },
                        icon: Icon(Icons.gps_fixed),
                        label: Text('Obtener Ubicación'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_latitud != null && _longitud != null) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ubicación Obtenida',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        _buildInfoRow('Latitud', _latitud!.toStringAsFixed(6)),
                        _buildInfoRow(
                          'Longitud',
                          _longitud!.toStringAsFixed(6),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // STEP 2: Documentación
  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24),
          _buildModernCard(
            title: 'Información Previa',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿El beneficiario recibió la información antes?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioOption(
                        title: 'Sí',
                        value: true,
                        groupValue: _recibiInformacion,
                        onChanged: (value) {
                          setState(() {
                            _recibiInformacion = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildRadioOption(
                        title: 'No',
                        value: false,
                        groupValue: _recibiInformacion,
                        onChanged: (value) {
                          setState(() {
                            _recibiInformacion = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildModernCard(
            title: 'Documentos de Propiedad',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Los documentos están en regla?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioOption(
                        title: 'Sí',
                        value: true,
                        groupValue: _documentosEnRegla,
                        onChanged: (value) {
                          setState(() {
                            _documentosEnRegla = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildRadioOption(
                        title: 'No',
                        value: false,
                        groupValue: _documentosEnRegla,
                        onChanged: (value) {
                          setState(() {
                            _documentosEnRegla = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de documento',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.description,
                        color: Colors.orange.shade600,
                      ),
                    ),
                    value: _tipoDocumento,
                    items: [
                      DropdownMenuItem(
                        value: 'titulo_propiedad',
                        child: Text('Título de Propiedad'),
                      ),
                      DropdownMenuItem(
                        value: 'constancia_posesion',
                        child: Text('Constancia de Posesión'),
                      ),
                      DropdownMenuItem(value: 'otro', child: Text('Otro')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _tipoDocumento = value!;
                      });
                    },
                  ),
                ),
                if (_tipoDocumento == 'otro') ...[
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Especifique el tipo de documento',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        _otroDocumento = value;
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildModernCard(
            title: 'Observaciones Generales',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Observaciones sobre documentación e información',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Escriba cualquier observación relevante...',
                ),
                onChanged: (value) {
                  _observacionesGenerales = value;
                },
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRadioOption<T>({
    required String title,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: groupValue == value
              ? Colors.orange.shade50
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: groupValue == value
                ? Colors.orange.shade300
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Colors.orange.shade600,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: groupValue == value
                    ? Colors.orange.shade700
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 3: Inspección Técnica
  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24),
          _buildModernCard(
            title: 'Medidas del Terreno',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿El terreno cumple con las medidas de 8x9 m²?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioOption(
                        title: 'Sí',
                        value: true,
                        groupValue: _cumpleMedidas,
                        onChanged: (value) {
                          setState(() {
                            _cumpleMedidas = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildRadioOption(
                        title: 'No',
                        value: false,
                        groupValue: _cumpleMedidas,
                        onChanged: (value) {
                          setState(() {
                            _cumpleMedidas = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Pendiente del terreno (%)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.trending_up,
                        color: Colors.orange.shade600,
                      ),
                      suffixText: '%',
                    ),
                    onChanged: (value) {
                      _pendienteTerreno = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ],
            ),
          ),
          _buildModernCard(
            title: 'Evaluación de Riesgos',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿El terreno está en zona de riesgo?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioOption(
                        title: 'Sí',
                        value: true,
                        groupValue: _zonaRiesgo,
                        onChanged: (value) {
                          setState(() {
                            _zonaRiesgo = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildRadioOption(
                        title: 'No',
                        value: false,
                        groupValue: _zonaRiesgo,
                        onChanged: (value) {
                          setState(() {
                            _zonaRiesgo = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_zonaRiesgo == true) ...[
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Describa la zona de riesgo',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Detalle los riesgos identificados...',
                      ),
                      onChanged: (value) {
                        _descripcionRiesgo = value;
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  // STEP 4: Finalización
  Widget _buildStep4() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24),
          _buildModernCard(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 64,
                        color: Colors.green.shade600,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Inspección Completada',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Todos los datos han sido recopilados exitosamente',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Seleccione cómo desea proceder:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 24),
                _buildSaveOption(
                  icon: Icons.save_alt,
                  title: 'Guardar en Bandeja de Salida',
                  subtitle: 'Sincronizar más tarde cuando tenga conexión',
                  color: Colors.orange.shade600,
                  onTap: () => _showSaveDialog(context, 'offline'),
                ),
                SizedBox(height: 16),
                _buildSaveOption(
                  icon: Icons.cloud_upload,
                  title: 'Sincronizar Ahora',
                  subtitle: 'Enviar inmediatamente al servidor',
                  color: Colors.blue.shade600,
                  onTap: () => _showSaveDialog(context, 'sync'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSaveOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context, String saveType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                saveType == 'offline' ? Icons.save_alt : Icons.cloud_upload,
                color: Colors.green.shade600,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                saveType == 'offline'
                    ? 'Guardado Exitoso'
                    : 'Sincronización Exitosa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              saveType == 'offline'
                  ? 'La inspección se ha guardado en la bandeja de salida. Podrá sincronizarla más tarde cuando tenga conexión a internet.'
                  : 'La inspección se ha sincronizado exitosamente con el servidor. Los datos han sido enviados correctamente.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ID de Inspección: INS-${DateTime.now().millisecondsSinceEpoch}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar dialog
              Navigator.pop(context); // Volver a la pantalla anterior
            },
            child: Text(
              'Aceptar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
