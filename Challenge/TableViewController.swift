//
//  TableViewController.swift
//  Challenge
//
//  Created by Kevin on 6/28/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class SingleCell: UITableViewCell {
    @IBOutlet weak var gender_label: UILabel!
    
    @IBOutlet weak var age_label: UILabel!
    
}

var users = [User] ()
var myIndex = 0

class TableViewController: UITableViewController {
    
    var dbRef: DatabaseReference!
    var temp = [User] ()
    
    @IBOutlet weak var gender_label: UILabel!
    
    @IBOutlet weak var age_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("Users").child("Ids")
        startObservingDB()
    }

    
    @IBAction func sortItemClicked(_ sender: Any) {
        let sortAlert = UIAlertController (title: "Sort", message: "choose what you want to change from table", preferredStyle: .alert)
        sortAlert.addAction(UIAlertAction(title: "Show only females", style: .default, handler: {(action:UIAlertAction) in self.hideGender(gender: "M")
            self.tableView.reloadData()
            
        }
        ))
        sortAlert.addAction(UIAlertAction(title: "Show only males", style: .default, handler: {(action:UIAlertAction) in   self.hideGender(gender: "F")
            self.tableView.reloadData()
        }
        ))
        sortAlert.addAction(UIAlertAction(title: "Sort by age", style: .default, handler: {(action:UIAlertAction) in
            self.sortBy(parameter: "age")
        }
        ))
        sortAlert.addAction(UIAlertAction(title: "Sort by name", style: .default, handler: {(action:UIAlertAction) in
            self.sortBy(parameter: "name")
            }
        ))
        sortAlert.addAction(UIAlertAction(title: "Back to default", style: .default, handler: {(action:UIAlertAction) in
            self.concatenateTable()
            self.tableView.reloadData()
        }
        ))
        
        
         self.present(sortAlert, animated: true, completion: nil)
    }
    
    
    
    func startObservingDB () {
        dbRef.observe(.value, with: {(snapshot:DataSnapshot) in
            var newUsers = [User]()
            
            for user in snapshot.children {
                let userObject = User (snapshot: user as! DataSnapshot)
                newUsers.append(userObject)
            }
            users = newUsers
            self.tableView.reloadData()
            
        })
    }
    
    @IBAction func AddUser(_ sender: Any) {
        let newUserAlert = UIAlertController(title: "New User", message: "Please enter the information stated below", preferredStyle: .alert)
        newUserAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Name"
        }
        newUserAlert.addTextField {(textField:UITextField) in
            textField.placeholder = "Age"
        }
        newUserAlert.addTextField {(textField:UITextField) in
            textField.placeholder = "Gender (M/F)"
        }
        newUserAlert.addTextField {(textField:UITextField) in
            textField.placeholder = "Hobbies (Separated with ,)"
        }
        
        newUserAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action:UIAlertAction) in
                let new_name = newUserAlert.textFields![0].text!
                let new_age = newUserAlert.textFields![1].text!
                let new_gender = newUserAlert.textFields![2].text!
                let new_hobbies = newUserAlert.textFields![3].text!
            
            let user = User(name: new_name, age: Int(new_age)!, gender: new_gender, hobbies: new_hobbies, id: users.count, image: "none")
            let userRef = self.dbRef.child(String(users.count))
                userRef.setValue(user.toAnyObject())
            
        } ) )
        
        self.present(newUserAlert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SingleCell
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.hobbies
        
        if (user.gender == "M"){
            
            cell.backgroundColor = UIColor .init(red: 168.0/255.0, green: 220.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        }else{
            cell.backgroundColor = UIColor .init(red: 255.0/255.0, green: 168.0/255.0, blue: 244.0/255.0, alpha: 0.6)
        }
        
        cell.gender_label.text = "G: "+user.gender
        cell.age_label.text = "Age:"+String(user.age)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            user.itemRef?.removeValue()
        }
    }

    //to move cells
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func sortBy(parameter: String){
        if parameter=="name" {
            users.sort(by: {$0.name < $1.name})
        }
        tableView.reloadData()
        if parameter=="age"{
            users.sort(by: {$0.age < $1.age})
        }
        if parameter=="id"{
            users.sort(by: {$0.id < $1.id})
        }
    }
    
    func hideGender(gender: String){
        if (gender == "M"){
            for user in users {
                if (user.gender=="M"){
                    temp.append(user)
                    users.remove(at: users.index(where:
                        {(user)->Bool in user.gender == "M"})!
                )}
            }
        }
        else{
            for user in users {
            if (user.gender=="F"){
                temp.append(user)
                users.remove(at: users.index(where:
                    {(user)->Bool in user.gender == "F"})!
                )}
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("section: \(indexPath.section)")
        print ("row: \(indexPath.row)")
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func concatenateTable(){
        if temp.count != 0 {
            for user in self.temp {
                users.append(user)
            }
        }
        self.sortBy(parameter: "id")
    }
    

}


