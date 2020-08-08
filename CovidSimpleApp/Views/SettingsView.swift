//
//  SettingsView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit
import JGProgressHUD
import MessageUI
import ARSLineProgress

class CoronaSettingsView: UIViewController, MFMailComposeViewControllerDelegate {

    //Outlets.
    @IBOutlet var trNotificationView: UIView!
    @IBOutlet var trSwitchView: UISwitch!
    @IBOutlet var worldNotificationView: UIView!
    @IBOutlet var worldSwitchView: UISwitch!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var caseTitle: UITextField!
    @IBOutlet var caseBody: UITextView!
    @IBOutlet var caseViewHorCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewProperty()
        setup()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func infoButton(_ sender: Any) {
        showInfo()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        saveSettings()
    }
    

    
    @IBAction func createCaseButton(_ sender: Any) {
        UIView.animate(withDuration: 0.7) {
            self.caseViewHorCons.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendCaseButton(_ sender: Any) {
        if let title = caseTitle.text {
            sendMail(title: title, body: caseBody.text)
        }
    }
    
    
    
}


extension CoronaSettingsView {
    
    //MARK: Send Mail
    /**
     Send Mail to Developer for any case.
     -
     - Parameters:
        - MessageBody
        - MessageSubject
     */
    func sendMail(title:String, body:String){
        let hud = JGProgressHUD.init()
        
        //Check for send mail.
        if MFMailComposeViewController.canSendMail() {
            hud.textLabel.text = "Gönderiliyor.."
            hud.detailTextLabel.text = "Lütfen bekleyiniz."
            hud.show(in: self.view)
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["furkan.ibl@gmail.com"])
            mail.setMessageBody("<p>\(body)</p>", isHTML: true)
            mail.setSubject("\(title)")
            
            hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 1, animated: true)
            
            //Go to the mail page automaticly.
            present(mail, animated: true)
            
        } else {
            //Show an error message If mail sending failed.
           hud.textLabel.text = "Gönderilemedi"
            hud.detailTextLabel.text = "Lütfen internet bağlantınızı kontrol ediniz ve tekrar deneyiniz."
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 1, animated: true)
        }
        UIView.animate(withDuration: 0.7) {
            self.caseViewHorCons.constant = -400
            self.view.layoutIfNeeded()
        }
    }
    
    //Close mail page after send mail.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    //MARK: Show Info
    func showInfo() {
        let hud = JGProgressHUD.init(style: .dark)
        hud.textLabel.text = "İsterseniz her akşam saat 20.00'de Dünya korona istatiskileri güncel bilgileri size bildirilir"
        hud.indicatorView = JGProgressHUDRingIndicatorView.init()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3, animated: true)
    }
    
    
    //MARK: Save Settings
    func saveSettings() {
        let hud = JGProgressHUD.init(style: .dark)
        hud.textLabel.text = "Başarılı"
        hud.detailTextLabel.text = "Kayıt edildi"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        hud.show(in: self.view)
        if trSwitchView.isOn {
            UserDefaults.standard.set(true, forKey: "trNotification")
        } else {
            UserDefaults.standard.set(false, forKey: "trNotification")
        }
        
        if worldSwitchView.isOn {
            UserDefaults.standard.set(true, forKey: "worldNotification")
        } else {
            UserDefaults.standard.set(true, forKey: "worldNotification")

        }
        hud.dismiss(afterDelay: 1, animated: true)
    }
    
    
    //MARK: Load View
    func setup() {
        if let notificationSetted = UserDefaults.standard.value(forKey: "trNotification") as? Bool {
            self.trSwitchView.isOn = notificationSetted
            self.worldSwitchView.isOn = UserDefaults.standard.value(forKey: "worldNotification") as! Bool
        }
    }
    
    func viewProperty() {
        self.trNotificationView.layer.cornerRadius = 10
        self.worldNotificationView.layer.cornerRadius = 10
        
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
        
        self.caseBody.delegate = self
        
        let blankTap = UITapGestureRecognizer.init(target: self, action: #selector(blankTapped))
        self.view.addGestureRecognizer(blankTap)
    }
    
    @objc func blankTapped() {
        self.view.endEditing(true)
    }
    
}


//MARK: TextView Delegate
// For place holder to mail body textView.
extension CoronaSettingsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Bize ne iletmek istersiniz?"
            textView.textColor = UIColor.lightGray
        }
    }
}
