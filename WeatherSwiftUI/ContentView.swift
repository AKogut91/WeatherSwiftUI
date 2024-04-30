//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Alex Kogut on 4/29/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherResponse?
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            if let weatherData = weatherData {
                Text("\(Int(weatherData.main.temp) ) C")
                    .font(.custom("", size: 50))
                    .padding()
                VStack {
                    Text("\(weatherData.name)")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Have a nice day")
                    .font(.custom("", size: 15))
                    .padding()
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .onAppear {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            guard let currentLocation = location else { return }
            fetchData(for: currentLocation)
        }
    }
    
    private func fetchData(for location: CLLocation) {
        let apiKey = "1934df326baa735f77cbc93aebf63669"
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, status, error in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let response  = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    weatherData = response
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
