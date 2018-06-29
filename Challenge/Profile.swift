//
//  Profile.swift
//  Challenge
//
//  Created by Kevin on 6/29/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class Profile: UIViewController {
    @IBOutlet weak var image:UIImageView!
    
    @IBOutlet weak var name_label:UILabel!
    @IBOutlet weak var age_label:UILabel!
    @IBOutlet weak var gender_label:UILabel!
    @IBOutlet weak var hobbies_label:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name_label.text = users[myIndex].name
        age_label.text = String(users[myIndex].age)
        gender_label.text = users[myIndex].gender
        hobbies_label.text = users[myIndex].hobbies
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
