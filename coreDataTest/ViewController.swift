//
//  ViewController.swift
//  coreDataTest
//
//  Created by Jésica González Baqué on 02/07/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var managedContext:NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Obtengo referencia global a la base de datos (context)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        
        print( recordCount() )
        
        //read()
        
        delete(documento: 33456789)
        
        /*
        save("Alumno1", 13456789)
        save("Alumno2", 23456789)
        save("Alumno3", 33456789)
        save("Alumno4", 43456789)
        save("Alumno5", 53456789)
        */
        
        print( "Último read" )
        read()
    }

    func recordCount() -> NSInteger
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alumnos")
        let count = try! managedContext!.count(for: fetchRequest)
    
        return count
    }
    
    func save(_ name:String, _ docu: NSInteger)
    {
        let entity = NSEntityDescription.entity(forEntityName: "Alumnos", in: managedContext!)
        
        let alumno = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        alumno.setValue(name, forKeyPath: "nombre")
        alumno.setValue(docu, forKeyPath: "documento")
        
        do {
            try managedContext!.save()
        } catch let error as NSError {
            print("Error en save \(error)")
        }
    }
    
    func read()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alumnos")
        
        var alumnos: [NSManagedObject] = []
        
        do {
            alumnos = try managedContext!.fetch(fetchRequest)
            
            for alumno in alumnos {
                print( alumno.value(forKey: "nombre") as! String )
                print( alumno.value(forKey: "documento") as! NSInteger )
            }
        } catch let error as NSError {
            print("Error \(error)")
        }
    }
    
    func delete(documento docu:NSInteger)
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alumnos")
        fetchRequest.predicate = NSPredicate.init(format: "documento == \(docu)")
        
        let resultados = try! managedContext!.fetch(fetchRequest)
        
        for obj in resultados {
            managedContext!.delete(obj)
        }
        
        do {
            try managedContext!.save()
        } catch let error as NSError {
            print("Error en delete \(error)")
        }
    }

}

