import Foundation

struct CurrentWeather: Decodable{
    let main : MainC
    let dt : Double
    let wind : WindC
    let weather: [WeatherC]
}
struct MainC: Decodable{
    let temp : Double
    let pressure : Double
    let humidity : Double
}
struct WindC : Decodable{
    let speed : Double
}
struct WeatherC : Decodable{
    let description: String
    let icon: String
}
