//
//  TurkeyView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ARSLineProgress
import JGProgressHUD
import UserNotifications

class TurkeyView: UIViewController {
    
    //Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var CaseStatus: UIView!
    @IBOutlet var caseView: UIView!
    @IBOutlet var recoveredView: UIView!
    @IBOutlet var deathView: UIView!
    
    @IBOutlet var activeCases: UILabel!
    @IBOutlet var activeCasesDifference: UILabel!
    
    @IBOutlet var recoveredCases: UILabel!
    @IBOutlet var recoveredCasesDifference: UILabel!
    
    @IBOutlet var deathCases: UILabel!
    @IBOutlet var deathCasesDifference: UILabel!
    
    @IBOutlet var updateView: UIView!
    @IBOutlet var updateDate: UILabel!
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNoti()
        viewProperty()
        setup()
        getData()
        
    }

}


//MARK: Get Data
extension TurkeyView {
    
    /**
     Check notification center requeest handler for is there notification for world statistic alert. If not, create notification on 20.15 to notifiy user for new world statistic.
     */
    func checkNoti(){
        
        var isHave = false
        
        let center = UNUserNotificationCenter.current()
        
        //Check notification request handler to world notification.
        center.getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == "worldNotification" {
                    isHave = true
                }
            }
        }
        
        //If there is no world notification, create one.
        if !isHave {
            
            let content = UNMutableNotificationContent()
            content.title = "Yeni bilgiler var. Kontrol etmek ister misin?"
            content.body = "Covid-19 ile ilgili yeni istatistikleri görmek için tıkla."
            
            var dateComp = DateComponents()
            dateComp.hour = 20
            dateComp.minute = 15
            
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComp, repeats: true)
            let request = UNNotificationRequest.init(identifier: "worldNotification", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        }
    }
    
    
    /**
     Get data from API. And parse json file.
     This method fetch just Tukey current statistic.
    */
    func getData() {
        
        ARSLineProgress.show()
        
        AF.request("https://corona.lmao.ninja/v2/countries/TR").response { (response) in
            
            // If there is an error, show unsuccesful message.
            if response.error != nil {
                ARSLineProgress.hide()
                
                //Create hud for unsuccesful message
                let hud = JGProgressHUD.init(style: .dark)
                hud.textLabel.text = "Veriler alınamadı."
                hud.detailTextLabel.text = "Lütfen internet bağlantınızı kontrol edin ya da tekrar deneyin."
                
                hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2, animated: true)
            }
            
            if let data = response.data {
                
                //Convert data to JSON format
                let json = try? JSON.init(data: data)
                
                
                var cases:Int = 0
                var deaths:Int = 0
                var recovered:Int = 0
                var todayCases:Int = 0
                var todayDeaths:Int = 0
                
                //Parse JSON
                cases = Int("\(json!["cases"])")!
                deaths = Int("\(json!["deaths"])")!
                recovered = Int("\(json!["recovered"])")!
                todayCases = Int("\(json!["todayCases"])")!
                todayDeaths = Int("\(json!["todayDeaths"])")!
                
                //Update User Defaults value
                self.updateUserDef(cases: cases, deaths: deaths, recovered: recovered, todayCases: todayCases, todayDeaths: todayDeaths)
                
                //Update view.
                self.updateViewValues(cases: cases, deaths: deaths, recovered: recovered, todayCases: todayCases, todayDeaths: todayDeaths)
                self.showUpdateTime()
                
                
                ARSLineProgress.hide()
                
            }
        }
    }
    
    /** This function update user defaults value for;
     - Parameters
        - Case Count
        - Deaths Count
        - Recovered Count
        - Today Cases Count
        - Today Death Count
     */
    func updateUserDef(cases:Int,deaths:Int,recovered:Int,todayCases:Int,todayDeaths:Int) {
        UserDefaults.standard.set(cases, forKey: "cases")
        UserDefaults.standard.set(deaths, forKey: "deaths")
        UserDefaults.standard.set(recovered, forKey: "recovered")
        UserDefaults.standard.set(todayCases, forKey: "todayCases")
        UserDefaults.standard.set(todayDeaths, forKey: "todayDeaths")
    }
    
    //Update View properties
    func updateViewValues(cases:Int,deaths:Int,recovered:Int,todayCases:Int,todayDeaths:Int){
        activeCases.text = "\(cases)"
        activeCasesDifference.text = "+\(todayCases)"
        recoveredCases.text = "\(recovered)"
        recoveredCasesDifference.text = ""
        deathCases.text = "\(deaths)"
        deathCasesDifference.text = "+\(todayDeaths)"
    }
    
    func viewProperty() {
        self.CaseStatus.layer.cornerRadius = 10
        self.updateView.layer.cornerRadius = 10
        self.caseView.layer.cornerRadius = 10
        self.recoveredView.layer.cornerRadius = 10
        self.deathView.layer.cornerRadius = 10
    }
    
    
    // If there is a value to cases on User Default, fetch and show on view.
    func setup() {
        if UserDefaults.standard.value(forKey: "cases") != nil {
            updateViewValues(cases:  UserDefaults.standard.value(forKey: "cases") as! Int, deaths: UserDefaults.standard.value(forKey: "deaths") as! Int, recovered: UserDefaults.standard.value(forKey: "recovered") as! Int, todayCases: UserDefaults.standard.value(forKey: "todayCases") as! Int, todayDeaths: UserDefaults.standard.value(forKey: "todayDeaths") as! Int)
        }
    }
    
    //Show Update time on view.
    func showUpdateTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if minutes < 10 {
            self.updateDate.text = "\(hour):0\(minutes)"
        } else {
            self.updateDate.text = "\(hour):\(minutes)"

        }
    }
    
}
