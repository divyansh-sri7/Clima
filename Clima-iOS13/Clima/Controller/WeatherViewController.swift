import UIKit
import CoreLocation

class WeatherViewController: UIViewController
{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager=WeatherManager()
    var locationManager=CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate=self
        searchTextField.delegate=self
    }
    
    @IBAction func locationPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
    
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate
{
    @IBAction func searchPressed(_ sender: UIButton)
    {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        }
        else{
            searchTextField.placeholder="Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if let city=searchTextField.text
        {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel)
    {
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.tempratureString
            self.cityLabel.text=weather.cityName
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailedError(error: Error)
    {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat, longitude : lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}
