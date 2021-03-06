//
//  ProfileViewController.swift
//  Covid-19App
//  For controlling profile screen which displays personal details of logged in user and buttons to navigate to registered users table, recorded symptoms table, change status screens (rafei)
//  Created by Rafe Ibrahim on 28.4.2020.
//  Copyright © 2020 Covid-19App. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var loggedInUserNameLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var loggedInUserEmailLabel: UILabel!
    @IBOutlet weak var statusColorLabel: UILabel!
    @IBOutlet weak var loggedInUserStatusLabel: UILabel!
    @IBOutlet weak var symptomsRecordCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let covidDefaults = UserDefaults.standard
        if (covidDefaults.string(forKey: "loggedInUser") == nil) {
        pushToLoginScreen()
        } else {
            guard let loggedInUserEmail = covidDefaults.string(forKey: "loggedInUser") else {
                return
            }
            do {
                let loggedInUser = try User.fetchUserByEmail(email: loggedInUserEmail, context: self.viewContext)
                loggedInUserEmailLabel.text = loggedInUser.email
                    //"tester70@metropolia.fi"
                loggedInUserNameLabel.text = loggedInUser.name
                loggedInUserStatusLabel.text = loggedInUser.status
                if loggedInUser.status == NSLocalizedString("Healthy", comment: "") {
                    self.statusColorLabel.backgroundColor = UIColor.blue
                } else if loggedInUser.status == NSLocalizedString("Quarantined", comment: "") {
                    self.statusColorLabel.backgroundColor = UIColor.orange
                } else if loggedInUser.status == NSLocalizedString("Covid-19 +" , comment: ""){
                    self.statusColorLabel.backgroundColor = UIColor.red
                } else {
                    self.statusColorLabel.backgroundColor = UIColor.green
                }
                let symptomSet = try User.fetchAllSymptomsForUser(email: loggedInUserEmail, context: self.viewContext)
                self.symptomsRecordCountLabel.text = String(symptomSet.count)
            } catch let error as NSError {
                print("Could not fetch user with email. \(error). \(error.userInfo)")
            }
        }
    }
    
    @IBAction func unwindToProfileScreen (unwindSegue: UIStoryboardSegue) {
        print("unwinding from \(unwindSegue.destination)")
    }
    
    func pushToLoginScreen () {
        print("pushToLoginScreen called")
        let storyBoard: UIStoryboard = UIStoryboard(name: "auth", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "authVC") as! LoginViewController
                //self.present(newViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        let covidDefaults = UserDefaults.standard
        covidDefaults.removeObject(forKey: "loggedInUser")
        pushToLoginScreen()
    }

//    @IBAction func recordDefaultSymptomsBtnPressed(_ sender: UIButton) {
//        let covidDefaults = UserDefaults.standard
//        guard let loggedInUserEmail = covidDefaults.string(forKey: "loggedInUser") else {
//            return
//        }
//        do {
//            let loggedInUser = try User.fetchUserByEmail(email: loggedInUserEmail, context: self.viewContext)
//            let symptom1 = Symptom(context: self.viewContext)
//            symptom1.time = "number1"
//            symptom1.symptomBelongToUser = loggedInUser
//            let symptom2 = Symptom(context: self.viewContext)
//            symptom2.time = "number2"
//            symptom2.symptomBelongToUser = loggedInUser
//        } catch let error as NSError {
//            print("Could not fetch user with email. \(error). \(error.userInfo)")
//        }
//    }
    
    @IBAction func listOfRecordedSymptomsBtnPressed(_ sender: UIButton) {
        let covidDefaults = UserDefaults.standard
        guard let loggedInUserEmail = covidDefaults.string(forKey: "loggedInUser") else {
            return
        }
        do {
            _ = try User.fetchAllSymptomsForUser(email: loggedInUserEmail, context: self.viewContext)
        } catch let error as NSError {
            print("Could not fetch symptoms list for user. \(error). \(error.userInfo)")
        }
    }
    

    
    @IBAction func listOfRegisteredUsersBtnPressed(_ sender: UIButton)
        {
            do {
                _ = try User.fetchAllUsers(context: self.viewContext)
            } catch let error as NSError {
                print("Could not save. \(error). \(error.userInfo)")
            }
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
