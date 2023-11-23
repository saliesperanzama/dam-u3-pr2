import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> princesa) async {
    return await baseRemota.collection("princesa").add(princesa);
  }

  static Future<List> mostrarTodas() async{
    List temporal = [];
    var query = await baseRemota.collection("princesa").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id' : element.id
      });
      temporal.add(dato);
    });
    return temporal;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("princesa").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> princesa) async{
    String id = princesa['id'];
    princesa.remove('id');
    return await baseRemota.collection("princesa").doc(id).update(princesa);
  }
}