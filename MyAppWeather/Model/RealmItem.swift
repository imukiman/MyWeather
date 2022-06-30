//
//  RealmItem.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 16/06/2022.
//

import Foundation
import RealmSwift

class Location: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var lat: String
    @Persisted var lon: String
}
class ArrayLocations: Object {
    let locations = List<Location>()
}

class DBManage{
    private var db : Realm
    static let shareInstance = DBManage()
    private init(){
        db = try! Realm()
    }
    
    func addData(_ object: Location){
        
        try! db.write({
            db.add(object)
        })
    }
    
    func readData() -> Results<Location>{
        let result : Results<Location> = db.objects(Location.self)
        return result
    }

    func deleteAnyObject(code: String){
        do {
            let realm = try Realm()
            let object = realm.objects(Location.self).filter("name == %@", code)
            try! realm.write {
                    realm.delete(object)
            }
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }

    }
    
    func deleteAllObject(){
        do {
            let realm = try Realm()
            try! realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
    }
    
    func checkPrimaryKey(location: Location) -> Bool{
        do {
            let realm = try Realm()
            let object = realm.objects(Location.self).filter("name = %@", location.name)
            guard object.first != nil else{
                try! realm.write({
                    realm.add(location)
                })
                return true
            }
            print("Location ko dc tao")
            return false
        } catch  {
            return false
        }
    }
    
}
