//
//  WorldView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import ARSLineProgress
import JGProgressHUD

class WorldView: UIViewController {
    //Outlets
    @IBOutlet var totalCase: UILabel!
    @IBOutlet var totalRecovered: UILabel!
    @IBOutlet var totalDeath: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giveDelegate()
        
        setWorld()
 
    }

    /**
     This function fetch world general statistics from API. And parse API response.
     */
    func setWorld() {
        
        //MARK: World Total Case
        ARSLineProgress.show()
        
        AF.request("https://corona.lmao.ninja/v2/all").response { (response) in
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
                
                //Parse JSON
                self.totalCase.text = "\(json![]["cases"])"
                self.totalRecovered.text = "\(json![]["recovered"])"
                self.totalDeath.text = "\(json![]["deaths"])"
                
                self.checkTime()
                
                
            }
        }
        
        
        //MARK: Country Cases
        
        /**
        This function fetch all world country  general statistics from API with sorted by Case Number. And parse API response.
        */
        AF.request("https://corona.lmao.ninja/v2/countries?sort=cases").response { (response) in
            
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
            
                /**
                 Parsing JSON data format.
                 Create data model and add model array to use on table view.
                For more information;
                    CountryDataModel.swift
                        CountryData.swift
                 */
                for i in 0...json![].count {
                    var model = CountryDataModel.init()
                    model.country = "\(json![][i]["country"])"
                    model.cases = Int("\(json![][i]["cases"])")
                    model.deaths = Int("\(json![][i]["deaths"])")
                    model.recovered = Int("\(json![][i]["recovered"])")
                    model.todayCases = Int("\(json![][i]["todayCases"])")
                    model.todayDeath = Int("\(json![][i]["todayDeath"])")
                    CountryData.shared.data.append(model)
                }
                
                ARSLineProgress.hide()
                
                self.tableView.reloadData()
            }
        }
    }
    

}

//MARK: Table View
extension WorldView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountryData.shared.data.count
    }
    
    //Show data on cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "country") as! TableCell
        
        let data = CountryData.shared.data[indexPath.row]
        let asd = CountryDict.shared.countries[data.country!]
        
        cell.country.text = asd
        cell.case.text = "\(data.cases!)"
        cell.death.text = "\(data.deaths!)"
        cell.recovered.text = "\(data.recovered!)"
        
        return cell
    }
    
    func giveDelegate() {
        self.tableView.register(UINib.init(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "country")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension WorldView {
    
    /**
     Check time for save data to CoreData (Local database).
     If app opentime is after 20.00, save daily data.
     */
    func checkTime() {
        var dateComponent = DateComponents()
        dateComponent.hour = 20
        dateComponent.minute = 00
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dateString = "\(day) \(month) \(year)"
        
        if let dateDay = UserDefaults.standard.value(forKey: "day") as? String   {
            if hour >= dateComponent.hour! && minutes >= dateComponent.minute! && dateDay != "\(day)" {
                save(Int(self.totalCase.text!)!, Int(self.totalRecovered.text!)!,Int(self.totalDeath.text!)!, date: dateString)
            }
        } else {
            UserDefaults.standard.set("\(day)", forKey: "day")
        }
    }

    /**
     Save data to CoreData (local database).
     - Parameters:
            - CaseCount
            - RecoveredCount
            - DeathCount
            - Date with String Format. 
     
     */
    func save(_ cases:Int, _ recovered:Int, _ death:Int, date:String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "WorldStatistic",
                                   in: managedContext)!
      
      let entry = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
          
        let data:[String:Any] = ["cases":cases,"recovered":recovered,"death":death,"date":date]
        
        entry.setValuesForKeys(data)
      // 4
      do {
        try managedContext.save()
        print("save data")
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    
    }
    
}
