//
//  CheckAndCompare.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import Foundation
import UserNotifications


/**
 This class using with background fetch proccess.
 Check fetched data with CoreData data. If there is a difference between them, send notification for notify user to check statictis.
 */
class CheckAndCompare {
    /**
     - parameter Cases. Case count on fetched API data.
     */
    func checkAndCompare(_ cases:Int){
        if let userDefCases = UserDefaults.standard.value(forKey: "cases") as? Int {
            
            if userDefCases != cases {
                
                let content = UNMutableNotificationContent()
                
                content.title = "Bilgiler Güncellendi"
                content.body = "Türkiye'nin istatistikleri güncellendi. Kontrol etmek ister misin?"
                content.sound = UNNotificationSound.default
                
                
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10, repeats: false)
                
                let ident = "myNotification"
                
                let requ = UNNotificationRequest.init(identifier: ident, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(requ, withCompletionHandler: nil)
                
            }
        }
    }
    
    //Singleton Structure.
    static let share = CheckAndCompare()
}
