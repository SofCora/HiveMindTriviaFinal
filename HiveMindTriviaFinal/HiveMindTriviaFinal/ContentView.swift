//
//  ContentView.swift
//  HiveMindTriviaFinal
//
//  Created by Sofia G. Cora on 4/25/24.
//


import SwiftUI
import Foundation
import Firebase

struct Trivia: Decodable {
    let category: String
    let id: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let question: String
    let tags: [String]
    let type: String
    let difficulty: String
    let regions: [String]
    let isNiche: Bool
}


struct ContentView: View {
    @State private var username: String = ""
    @State private var id: String = ""
    @State private var points: Int = 0
    @State private var showQuestionView = false
    @State private var triviaData: [Trivia] = []
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundHoney")
                    .resizable()
                    .frame(width: 550, height: 1200)
                VStack {
                    ZStack{
                        Rectangle()
                                        .foregroundColor(Color(red: 255.0/255.0, green: 208.0/255.0, blue: 128.0/255.0))
                                        .frame(width: 320, height: 100)
                                        .cornerRadius(10)
                        Text("HiveMind Trivia")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                    }
                    
                    ZStack{
                        Rectangle()
                                        .foregroundColor(Color(red: 255.0/255.0, green: 208.0/255.0, blue: 128.0/255.0))
                                        .frame(width: 370, height: 30)
                                        .cornerRadius(10)
                        Text("Answer Questions, Win Points, Beat Your Friends")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                        
                    }
                    
                    
                    Image("honey-pot")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                    
                    Text("Sign In With A Username")
                        .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .background(Color(red: 255.0/255.0, green: 208.0/255.0, blue: 128.0/255.0))
                    
                   
                    TextField("Enter A Username", text: $username)
                        .frame(width: 350, height: 40)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        //addDataToFirebase()
                        id = generateUniqueUserID()
                        dataManager.addEntry(name: username, userId: id)
                        
                        //api stuff
                        self.showQuestionView = true
                        Task {
                            await fetchTriviaData()
                        }
                    }) {
                        Text("Begin")
                            .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                            .font(.title)
                            .bold()
                    }
                    .sheet(isPresented: $showQuestionView) {
                        if !triviaData.isEmpty {
                            QuestionView(username: $username, id: $id, questions: triviaData)
                        } else {
                            Text("Fetching Questions...")
                        }
                    }
                    
                    

                }
            }//end zstack
            .navigationBarHidden(true)
        }//end NavigationView
    }//end body
       
    //API stuff
    func fetchTriviaData() async{
            guard let url = URL(string: "https://the-trivia-api.com/api/questions?&limit=11") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([Trivia].self, from: data)
                    DispatchQueue.main.async {
                        triviaData = decodedData
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }.resume()
        }
    }

func generateUniqueUserID() -> String {
    let timestamp = Int(Date().timeIntervalSince1970) // so im using a combo of random number and
    //timestamp so that theres a low chance of the id's repeating
    let random = Int.random(in: 1000...9999)
    let uniqueID = "\(timestamp)\(random)" // Concatenate timestamp and random number
    //ive since learned i think i can do all of this with a builtin function UUID() or something but whatever this works
    return uniqueID
}
//end struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
