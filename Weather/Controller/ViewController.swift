import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblTempreture: UILabel!
    @IBOutlet weak var tblViewWeatherForecast: UITableView!
    @IBOutlet weak var collectionViewHourlyWeather: UICollectionView!
    
    var currentLocation: CLLocation!
    let weatherViewModel: WeatherViewModel = {
        return WeatherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.currentLocation = { (currentLocation) in
            self.currentLocation = currentLocation
            //--------------------------------------------------------------
            self.weatherViewModel.callFetchCurrentWeatherDataAPI(location: currentLocation, onSuccess: {
                self.lblCityName.text = self.weatherViewModel.currentTempData?.name
                self.lblWeatherStatus.text = self.weatherViewModel.currentTempData?.weather[0].main
                self.lblTempreture.text = "\(String(Int((self.weatherViewModel.currentTempData?.main.temp)!)))°"
            }) { (error) in
                self.showAlert(title: "Error!!", message: error)
            }
            //---------------------------------------------------------------
            self.weatherViewModel.callFetchWeatherForecastDataAPI(location: currentLocation, onSuccess: {
                self.collectionViewHourlyWeather.delegate = self
                self.collectionViewHourlyWeather.dataSource = self
                self.tblViewWeatherForecast.reloadData()
            }) { (error) in
                self.showAlert(title: "Error!!", message: error)
            }
        }
        weatherViewModel.locationManager.startUpdatingLocation()
    }
    
    @IBAction func onMapBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showMap", sender: nil)
    }
}

//MARK: - Navigation

extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.elementsEqual("showMap"))! {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.currentLocation = currentLocation
            destinationVC.currentTempretureData = self.weatherViewModel.currentTempData
        }
    }
}

//MARK: - Tableview delegate and datasource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.daysDataDict.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastTableViewCell", for: indexPath) as! WeatherForecastTableViewCell
        cell.weatherTableViewCellData = weatherViewModel.configureWeatherForecastTableViewCell(dayData: weatherViewModel.daysDataDict[indexPath.row + 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: - Collectionview delegate and datasource

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherViewModel.daysDataDict.first!.1.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherTodayCollectionViewCell", for: indexPath) as! WeatherTodayCollectionViewCell
        let arrHorlyData = weatherViewModel.daysDataDict.first!.1
        cell.houlyWeatherCollectionViewCellData = weatherViewModel.configureHourlyWeatherCollectionCellData(hourData: arrHorlyData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.width / CGFloat(weatherViewModel.daysDataDict.first!.1.count)) - 10, height: collectionView.frame.height)
    }
}

//MARK: - Tableview cell class

class WeatherForecastTableViewCell:UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMaxTempreture: UILabel!
    @IBOutlet weak var imgTempretureIcon: UIImageView!
    @IBOutlet weak var lblMinTempreture: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    
    var weatherTableViewCellData: WeatherForcastTableViewCellData! {
        didSet{
            lblDate.text = weatherTableViewCellData.day
            imgTempretureIcon.image = UIImage.init(named: weatherTableViewCellData.image)
            lblMinTempreture.text = "\(Int(weatherTableViewCellData.minTemp))°"
            lblMaxTempreture.text = "\(Int(weatherTableViewCellData.maxTemp))°"
            lblWeatherStatus.text = weatherTableViewCellData.weatherStatus
        }
    }
}

//MARK: - Collectionview cell class

class WeatherTodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblWeatherImage: UIImageView!
    @IBOutlet weak var lblTempreture: UILabel!
    var houlyWeatherCollectionViewCellData: HourlyWeatherCollectionViewCellData! {
        didSet{
            lblHour.text = houlyWeatherCollectionViewCellData.hour
            lblWeatherImage.image = UIImage.init(named: houlyWeatherCollectionViewCellData.image)
            lblTempreture.text = "\(Int(houlyWeatherCollectionViewCellData.temp))°"
        }
    }
}


