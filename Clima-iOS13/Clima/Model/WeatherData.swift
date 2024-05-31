import Foundation

struct WeatherData : Codable
{
    var name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable
{
    let temp : Double
}

struct Weather : Codable
{
    let id : Int
}

