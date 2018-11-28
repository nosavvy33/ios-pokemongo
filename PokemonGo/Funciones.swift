//
//  Funciones.swift
//  PokemonGo
//
//  Created by Leon on 21/11/18.
//  Copyright © 2018 Leon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func agregarPokemons(){
    save(nombre: "Mew", imagenNombre: "mew",atrapado: "false")
    save(nombre: "Meowth", imagenNombre: "meowth",atrapado: "false")
    save(nombre: "Abra", imagenNombre: "abra",atrapado: "false")
    save(nombre: "Bullbasaur", imagenNombre: "bullbasaur",atrapado: "false")
    save(nombre: "Dratini", imagenNombre: "dratini",atrapado: "false")
    print("Creando pokemon")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func save(nombre: String, imagenNombre: String, atrapado: String) {
    var pokemonList : [NSManagedObject] = []
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }

    let managedContext =
        appDelegate.persistentContainer.viewContext

    let entity =
        NSEntityDescription.entity(forEntityName: "Pokemon",
                                   in: managedContext)!
    
    let pok = NSManagedObject(entity: entity,
                                 insertInto: managedContext)

    pok.setValue(nombre, forKeyPath: "nombre")
    pok.setValue(imagenNombre, forKey: "imagenNombre")
    pok.setValue(atrapado, forKey: "atrapado")
    
    do {
        try managedContext.save()
        pokemonList.append(pok)
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func crearPokemon(xnombre: String, ximagenNombre: String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.nombre = xnombre
    pokemon.imagenNombre = ximagenNombre
    pokemon.atrapado = ""
}

func obtenerPokemons() -> [Pokemon]{
    var pokemonsList : [Pokemon] = []
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return []
    }
    
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    //2
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
    
    //3
    do {
        pokemonsList = try managedContext.fetch(fetchRequest) as! [Pokemon]
        print(pokemonsList.count)
        return pokemonsList
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return []
    
    /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            agregarPokemons()
            return obtenerPokemons()
        }
        return pokemons
    }catch{
        
    }
    return []*/
}

func obtenerPokemonsAtrapados() -> [Pokemon]{
    var pokemonsList : [Pokemon] = []
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return []
    }
    
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    //2
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "atrapado == %@", "true")
    
    //3
    do {
        pokemonsList = try managedContext.fetch(fetchRequest) as! [Pokemon]
        print(pokemonsList.count)
        return pokemonsList
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return []
    
    /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryWhere.predicate = NSPredicate(format: "atrapado == %@", true as CVarArg)
    do{
        let pokemons = try context.fetch(queryWhere) as [Pokemon]
        print(pokemons.count)
        return pokemons
    }catch{}
    return []*/
}

func obtenerPokemonsNoAtrapados() -> [Pokemon]{
    var pokemonsList : [Pokemon] = []
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return []
    }
    
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    //2
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
    fetchRequest.predicate = NSPredicate(format: "atrapado == %@", "false")
    
    //3
    do {
        pokemonsList = try managedContext.fetch(fetchRequest) as! [Pokemon]
        print("No atrapados : \(pokemonsList.count)")
        return pokemonsList
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return []
    
    
    /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryWhere.predicate = NSPredicate(format: "atrapado == %@", false as CVarArg)
    do{
        let pokemons = try context.fetch(queryWhere) as [Pokemon]
        print(pokemons.count)

        return pokemons
    }catch{}
    return []*/
}
