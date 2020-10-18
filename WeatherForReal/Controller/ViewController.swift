//
//  ViewController.swift
//  WeatherForReal
//
//  Created by 指套 on 2020/9/13.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MapKit
import ProgressHUD
import MBProgressHUD

protocol SaveCityDelegate {
    func saveCity(city:String)
}

class ViewController: UIViewController, CLLocationManagerDelegate,SearchCityDelegate {
    func didChangeCity(city: String) {
        
        cityName.text = reCityNum["\(city)"]
        getWeatherData(requestNum:city)
        
    }
    
    
    let locationManager = CLLocationManager()
    var currLocation : CLLocation!
    var delegate1: SaveCityDelegate?

    
    
    //城市名字
    @IBOutlet weak var cityName: UILabel!
    //实时日期
    @IBOutlet weak var realTimeDate: UILabel!
    //实时天气的图标
    @IBOutlet weak var weatherLogo: UIImageView!
    //相对湿度
    @IBOutlet weak var relativelyHumidity: UILabel!
    //风向
    @IBOutlet weak var windDirection: UILabel!
    //风力
    @IBOutlet weak var windLevel: UILabel!
    //实时温度
    @IBOutlet weak var realTimeTemp: UILabel!
    
    @IBOutlet weak var boxTime1: UILabel!

    @IBOutlet weak var boxTime2: UILabel!
    
    @IBOutlet weak var boxTime3: UILabel!
    
    @IBOutlet weak var boxTime4: UILabel!
    
    @IBOutlet weak var boxTime5: UILabel!
    
    @IBOutlet weak var boxTime6: UILabel!
    
    @IBOutlet weak var boxIcon1: UIImageView!
    
    @IBOutlet weak var boxIcon2: UIImageView!
    
    @IBOutlet weak var boxIcon3: UIImageView!
    
    @IBOutlet weak var boxIcon4: UIImageView!
    
    @IBOutlet weak var boxIcon5: UIImageView!
    
    @IBOutlet weak var boxIcon6: UIImageView!
    
    @IBOutlet weak var boxTemp1: UILabel!
    
    @IBOutlet weak var boxTemp2: UILabel!
    
    @IBOutlet weak var boxTemp3: UILabel!
    
    @IBOutlet weak var boxTemp4: UILabel!
    
    @IBOutlet weak var boxTemp5: UILabel!
    
    @IBOutlet weak var boxTemp6: UILabel!
    
    @IBOutlet weak var sunsetMoment: UILabel!
    
    @IBAction func mySaveCity1(_ sender: Any) {
        delegate1?.saveCity(city: "\(String(describing: cityName.text))")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self//让viewController知道在给谁做事情
        let date = Date()
        let timeFormatter = DateFormatter()
        //设置显示日期格式
        timeFormatter.dateFormat = "yyy/MM/dd"
        realTimeDate.text = timeFormatter.string(from: date) as String
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()//请求用户位置--只请求一次
        
        
    }
     
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()//请求当前位置
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCity"{
            
            let vc = segue.destination as! SearchCityViewController
            vc.delegate = self
            

            
        }
    
    }

    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        let paras = ["location":"\(lon),\(lat)","key":"983e9c1f7e80f045663bda44a4596819"]
        getCity(paras: paras)
        
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
                    print(error.localizedDescription)
        }
    func getCity  (paras:[String:String])
    {

        AF.request("https://restapi.amap.com/v3/geocode/regeo?output=JSON",parameters:  paras).responseJSON(completionHandler: { [self]
            response in
            if let json = response.value{
                let weather = JSON(json)
                var district = weather["regeocode","addressComponent","district"].stringValue
                var city = weather["regeocode","addressComponent","city"].stringValue
                
                if district == ""{
                    cityName.text = city
                }else{
                    cityName.text = district
                }
                var requestNum:String = ""
                city.removeLast()
                requestNum = cityNum["\(city)"]!
                getWeatherData(requestNum:requestNum)
                }
            })

        
    }
    
    
    func getWeatherData(requestNum: String){
        
        let paras2 = ["name":"\(requestNum)"]
        print(requestNum)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "正在加载"
        hud.removeFromSuperViewOnHide = true //隐藏时从父视图中移除
        hud.hide(animated: true, afterDelay: 7)  //x秒钟后自动隐藏
        AF.request("http://127.0.0.1:5088/?",parameters: paras2).responseJSON(completionHandler: {
            [self]
            response in
            


            if let json = response.value{
                let weatherData = JSON(json)
                
                //weather["regeocode","addressComponent","district"].stringValue
                print(weatherData[1][1][0][0])
                
                //显示未来时间线到屏幕
                boxTime1.text = weatherData[1][1][0][0].stringValue
                boxTime2.text = weatherData[1][1][1][0].stringValue
                boxTime3.text = weatherData[1][1][2][0].stringValue
                boxTime4.text = weatherData[1][1][3][0].stringValue
                boxTime5.text = weatherData[1][1][4][0].stringValue
                boxTime6.text = weatherData[1][1][5][0].stringValue
                
                //显示未来时间线的温度数值到屏幕
                boxTemp1.text = weatherData[1][1][0][2].stringValue
                boxTemp2.text = weatherData[1][1][1][2].stringValue
                boxTemp3.text = weatherData[1][1][2][2].stringValue
                boxTemp4.text = weatherData[1][1][3][2].stringValue
                boxTemp5.text = weatherData[1][1][4][2].stringValue
                boxTemp6.text = weatherData[1][1][5][2].stringValue
                
                //显示未来时间线天气的icon
                var iconArray = [UIImageView]()
                iconArray.append(boxIcon1)
                iconArray.append(boxIcon2)
                iconArray.append(boxIcon3)
                iconArray.append(boxIcon4)
                iconArray.append(boxIcon5)
                iconArray.append(boxIcon6)
                for i in 0...5{
                    var iconData = weatherData[1][1][i][1].stringValue
                    switch iconData {
                    case "晴":
                        iconArray[i].image = UIImage(named: "sunny")
                    case "多云":
                        iconArray[i].image = UIImage(named: "cloudy")
                    case "阴":
                        iconArray[i].image = UIImage(named: "overcast")
                    case "小雨":
                        iconArray[i].image = UIImage(named: "lightRainy")
                    case "中雨":
                        iconArray[i].image = UIImage(named: "mdRainy")
                    case "大雨":
                        iconArray[i].image = UIImage(named: "heavyRainy")
                    case "暴雨":
                        iconArray[i].image = UIImage(named: "torrentialRainy")
                    case "阵雨":
                        iconArray[i].image = UIImage(named: "shower")
                    case "雷阵雨":
                        iconArray[i].image = UIImage(named: "thunderShower")
                    case "雷电":
                        iconArray[i].image = UIImage(named: "lightning")
                    default:
                        iconArray[i].image = UIImage(named: "sunnyAtNight")
                    }
                    
                    //实时天气图标
                    weatherLogo.image = boxIcon1.image
                    
                }
                
                //显示相对湿度
                relativelyHumidity.text = weatherData[1][0][4].stringValue
                
                //显示风向、风力
                windDirection.text = weatherData[1][1][0][3].stringValue
                windLevel.text = weatherData[1][1][0][4].stringValue
                
                //显示实时温度
                var realTimeTempNum = weatherData[1][1][0][2].stringValue
                let range = realTimeTempNum.index(realTimeTempNum.endIndex, offsetBy: -1)..<realTimeTempNum.endIndex
                realTimeTempNum.removeSubrange(range)
                realTimeTemp.text = realTimeTempNum
                
                //显示日落时间
                sunsetMoment.text = weatherData[1][0][2].stringValue
            }
            
        })
        
    }
    


    
    
    }
