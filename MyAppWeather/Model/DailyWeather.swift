//
//  DailyWeather.swift


import Foundation

struct DailyWeather: Codable {
    let city: CityD
    let cod: String
    let message: Double
    let cnt: Int
    let list: [ListD]
}

// MARK: - City
struct CityD: Codable {
    let id: Int
    let name: String
    let coord: CoordD
    let country: String
    let population, timezone: Int
}

// MARK: - Coord
struct CoordD: Codable {
    let lon, lat: Double
}

// MARK: - List
struct ListD: Codable {
    let dt, sunrise, sunset: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let weather: [WeatherD]
    let speed: Double
    let deg: Int
    let gust: Double
    let clouds: Int
    let pop: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Weather
struct WeatherD: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
