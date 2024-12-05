import 'package:flutter/material.dart';
import '../services/permiso_service.dart';
import '../models/permiso.dart';
// ignore: unused_import
import '../buscador/buscadorPermisos.dart';

class ListPermisoScreen extends StatefulWidget {
  const ListPermisoScreen({super.key});

  @override
  State<ListPermisoScreen> createState() => _ListPermisoScreenState();
}

class _ListPermisoScreenState extends State<ListPermisoScreen> {
  final PermisoService permisoService = PermisoService();

  List<Permiso> permisos = [];

  @override
  void initState() {
    super.initState();
    _loadPermisos();
  }

  Future<void> _loadPermisos() async {
    try {
      final fetchedPermisos = await permisoService.getPermisos();
      setState(() {
        permisos = fetchedPermisos;
      });
    } catch (e) {
      print("Error cargando permisos $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al cargar los permisos. Intenta nuevamente.')),
      );
    }
  }

  void _registerPermiso(
      int idPermiso, String nombre, String descripcion, String estado) async {
    // Expresiones regulares para las validaciones
    final RegExp idPermisoRegEx = RegExp(r'^\d+$'); // Solo números para el ID
    final RegExp nombreRegEx = RegExp(
        r'^[a-zA-Z0-9\s]+$'); // Solo letras, números y espacios para el nombre
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9\s\.,;]+$'); // Letras, números y caracteres especiales comunes para la descripción
    final RegExp estadoRegEx = RegExp(r'^(activo|inactivo)$',
        caseSensitive: false); // Estado puede ser 'activo' o 'inactivo'

    // Validación de idPermiso
    if (!idPermisoRegEx.hasMatch(idPermiso.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El ID de permiso debe ser un número válido')),
      );
      return;
    }

    // Validación de nombre
    if (nombre.isEmpty || !nombreRegEx.hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('El nombre debe ser válido (letras, números y espacios)')),
      );
      return;
    }

    // Validación de descripción
    if (descripcion.isEmpty || !descripcionRegEx.hasMatch(descripcion)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La descripción debe ser válida (letras, números y algunos caracteres como .,;)')),
      );
      return;
    }

    // Validación de estado
    if (estado.isEmpty || !estadoRegEx.hasMatch(estado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El estado debe ser "activo" o "inactivo"')),
      );
      return;
    }
    try {
      await permisoService.createPermiso(
          idPermiso, nombre, descripcion, estado);
      await _loadPermisos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso creado exitosamente')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un problema al crear el permiso $e')),
      );
    }
  }

  void _editPermiso(
      int idPermiso, String nombre, String descripcion, String estado) async {
    // Expresiones regulares para las validaciones
    final RegExp nombreRegEx = RegExp(
        r'^[a-zA-Z0-9áéíóúñÑ\s]+$'); // Letras, números, espacios, y acentos
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9áéíóúñÑ\s\.,;]+$'); // Letras, números y caracteres especiales
    final RegExp estadoRegEx = RegExp(r'^(activo|inactivo)$',
        caseSensitive: false); // Estado puede ser 'activo' o 'inactivo'

    // Validación de nombre
    if (nombre.isEmpty || !nombreRegEx.hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('El nombre debe ser válido (letras, números y espacios)')),
      );
      return;
    }

    // Validación de descripción
    if (descripcion.isEmpty || !descripcionRegEx.hasMatch(descripcion)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La descripción debe ser válida (letras, números y algunos caracteres como .,;)')),
      );
      return;
    }

    // Validación de estado
    if (estado.isEmpty || !estadoRegEx.hasMatch(estado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El estado debe ser "activo" o "inactivo"')),
      );
      return;
    }

    try {
      await permisoService.updatePermiso(
          idPermiso, nombre, descripcion, estado);
      await _loadPermisos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso actualizado exitosamente')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un problema al actualizar el permiso $e')),
      );
    }
  }

  void showRegisterModalPermiso() {
    final TextEditingController idPermisoController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController =
        TextEditingController();
    final TextEditingController estadoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar permiso'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: idPermisoController,
                  decoration: const InputDecoration(
                    hintText: 'ID Permiso',
                    labelText: 'Enter Id Permiso',
                    icon: Icon(Icons.numbers_rounded),
                  ),
                ),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre',
                    labelText: 'Enter nombre',
                    icon: Icon(Icons.person_pin_circle),
                  ),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripcion',
                    labelText: 'Enter descripcion',
                    icon: Icon(Icons.description_rounded),
                  ),
                ),
                TextFormField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                    hintText: 'Estado',
                    labelText: 'Enter estado',
                    icon: Icon(Icons.description_rounded),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final idPermiso = int.parse(idPermisoController.text.trim());
                final nombre = nombreController.text.trim();
                final descripcion = descripcionController.text.trim();
                final estado = estadoController.text.trim();
                _registerPermiso(idPermiso, nombre, descripcion, estado);
              },
              child: const Text('Registrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void showEditModalPermiso(
      int idPermiso, String nombre, String descripcion, String estado) {
    final TextEditingController idPermisoController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController =
        TextEditingController();
    final TextEditingController estadoController = TextEditingController();

    // Asignar valores a las cajas de texto
    idPermisoController.text = idPermiso.toString();
    nombreController.text = nombre;
    descripcionController.text = descripcion;
    estadoController.text = estado;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar permiso'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: idPermisoController,
                  decoration: const InputDecoration(
                    hintText: 'idPermiso',
                    labelText: 'Enter ID permiso',
                    icon: Icon(Icons.numbers_rounded),
                  ),
                ),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre',
                    labelText: 'Enter nombre',
                    icon: Icon(Icons.colorize_rounded),
                  ),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripcion',
                    labelText: 'Enter descripcion',
                    icon: Icon(Icons.model_training_rounded),
                  ),
                ),
                TextFormField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                    hintText: 'Estado',
                    labelText: 'Enter estado',
                    icon: Icon(Icons.sunny),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final idPermiso0 = int.parse(idPermisoController.text.trim());
                final nombre0 = nombreController.text.trim();
                final descripcion0 = descripcionController.text.trim();
                final estado0 = estadoController.text.trim();
                _editPermiso(idPermiso0, nombre0, descripcion0, estado0);
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteModalPermiso(int idPermiso) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar el Permiso'),
          content: Text('¿Estás seguro de que quieres eliminar el permiso?'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              label: Text(
                'Cancelar',
                style: TextStyle(color: Colors.lightBlue),
              ),
              icon: Icon(Icons.cancel_rounded),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              label: Text('Confirmar'),
              icon: Icon(Icons.confirmation_num_rounded),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 213, 215, 216),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await permisoService.deletePermiso(idPermiso);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso eliminado exitosamente')),
      );
      _loadPermisos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Lista de Permisos", // Título en el AppBar
            style: TextStyle(
              color:
                  Color.fromARGB(255, 247, 48, 30), // Color rojo para el título
              fontWeight: FontWeight.bold, // Título en negrita
            ),
          ),
        ),
        backgroundColor: Colors.white, // Fondo blanco para el AppBar
        elevation: 0, // Sin sombra
      ),
      body: FutureBuilder<List<Permiso>>(
        future: permisoService.getPermisos(), // Obtener permisos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Ocurrió un error al cargar los permisos'));
          } else {
            final permisos = snapshot.data ?? [];

            // Controlador del buscador
            final TextEditingController searchController =
                TextEditingController();

            // Lista filtrada de permisos
            List<Permiso> permisosFiltrados = permisos;

            void actualizarBusqueda(String query) {
              permisosFiltrados = permisos
                  .where((permiso) => permiso.nombre
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
            }

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    // Buscador
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: "Buscar permiso por nombre",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 247, 48, 30), // Color rojo para el texto
                            fontWeight:
                                FontWeight.bold, // Negrita para el texto
                          ),
                          prefixIcon: const Icon(Icons.search,
                              color: Color.fromARGB(
                                  255, 247, 48, 30)), // Ícono rojo
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 247, 48, 30), // Borde rojo
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 247, 48,
                                  30), // Borde rojo cuando está enfocado
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            actualizarBusqueda(query);
                          });
                        },
                      ),
                    ),
                    // Lista de permisos
                    Expanded(
                      child: ListView.builder(
                        itemCount: permisosFiltrados.length,
                        itemBuilder: (context, index) {
                          final permiso = permisosFiltrados[index];
                          return Padding(
                            padding:
                                const EdgeInsets.all(10.0), // Añadimos margen
                            child: Container(
                              padding: const EdgeInsets.all(
                                  15.0), // Espaciado interno
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Fondo blanco para los cuadros
                                borderRadius: BorderRadius.circular(
                                    10), // Esquinas redondeadas
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 247, 48, 30)
                                        .withOpacity(0.2), // Sombra sutil roja
                                    offset: Offset(0, 4),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Mostrar ID
                                  Text(
                                    'ID: ${permiso.idPermiso}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Nombre y descripción
                                  Text(
                                    permiso.nombre,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 247, 48,
                                          30), // Color rojo para el nombre
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Descripción: ${permiso.descripcion}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Estado: ${permiso.estado}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.green),
                                  ),
                                  const SizedBox(height: 10),
                                  // Botones de acción con iconos
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showEditModalPermiso(
                                              permiso.idPermiso,
                                              permiso.nombre,
                                              permiso.descripcion,
                                              permiso.estado);
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: Color.fromARGB(255, 247, 48,
                                            30), // Icono de editar rojo
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () {
                                          showDeleteModalPermiso(
                                              permiso.idPermiso);
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors
                                            .red, // Icono de eliminar rojo
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar nuevo permiso',
        onPressed: showRegisterModalPermiso,
        backgroundColor:
            Color.fromARGB(255, 247, 48, 30),
        child: const Icon(Icons.add), // Botón flotante rojo
      ),
    );
  }
}
