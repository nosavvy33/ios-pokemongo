//
//  ViewController.swift
//  PokemonGo
//
//  Created by Leon on 21/11/18.
//  Copyright © 2018 Leon. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemons: [Pokemon] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        agregarPokemons()

        ubicacion.delegate = self
        pokemons = obtenerPokemons()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setup()
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        let region = MKCoordinateRegion.init(center: view.annotation!.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = (view.annotation as! PokePin).pokemon
                if mapView.visibleMapRect.contains(MKMapPoint(coord)){
                    print("cerca")
                    guard let appDelegate =
                     UIApplication.shared.delegate as? AppDelegate else {
                     return
                     }
                     let managedContext =
                     appDelegate.persistentContainer.viewContext


                    pokemon.setValue("true", forKey: "atrapado")
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    mapView.removeAnnotation(view.annotation!)
                    
let alertaVC = UIAlertController(title: "Felicidades!", message: "Atrapaste a un \(pokemon.nombre)", preferredStyle: .alert)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: {
                        (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertaVC.addAction(pokedexAction)
                    let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertaVC.addAction(okAction)
                    self.present(alertaVC, animated: true, completion: nil)

                }else{
                    print("lejos")
                    let alertaVC = UIAlertController(title: "Ups!", message: "Estas muy lejos de ese \(pokemon.nombre)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertaVC.addAction(okAction)
                    self.present(alertaVC, animated: true, completion: nil)
                }
            }
        })
        
        
        print("PRINT PRESIONADO")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            return pinView
        }
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokePin).pokemon
        pinView.image = UIImage(named: pokemon.imagenNombre!)
        
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        return pinView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones < 1 {
        let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
    }
    
    
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    func setup(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {(timer) in
            if let coord = self.ubicacion.location?.coordinate{
                /*let pin = MKPointAnnotation()
                 pin.coordinate = coord*/
                //let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let pokemon = self.pokemons[Int.random(in: 0..<self.pokemons.count)]
                let pin = PokePin(coord: coord, pokemon: pokemon)
                let randomlat = (Double(arc4random_uniform(200)) - 100.0)/5000.0
                let randomlon = (Double(arc4random_uniform(200)) - 100.0)/5000.0
                pin.coordinate.latitude += randomlat
                pin.coordinate.longitude += randomlon
                self.mapView.addAnnotation(pin)
            }
        })
    }


}

