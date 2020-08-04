db.createCollection("tusAficiones", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: [ "campo1", "campo2", "campo3" ],
         properties: {
             Curso: {
               enum: [ "Primero", "Segundo", "Tercero", "Cuarto" ],
               description: "Solo puede ser alguno de los valores posibles"
            },
            PeriodoPractica: {
               bsonType: [ "int" ],
               minimum: 1960,
               maximum: 2020,
               description: "Años entre 1960 y 2020"
            },
            "viveEn.Ciudad" : {
               bsonType: "string",
               description: "Nombre de ciudad"
            },
            "viveEn.Pais" : {
               bsonType: "string",
               description: "Nombre de pais"
            }
         }
      }
   }
})
