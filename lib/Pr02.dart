import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:flutter/material.dart';

class Pr02 extends StatefulWidget {
  const Pr02({super.key});

  @override
  State<Pr02> createState() => _Pr02State();
}

class _Pr02State extends State<Pr02> {
  String titulo = "Practica 2 U3";
  Map<String, dynamic>? temporalJSON;
  String id = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("${titulo}"),
            centerTitle: true,
            bottom: TabBar(
                tabs: [
                  Icon(Icons.list_alt),
                  Icon(Icons.woman)
                ]
            ),
          ),
          body: TabBarView(
              children: [
                mostrarData(),
                capturarData()
              ]
          ),
        )
    );
  }
  Widget mostrarData(){
    return FutureBuilder(
        future: DB.mostrarTodas(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
              itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage("${listaJSON.data?[indice]['imagen']}"),
                    ),
                    title: Text("${listaJSON.data?[indice]['nombre']}"),
                    subtitle: Text("${listaJSON.data?[indice]['pelicula']}"),
                    trailing:
                    IconButton(
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (builder){
                                return AlertDialog(
                                  title: Text("Confirmar"),
                                  content: Text("Estas seguro que deseas eliminar a ${listaJSON.data?[indice]['nombre']}"),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          DB.eliminar(listaJSON.data?[indice]['id']).then((value) {
                                            setState(() {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se elimino la princesa :(")));
                                              Navigator.pop(context);
                                            });
                                          });
                                        },
                                        child: Text("Si")
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text("No")
                                    )
                                  ],
                                );
                              }
                          );
                        },
                        icon: Icon(Icons.delete)
                    ),
                    onTap: (){
                      temporalJSON = listaJSON.data?[indice];
                      id = listaJSON.data?[indice]['id'];
                      editarData();
                    },
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }
  final nombre = TextEditingController();
  final pelicula = TextEditingController();
  final edad = TextEditingController();
  final imagen = TextEditingController();
  Widget capturarData(){
    temporalJSON = {};

    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
            labelText: "Nombre:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: pelicula,
          decoration: InputDecoration(
              labelText: "Pelicula:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: edad,
          decoration: InputDecoration(
              labelText: "Edad:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: imagen,
          decoration: InputDecoration(
              labelText: "Imagen:"
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JsonTemporal = {
                    'nombre' : nombre.text,
                    'pelicula' : pelicula.text,
                    'edad' : int.parse(edad.text),
                    'imagen' : imagen.text
                  };

                  DB.insertar(JsonTemporal).then((value) {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exito al insertar")));
                      nombre.clear();
                      pelicula.clear();
                      edad.clear();
                      imagen.clear();
                    });
                  });
                },
                child: Text("Insertar")
            ),
            SizedBox(width: 40,),
            ElevatedButton(
                onPressed: (){
                  nombre.clear();
                  pelicula.clear();
                  edad.clear();
                  imagen.clear();
                },
                child: Text("Cancelar")
            )
          ],
        )
      ],
    );
  }
  void editarData(){
    final nombre = TextEditingController(text: temporalJSON?['nombre']);
    final pelicula = TextEditingController(text: temporalJSON?['pelicula']);
    final edad = TextEditingController(text: (temporalJSON?['edad']).toString());
    final imagen = TextEditingController(text: temporalJSON?['imagen']);

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom+30
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                    labelText: "Nombre:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: pelicula,
                  decoration: InputDecoration(
                      labelText: "Pelicula:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: edad,
                  decoration: InputDecoration(
                      labelText: "Edad:"
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: imagen,
                  decoration: InputDecoration(
                      labelText: "Imagen:"
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          var JsonTemporal = {
                            'id' : id,
                            'nombre' : nombre.text,
                            'pelicula' : pelicula.text,
                            'edad' : int.parse(edad.text),
                            'imagen' : imagen.text
                          };

                          DB.actualizar(JsonTemporal).then((value) {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exito al actualizar")));
                              nombre.clear();
                              pelicula.clear();
                              edad.clear();
                              imagen.clear();
                              temporalJSON = {};
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Actualizar")
                    ),
                    SizedBox(width: 40,),
                    ElevatedButton(
                        onPressed: (){
                          nombre.clear();
                          pelicula.clear();
                          edad.clear();
                          imagen.clear();
                          temporalJSON = {};
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}
