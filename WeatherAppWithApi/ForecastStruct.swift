//
//  ForecastStruct.swift
//  WeatherAppWithApi
//
//  Created by Lorenzo Tosi on 06/09/22.
//

import Foundation

struct Forecast : Codable {
    
    //il meteo con id, descrizione icona ma non temperature
    struct Weather : Codable {
        let id : Int
        let main : String
        let description : String
        let icon : String
        var weatherIconUrl : URL {
            let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
            return URL(string: urlString)!
        }
    }
    //l'array di tutta quella roba
    let weather : [Weather]
    
    struct Coord : Codable {
        let lon : Double
        let lat : Double
    }
    
    let coord : Coord
    
    //le temperature
    struct Main : Codable {
        let temp: Double
//        let temp_min : Int
//        let temp_max : Int
//        let humidity : Int
    }
    
    let main : Main
    
    let name : String
    let dt : Date
}
