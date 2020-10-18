//
//  SearchCityViewController.swift
//  WeatherForReal
//
//  Created by 指套 on 2020/9/17.
//

import UIKit
import ProgressHUD
protocol SearchCityDelegate {
    func didChangeCity(city:String)
}

class SearchCityViewController: UIViewController,SaveCityDelegate {
    
    
    
    
    func saveCity(city: String) {
        print("啊这")
        savedCity1.text = city
    }
    
    @IBOutlet weak var savedCity1: UILabel!
    @IBAction func savedCity(_ sender: Any) {
        
        delegate?.didChangeCity(city: cityNum["\(savedCity1.text!)"]!)
        dismiss(animated: true, completion: nil)
    }
    
    var delegate: SearchCityDelegate? //问号是用户没按按钮的时候事件可以不发生

    @IBOutlet weak var cityInput: UITextField!
    
    @IBAction func changeCity(_ sender: Any) {
        
        if  cityNum["\(cityInput.text!)"] != nil {
            delegate?.didChangeCity(city: cityNum["\(cityInput.text!)"]!)
            dismiss(animated: true, completion: nil)
        }else{
            ProgressHUD.showError("未找到该城市，请重新输入")
        }
        //问号：delegate有值则继续执行后面的调用，若为nil，则不执行后面的调用
       
    }
    @IBAction func dissMiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let vc = segue.destination as! ViewController
        vc.delegate1 = self

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
