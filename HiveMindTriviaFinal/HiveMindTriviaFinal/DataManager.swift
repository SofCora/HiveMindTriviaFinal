//
//  DataManager.swift
//  HiveMindTriviaFinal
//
//  Created by Sofia G. Cora on 4/25/24.
//

import SwiftUI
import Firebase
class DataManager: ObservableObject {
    @Published var entries: [Entry] = []
    
    init(){
        fetchEntries()
    }
    
    func fetchEntries(){
        entries.removeAll()
        let db = Firestore.firestore()
        //let ref = db.collection("Entries")
        let query = db.collection("Entries").order(by: "points", descending: true)
        query.getDocuments { snapshot, error in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents{
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let points = data["points"] as? Int ?? -100
                    let entry = Entry(id: id, name: name, points: points)
                    self.entries.append(entry)
                }
            }
        }
    }
    
    func addEntry(name: String, userId: String){
        let db = Firestore.firestore()
        let ref = db.collection("Entries").document(userId)
        ref.setData(["id": userId, "name": name, "points": 0]){ error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        objectWillChange.send()
    }//end addEntry() func
    
    func incrementEntry(name: String, userId: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Entries").document(userId)
        ref.updateData([
            "points": FieldValue.increment(Int64(1)) //needs to be specified as an integer
        ]) { err in
            if let err = err {
                print("Error updating score: \(err)")
            } else {
                print("Score updated successfully!!!")
            }
        }
    }//end incrementEntry()
}
