//
//  QuestionView.swift
//  HiveMindTriviaFinal
//
//  Created by Sofia G. Cora on 4/25/24.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var username: String
    @Binding var id: String
    let questions: [Trivia]
    @State private var currentPairIndex = 0
    @State private var showAnswer = false
    @State private var selectedChoice: String?
    @State private var shuffledChoices: [String] = []
    @State private var hasMadeSelection = false
    @State private var showLeaderboardView = false
    @State private var points = 0
    var body: some View {
        ZStack{
            Image("gradient")
                .resizable()
                .frame(width:500, height:1500)
        VStack {
            Image("honey-pot")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                .padding(.top, 10)
            
            Text(questions[currentPairIndex].question)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 183.0/255.0, green: 124.0/255.0, blue: 58.0/255.0))
                        .frame(width: 350, alignment: .center)
                        .lineLimit(nil) // Allow unlimited lines
                        .multilineTextAlignment(.center)
                        .padding()
                    let choices = questions[currentPairIndex].incorrectAnswers + [questions[currentPairIndex].correctAnswer]
                    let shuffledChoices = choices.shuffled()
            
                    ForEach(shuffledChoices, id: \.self) { choice in
                        Button(action: {
                            showAnswer = true
                            selectedChoice = choice
                            hasMadeSelection = true
                        }){
                            Text(choice)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 254.0/255.0, green: 226.0/255.0, blue: 127.0/255.0))
                                .frame(width: 350, alignment: .center)
                                .lineLimit(nil) // Allow unlimited lines
                                .multilineTextAlignment(.center)
                                
                        }
                        .padding()
                        .disabled(hasMadeSelection)
                    }
                    
            if showAnswer && (selectedChoice == questions[currentPairIndex].correctAnswer) {
                        //points += 1
                    
                        Text("Answer: \(questions[currentPairIndex].correctAnswer)")
                            .frame(width: 350, alignment: .center)
                            .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                            .padding(.bottom, 10)
                        Text("CORRECT")
                            .foregroundColor(.green)
                            .bold()
                            
                            .onAppear {
                                points = points + 1
                                dataManager.incrementEntry(name: username, userId: id)
                            }
                        
                    }
            else if showAnswer && (selectedChoice != questions[currentPairIndex].correctAnswer){
                Text("Answer: \(questions[currentPairIndex].correctAnswer)")
                    .frame(width: 350, alignment: .center)
                    .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                Text("better luck next time :((((")
                    .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
                    
            }
                    
            Button("Next Question") {
                    currentPairIndex = (currentPairIndex + 1)
                    
                           showAnswer = false
                           selectedChoice = nil
                           hasMadeSelection = false
                           
                           if currentPairIndex == (questions.count - 1){
                               print("we;ve reached end of the questions")
                               showLeaderboardView = true
                               
                           }
                        
                       }
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(Color(red: 184.0/255.0, green: 94.0/255.0, blue: 94.0/255.0))
            .padding(.top, 20)
                       
            HStack{
            Image("bee")
                .resizable()
                .frame(width:60, height:55)
            Image("bee")
                    .resizable()
                    .frame(width:60, height:55)
            Image("bee")
                    .resizable()
                    .frame(width:60, height:55)
            Image("bee")
                    .resizable()
                    .frame(width:60, height:55)
            Image("bee")
                    .resizable()
                    .frame(width:60, height:55)
            Image("bee")
                    .resizable()
                    .frame(width:60, height:55)
            Image("bee")
                .resizable()
                .frame(width:60, height:55)
        }//end vstack
        }
    
        .padding(.top,20)
        .sheet(isPresented: $showLeaderboardView) {
            LeaderboardView(totalPoints: points)
                .environmentObject(dataManager)
        }
                .padding()
            }
    
}
}
