//
//  ContentView.swift
//  WeatherAppWithApi
//
//  Created by Lorenzo Tosi on 06/09/22.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var location: String = ""
    @State private var forecastInformations: Forecast? = nil
    
    let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "EEEE, d MMMM, yyyy"
        //"yyyy, MMMM d, HH:mm:ss"
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                Text("Insert a city:")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical)
                
                HStack{
                    TextField("Enter location", text: $location)
                        .textFieldStyle(.roundedBorder)
                    Button{
                        getWeather(for: location)
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                }.padding(.horizontal)
                
                
                VStack {
                    if let forecastInformations = forecastInformations {
                        Text("\(dateFormatter.string(from: forecastInformations.dt))")
                            .font(.system(size: 24, weight: .heavy, design: .default))
                            .foregroundColor(.white)
                            .padding()
                        Text("\(Int(forecastInformations.main.temp))°")
                            .font(.system(size: 100, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .frame( alignment: .center)
                            .padding(.vertical)
                        Spacer()
                        Text(forecastInformations.weather[0].description)
                            .font(.system(size: 25, weight: .heavy, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            
        }
    }
    
    func getWeather(for city: String){
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(city) {(placemarks, error) in
            if let error = error {
                print("ERRORE \(error.localizedDescription)")
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=it&units=metric&appid=\(key)", dateDecodingStrategy: .secondsSince1970) {
                    (result: Result<Forecast, APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        self.forecastInformations = forecast
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
