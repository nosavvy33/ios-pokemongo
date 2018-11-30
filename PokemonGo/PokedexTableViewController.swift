//
//  PokedexTableViewController.swift
//  PokemonGo
//
//  Created by Leon on 28/11/18.
//  Copyright © 2018 Leon. All rights reserved.
//

import UIKit
class PokedexTableViewController: UITableViewController {
    
    
    @IBOutlet var tablePokemons: UITableView!
    
    
    var pokemonsNoAtrapados : [Pokemon] = []
    var pokemonsAtrapados : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // tablePokemons.delegate = self
        //tablePokemons.dataSource = self
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonsNoAtrapados()
        print(pokemonsNoAtrapados.count)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return pokemonsAtrapados.count
        }else{
            return pokemonsNoAtrapados.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon?
        print(pokemonsNoAtrapados[indexPath.row])
        if indexPath.section == 0 {
            pokemon = pokemonsAtrapados[indexPath.row]
        }else{
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon!.nombre
        cell.imageView?.image = UIImage(named: pokemon!.imagenNombre!)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        }else{
            return "No Atrapados"
        }
    }

}
