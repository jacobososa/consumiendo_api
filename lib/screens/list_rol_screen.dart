import 'package:flutter/material.dart';
import '../services/rol_service.dart';
import '../models/rol.dart';

class ListRolScreen extends StatefulWidget {
  const ListRolScreen({super.key});

  @override
  State<ListRolScreen> createState() => _ListRolScreenState();
}

class _ListRolScreenState extends State<ListRolScreen> {
  final RolService rolService = RolService();

  List<Rol> roles = [];

  @override
  void initState() {
    //Cargar al inicio los roles
    super.initState();
    _loadRoles(); //Cargar informacion de los roles
  }

  Future<void> _loadRoles() async {
    try {
      final fetchedRoles = await rolService.getRoles();
      setState(() {
        roles = fetchedRoles;
      });
    } catch (e) {
      print("Error cargando roles $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cargar los roles. Intenta nuevamente.')));
    }
  }

  void _registerRol(
      int idRol, String nombre, String descripcion, String estado) async {
    // Expresiones regulares para las validaciones
    final RegExp idRolRegEx = RegExp(r'^\d+$'); // Solo números para el idRol
    final RegExp nombreRegEx =
        RegExp(r'^[a-zA-Z0-9\s]+$'); // Letras, números y espacios
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9\s\.,;]+$'); // Letras, números y caracteres especiales
    final RegExp estadoRegEx = RegExp(r'^(activo|inactivo)$',
        caseSensitive: false); // Estado puede ser 'activo' o 'inactivo'

    // Validación de idRol
    if (!idRolRegEx.hasMatch(idRol.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El ID de rol debe ser un número válido')),
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
      await rolService.createRol(idRol, nombre, descripcion, estado);
      await _loadRoles(); // Refrescar la lista de roles
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rol creado exitosamente!'),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hubo un problema al crear el rol $e')));
    }
  }

  void _editRol(int idRol, String nombre, String descripcion, estado) async {
    // Expresiones regulares para las validaciones
    final RegExp nombreRegEx =
        RegExp(r'^[a-zA-Z0-9\s]+$'); // Letras, números y espacios
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9\s\.,;]+$'); // Letras, números y caracteres especiales
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
      await rolService.updateRol(idRol, nombre, descripcion, estado);
      await _loadRoles();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rol actualizado exitosamente')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Hubo un problema al actualizar el rol $e'),
      ));
    }
  }

  void showRegisterModalRol() {
    final TextEditingController idRolController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController =
        TextEditingController();
    final TextEditingController estadoController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registrar rol'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  controller: idRolController,
                  decoration: const InputDecoration(
                      hintText: 'ID Rol',
                      labelText: 'Enter Id Rol',
                      icon: Icon(Icons.numbers_rounded)),
                ),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                      hintText: 'Nombre',
                      labelText: 'Enter nombre',
                      icon: Icon(Icons.person_pin_circle)),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                      hintText: 'Descripcion',
                      labelText: 'Enter descripcion',
                      icon: Icon(Icons.description_rounded)),
                ),
                TextFormField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                      hintText: 'Estado',
                      labelText: 'Enter estado',
                      icon: Icon(Icons.description_rounded)),
                )
              ],
            )),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    final idRol = int.parse(idRolController.text.trim());
                    final nombre = nombreController.text.trim();
                    final descripcion = descripcionController.text.trim();
                    final estado = estadoController.text.trim();

                    print('$idRol $nombre $descripcion $estado');
                    _registerRol(idRol, nombre, descripcion, estado);
                  },
                  child: const Text('Registrar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar la modal
                  },
                  child: Text('Cancelar'))
            ],
          );
        });
  }

  void showEditModalRol(
      int idRol, String nombre, String descripcion, String estado) {
    final TextEditingController idRolController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController =
        TextEditingController();
    final TextEditingController estadoController = TextEditingController();

    //Asignar colores a las cajas de texto
    idRolController.text = idRol.toString();
    nombreController.text = nombre;
    descripcionController.text = descripcion;
    estadoController.text = estado;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Editar rol'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: idRolController,
                    decoration: const InputDecoration(
                        hintText: 'idRol',
                        labelText: 'Enter ID rol',
                        icon: Icon(Icons.numbers_rounded)),
                  ),
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                        hintText: 'Nombre',
                        labelText: 'Enter nombre',
                        icon: Icon(Icons.colorize_outlined)),
                  ),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                        hintText: 'Descripcion',
                        labelText: 'Enter descripcion',
                        icon: Icon(Icons.model_training_outlined)),
                  ),
                  TextFormField(
                    controller: estadoController,
                    decoration: const InputDecoration(
                        hintText: 'Estado',
                        labelText: 'Enter estado',
                        icon: Icon(Icons.sunny)),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    final idRol0 = int.parse(idRolController.text.trim());
                    final nombre0 = nombreController.text.trim();
                    final descripcion0 = descripcionController.text.trim();
                    final estado0 = estadoController.text.trim();

                    print('$idRol0 $nombre0 $descripcion0 $estado0');
                    _editRol(idRol0, nombre0, descripcion0, estado0);
                  },
                  child: Text('Guardar')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'))
            ],
          );
        });
  }

  void showDeleteModalRol(
      int idRol, String nombre, String descripcion, String estado) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar el Rol'),
          content: Text('Tu enserio quieres eliminar el Rol?'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              label: Text('Cancel', style: TextStyle(color: Colors.lightBlue)),
              icon: Icon(Icons.cancel_rounded),
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                label: Text('Confirmar'),
                icon: Icon(Icons.confirmation_num_rounded),
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 215, 216)))
          ],
        );
      },
    );
    if (confirmDelete == true) {
      await rolService.deleteRol(idRol);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Rol eliminado exitosamente')));
      _loadRoles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Lista de Roles",
            style: TextStyle(
              color:
                  Color.fromARGB(255, 247, 48, 30), // Color rojo para el título
              fontWeight: FontWeight.bold, // Negrita para el título
            ),
          ),
        ),
        backgroundColor: Colors.white, // Fondo blanco para el AppBar
      ),
      body: FutureBuilder<List<Rol>>(
        future: rolService
            .getRoles(), // Suponiendo que tienes un método para obtener roles
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ocurrió un error al cargar los roles'));
          } else {
            final roles = snapshot.data ?? [];

            // Controlador del buscador
            final TextEditingController searchController =
                TextEditingController();

            // Lista filtrada de roles
            List<Rol> rolesFiltrados = roles;

            void actualizarBusqueda(String query) {
              rolesFiltrados = roles
                  .where((rol) =>
                      rol.nombre.toLowerCase().contains(query.toLowerCase()))
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
                          labelText: "Buscar rol por nombre",
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 247, 48, 30), // Rojo
                            fontWeight: FontWeight.bold, // Negrita
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 247, 48, 30), // Rojo
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 247, 48, 30), // Rojo
                              width: 2.0,
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
                    // Lista de roles
                    Expanded(
                      child: ListView.builder(
                        itemCount: rolesFiltrados.length,
                        itemBuilder: (context, index) {
                          final rol = rolesFiltrados[index];
                          return Card(
                            elevation: 5, // Sombra para destacar el ítem
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8, // Separación vertical entre ítems
                              horizontal: 8, // Separación horizontal
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Fondo blanco para el cuadro
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(
                                          255, 252, 5, 5), // Sombra roja
                                      blurRadius: 10, // Desenfoque de la sombra
                                      offset: Offset(
                                          0, 4), // Desplazamiento de la sombra
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título ID
                                    Text(
                                      'ID: ${rol.idRol}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Título Nombre
                                    Text(
                                      rol.nombre,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 247, 48,
                                            30), // Color rojo para el nombre
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Título Descripción
                                    Text(
                                      'Descripción: ${rol.descripcion}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 5),
                                    // Título Estado
                                    Text(
                                      'Estado: ${rol.estado}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                    const SizedBox(height: 10),
                                    // Modificación de los botones por íconos
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20, // Ícono más pequeño
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                          ),
                                          onPressed: () {
                                            showEditModalRol(
                                              rol.idRol,
                                              rol.nombre,
                                              rol.descripcion,
                                              rol.estado,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20, // Ícono más pequeño
                                            color:
                                                Color.fromARGB(255, 255, 17, 0),
                                          ),
                                          onPressed: () {
                                            showDeleteModalRol(
                                              rol.idRol,
                                              rol.nombre,
                                              rol.descripcion,
                                              rol.estado,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
        onPressed: showRegisterModalRol,
        backgroundColor:
            const Color.fromARGB(255, 247, 48, 30), // Rojo para el ícono
        child: const Icon(Icons.add, size: 30), // Solo el ícono de +
      ),
    );
  }
}
