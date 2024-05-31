import Foundation

protocol WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel)
    func didFailedError(error : Error)
}


struct WeatherManager
{
    
    var delegate : WeatherManagerDelegate?
    
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?&appid=YOUR_API_KEY&units=metric"
    
    func fetchWeather(cityName : String)
    {
        let city=cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString="\(weatherURL)&q=\(city)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude : Double, longitude : Double)
    {
        let urlString="\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String)
    {
        
            // 1. Create URL
        
        if let url = URL(string: urlString){
            
            // 2. Create URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailedError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData)
                    {
                        delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            
            // 4. Start the task
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: cityName, temp: temp)
            return weather
        }
        catch
        {
            delegate?.didFailedError(error: error)
            return nil
        }
        
    }
    
}
