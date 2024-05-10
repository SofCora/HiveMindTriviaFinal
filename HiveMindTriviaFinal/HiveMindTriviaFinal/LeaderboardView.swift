//
//  LeaderboardView.swift
//  HiveMindTriviaFinal
//
//  Created by Sofia G. Cora on 4/25/24.
//

import SwiftUI
import Firebase

struct User: Identifiable {
    let id: String
    let username: String
    let points: Int
}

struct LeaderboardView: View {
    @EnvironmentObject var dataManager: DataManager
    let totalPoints: Int
    
    var body: some View {
        NavigationView{
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("CONGRATS ON MAKING IT TO THE END")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                Text("total points: \(totalPoints) out of 3")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 18.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                    .background(Color(.white))
                    .padding()
                Text("Lets check out the leaderboard!!!!")
                   .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                List(dataManager.entries, id: \.id) { entry in
                    Text(entry.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                    Text("score: \(entry.points)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 255.0/255.0, green: 208.0/255.0, blue: 128.0/255.0))
                    
                }
                NavigationLink(destination: ContentView()){
                    Text("Play again")
                        .bold()
                        .foregroundColor(.brown)
                       
                }
                
            }
        }
        .onAppear {
            dataManager.fetchEntries()
        }
        
    }
}
}
