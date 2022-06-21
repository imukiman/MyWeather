

import Foundation
struct HourWeather: Codable {
    let list: [ListH]
}
// MARK: - List
struct ListH: Codable {
    let dt: Double
    let main: MainH
    let weather: [WeatherH]
}

// MARK: - MainClass
struct MainH: Codable {
    let temp, tempMin, tempMax: Double
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}


// MARK: - Weather
struct WeatherH: Codable {
    let icon: String
}




