//
//  ViewController.swift
//  Contacts-App With CoreData
//
//  Created by Ömer Faruk Kılıçaslan on 18.04.2022.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var kisilerTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var kisilerListe = [Kisiler]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        searchBar.delegate = self
        
        ref = Database.database().reference()
        tumKisilerAl()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indeks = sender as? Int
        
        if segue.identifier == "toDetay" {
            let gidilecekVC = segue.destination as! KisiDetayViewController
            gidilecekVC.kisi = kisilerListe[indeks!]
        }
        
        if segue.identifier == "toGuncelle" {
            
            let gidilecekVC = segue.destination as! KisiGuncelleViewController
            gidilecekVC.kisi = kisilerListe[indeks!]
        }
    }
    
    func tumKisilerAl(){
        ref.child("kisiler").observe(.value, with: { snapshot in
            
            if let gelenVeriButunu = snapshot.value as? [String:AnyObject]{
                self.kisilerListe.removeAll()
                for gelenSatirVerisi in gelenVeriButunu {
                    if let sozluk = gelenSatirVerisi.value as? NSDictionary{
                        let key = gelenSatirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        
                        let kisi = Kisiler(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                        
                        self.kisilerListe.append(kisi)
                        
                    }
                }
            }
            else{
                self.kisilerListe = [Kisiler]()
            }
            DispatchQueue.main.async {
                self.kisilerTableView.reloadData()
            }
            
        })
    }
    
    
    func aramaYap(aramaKelimesi:String){
        ref.child("kisiler").observe(.value, with: { snapshot in
            
            if let gelenVeriButunu = snapshot.value as? [String:AnyObject]{
                self.kisilerListe.removeAll()
                for gelenSatirVerisi in gelenVeriButunu {
                    if let sozluk = gelenSatirVerisi.value as? NSDictionary{
                        let key = gelenSatirVerisi.key
                        let kisi_ad = sozluk["kisi_ad"] as? String ?? ""
                        let kisi_tel = sozluk["kisi_tel"] as? String ?? ""
                        
                        if kisi_ad.contains(aramaKelimesi){
                            let kisi = Kisiler(kisi_id: key, kisi_ad: kisi_ad, kisi_tel: kisi_tel)
                            
                            self.kisilerListe.append(kisi)
                        }

                    }
                }
            }
            else{
                self.kisilerListe = [Kisiler]()
            }
            DispatchQueue.main.async {
                self.kisilerTableView.reloadData()
            }
            
        })
    }

}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiHucre", for: indexPath) as! KisiHucreTableViewCell
        let kisi = kisilerListe[indexPath.row]
        
        cell.kisiYaziLabel.text = "\(kisi.kisi_ad!)---- \(kisi.kisi_tel!)"
        
        return cell
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetay", sender: indexPath.row)
        
        
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let silAction = UITableViewRowAction(style: .default, title: "Sil", handler: { (action:UITableViewRowAction,indexPath:IndexPath) -> Void in
//
//            print("Sil Tıklandı : \(self.liste[indexPath.row])")
//
//
//        })
//
//        let guncelleAction = UITableViewRowAction(style: .normal, title: "Guncelle", handler: { (action:UITableViewRowAction,indexPath:IndexPath) -> Void in
//
//            print("Güncelle Tıklandı : \(self.liste[indexPath.row])")
//
//            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
//
//
//        })
//
//        return [silAction,guncelleAction]
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { (contextualAction, view, boolValue) in
            
            let kisi = self.kisilerListe[indexPath.row]
            
            self.ref.child("kisiler").child(kisi.kisi_id!).removeValue()
            
        }
        
        let guncelleAction = UIContextualAction(style: .normal, title: "Güncelle") { (contextualAction,view,boolValue) in
            
            self.performSegue(withIdentifier: "toGuncelle", sender: indexPath.row)
        
        }
        return UISwipeActionsConfiguration(actions: [silAction,guncelleAction])
    }
}

extension ViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama Sonuç : \(searchText)")
        
        if searchText == ""{
            tumKisilerAl()
        }
        else{
            aramaYap(aramaKelimesi:searchText)
        }
        
    }
}
