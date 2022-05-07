//
//  KisiEkleViewController.swift
//  Contacts-App With CoreData
//
//  Created by Ömer Faruk Kılıçaslan on 18.04.2022.
//

import UIKit
import Firebase

class KisiEkleViewController: UIViewController {

    @IBOutlet weak var kisiAdTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
    
    @IBAction func ekle(_ sender: Any) {
        
        if let ad = kisiAdTextField.text, let tel = kisiTelTextField.text {
           kisiEkle(kisi_ad: ad, kisi_tel: tel)
        }
    }
    
    func kisiEkle(kisi_ad:String,kisi_tel:String){
        
        let dict:[String:Any] = ["kisi_id":"","kisi_ad":kisi_ad,"kisi_tel":kisi_tel]
        
        let newRef = ref.child("kisiler").childByAutoId()
        newRef.setValue(dict)
    }
}
