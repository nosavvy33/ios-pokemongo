//
//  PokePin.swift
//  PokemonGo
//
//  Created by Leon on 30/11/18.
//  Copyright © 2018 Leon. All rights reserved.
//

import Foundation
import MapKit

class PokePin : NSObject, MKAnnotation{
    var coordinate : CLLocationCoordinate2D
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
