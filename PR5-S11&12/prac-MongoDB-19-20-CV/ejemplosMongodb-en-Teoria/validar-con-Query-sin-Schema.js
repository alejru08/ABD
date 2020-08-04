
// -------------  EJEMPLOS con Formato Query
//      SIN  $jsonSchema (antes de v. 3.6) ---------------
//
// -------- crear una colección con las validaciones 
//         $or : para los Temas con diferentes campos

db.createCollection( "valeAficiones",
   { validator: { $and:
      [
         { Tema: { $type: "string", "$exists": true } },
         { Apodo: { $type: "string", "$exists": true } },
         { Nombre: {$type: "string", "$exists": true } },
       ] } }
   );

// -- además puedes validar valores con expresiones regulares con $regex


//------ ver qué opciones (y condiciones de validación tiene)

db.getCollectionInfos( { name: "valeAficiones" } )




// --------- Prueba: inserción que rechaza

db.valeAficiones.insert(
   {
    "_id" : ObjectId("5746cf74e6046b47d4073621"),
    "Tema" : "MotoGP",
    "Apodo" : "MGP",
    "NombreEquipo" : "Aprilia Racing Team Gresini",
    "NumeroPilotos" : 2.0,
    "CarrerasGanadas" : 8.0,
    "PrimerPiloto" : "Stefan Bradl",
    "SegundoPiloto" : "Alvaro Bautista",
    "Descuento" : NaN
   }
 )


// Responde : Document failed validation

