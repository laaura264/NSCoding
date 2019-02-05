//PERSISTIR CON UN FICHERO
import Foundation

//Con este método las personas pueden ser convertibles en un elemento serializable
class Person : NSObject, NSCoding {
    var name : String!
    var phone : String!
    
    //Método inicializador que recibe un String
    init(name : String, phone : String) {
        //Guarda el name y el phone "seteando" las propiedades que se acaban de guardar
        self.name = name
        self.phone = phone
    }
    //Necesario implementar dos métodos por utilizar NSCoding:
    required convenience init?(coder aDecoder : NSCoder){
        let name = aDecoder.decodeObject(forKey: "name") as! String // 'as! String' convertir en un string
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.init(name: name, phone:phone)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name") //Guardar lo que hay en name en "name"
        aCoder.encode(self.phone, forKey: "phone") //Guardar lo que hay en phone en "phone"

    }
    
}

var people = [Person]()
people.append(Person(name:"Miguel", phone: "666112233"))
people.append(Person(name:"Erik", phone: "665511222"))
people.append(Person(name:"Elena", phone: "666442233"))

//Método que permite recuperar la ruta del fichero en el que vamos a persistir el listado de personas
func databaseURL() -> URL? {
    
    if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let url = URL(fileURLWithPath: documentDirectory)
        return url.appendingPathComponent("people.data")
    } else {
        return nil
    }
}

func save(){
    //si tengo una URL guardada en databaseURL:
    if let url = databaseURL(){
        NSKeyedArchiver.archiveRootObject(people, toFile: url.path) //Desensamblar la información
    } else {
        print("Error guardando datos")
    }
}

func load() {
    if let url = databaseURL() {
        if let savedData = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [Person] { //Se hace el casting de forma opcional, si lo que llega es un opcional, se pasa a Person
            people = savedData
        }
    } else {
        print("Error leyendo datos")
    }
}

save()
people.removeAll() //Vaciar los datos
load() //Cargar los datos

for person in people{
    print ("Name: \(person.name) Phone: \(person.phone)")
}



