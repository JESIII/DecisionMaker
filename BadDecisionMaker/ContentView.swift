//
//  ContentView.swift
//  BadDecisionMaker
//
//  Created by CSUFTitan on 12/15/1398 AP.
//  Copyright © 1398 CSUFTitan. All rights reserved.
//

import SwiftUI
import GameplayKit
import AVFoundation
enum ViewState {
    case ShowingHome
    case ShowingDecisions
    case ShowingHelp
    case ShowingCoinFlip
    case ShowingChooseDot
    case ShowingPlaceholder
}
struct ContentView: View{
    @State var showing : ViewState = .ShowingHome
    @State var decisions = [String]()
    var body: some View{
        ZStack {
            HomeView(showing:$showing)
                .opacity( showing == .ShowingHome ? 1.0 : 0.0 )
            DecisionsView(showing:$showing, decisions:$decisions)
                .opacity( showing == .ShowingDecisions ? 1.0 : 0.0 )
            HelpView(showing:$showing)
                .opacity( showing == .ShowingHelp ? 1.0 : 0.0 )
            CoinFlip(showing:$showing, decisions: $decisions)
            .opacity( showing == .ShowingCoinFlip ? 1.0 : 0.0 )
            ChooseDot(showing:$showing, decisions: $decisions)
            .opacity( showing == .ShowingChooseDot ? 1.0 : 0.0 )
            PlaceHolder(showing:$showing)
            .opacity( showing == .ShowingPlaceholder ? 1.0 : 0.0 )
        }
        .animation(.easeInOut)
    }
}
struct HomeView: View {
    @Binding var showing : ViewState
    var body: some View {
        ZStack{
            Color(.white).edgesIgnoringSafeArea(.all)
            Image("sheep").resizable().scaledToFit()
            VStack{
                Text("Bad").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-5Regular", size: 64)).foregroundColor(.black)
                Text("Decision").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-3Light", size: 48)).foregroundColor(.black)
                Text("Maker").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 32)).padding(.bottom, 220.0).foregroundColor(.black)
                Button(action:{
                    self.showing = .ShowingDecisions
                }){
                    Text("Start").font(.custom("RootSans-5Regular", size: 18)).padding().background(Color.black).foregroundColor(Color.white).cornerRadius(40).padding(4).overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 2)
                    ).padding(10)
                }
                Button(action:{
                    self.showing = .ShowingHelp
                }){
                    Text("Help").font(.custom("RootSans-5Regular", size: 18)).padding().background(Color.black).foregroundColor(Color.white).cornerRadius(40).padding(4).overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 2)
                    ).padding(10)
                }
            }
        }
    }
}
struct HelpView: View {
    @Binding var showing : ViewState
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("To use the app simply press the button that says, \"Don't click this,\" enter your terrible decisions, and click the only button on screen.").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 18)).padding(.bottom, 200.0)
            Button("Back"){
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
}
struct PlaceHolder: View{
    @Binding var showing : ViewState
    var body: some View{
        Text("Looks like you already made your decision...").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 18)).padding(.bottom, 200.0)
    }
}
struct DecisionsView: View {
    @Binding var showing : ViewState
    @Binding var decisions : [String]
    @State private var newDecision = ""
    @State private var showingAction = false
    var body: some View {
            VStack{
                HStack{
                    Button("Back"){
                        self.showing = .ShowingHome
                    }
                    Spacer()
                    Spacer()
                }.padding()
                TextField("Enter a decision", text: $newDecision, onCommit: addNewDecision).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                List{
                    ForEach(decisions, id: \.self){
                        Text("\($0)")
                    }.onDelete(perform: removeRows)
                }
                Button(action:{
                    if self.decisions.count == 2 {
                        self.showing = .ShowingCoinFlip
                    }else if self.decisions.count == 6{
                        self.showing = .ShowingPlaceholder
                    }else if self.decisions.count == 1{
                        self.showing = .ShowingPlaceholder
                    }else{
                        self.showing = .ShowingChooseDot
                    }
                }){
                    Text("Make Decision").font(.custom("RootSans-5Regular", size: 18)).padding().background(Color.black).foregroundColor(Color.white).cornerRadius(40).padding(4).overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 2)
                    ).padding(10)
            }
        }
    }
    func addNewDecision(){
        decisions.append(newDecision)
        newDecision = ""
    }
    func removeRows(at offsets: IndexSet){
        decisions.remove(atOffsets: offsets)
    }
}
struct CoinFlip: View{
    @Binding var showing : ViewState
    @Binding var decisions : [String]
    @State private var animationAmount2: CGFloat = 1
    @State private var animationAmount = 0.0
        var body: some View{
            VStack{
                HStack{
                    Button("Back"){
                        self.showing = .ShowingDecisions
                    }
                    Spacer()
                    Spacer()
                }.padding()
                Button(action:{
                    self.playSound()
                    withAnimation(.interpolatingSpring(stiffness: 20, damping: 15)) {
                        self.animationAmount += 360
                    }
                    
                }){
                    self.animationAmount >= 360 ? Text(randomChoice()).frame(width: 300, height: 300).font(.custom("RootSans-3Light", size: 18)) : Text("Click to Flip").frame(width: 300, height: 300).font(.custom("RootSans-3Light", size: 24))
                    
                }
                    .background(Color(getRandomColor())).foregroundColor(.white)
                    .clipShape(Circle()).overlay(
                        Circle()
                            .stroke(Color(getRandomColor()))
                            .scaleEffect(animationAmount2)
                            .opacity(Double(2 - animationAmount2))
                            .animation(
                                Animation.easeOut(duration: 1)
                                    .repeatForever(autoreverses: false)
                            )
                    ).onAppear {
                        self.animationAmount2 = 2
                    }
                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 0, z: 0))
            }
                
            
        }
        func randomChoice() -> String{
            let rand = GKRandomDistribution(lowestValue: 0, highestValue: decisions.count-1)
            return decisions[rand.nextInt()]
        }
        func getRandomColor() -> UIColor {
             //Generate between 0 to 1
             let red:CGFloat = CGFloat(drand48())
             let green:CGFloat = CGFloat(drand48())
             let blue:CGFloat = CGFloat(drand48())
        
             return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
        }
        func playSound() {
            var bombSoundEffect: AVAudioPlayer?
            let path = Bundle.main.path(forResource: "blop.wav", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                bombSoundEffect?.play()
            } catch {
                // couldn't load file :(
            }
        }
}
struct ChooseDot: View{
    @Binding var showing : ViewState
    @Binding var decisions : [String]
    @State private var animationAmount = 0.0
    var body: some View{
        ForEach(0..<decisions.count){
        Button(self.animationAmount > 360 ? self.decisions[$0] : "Click to Flip") {
            withAnimation(.interpolatingSpring(stiffness: 9, damping: 1)) {
                        self.animationAmount += 360
            }
        }
                .padding(75)
        .background(Color(self.getRandomColor()))
                .foregroundColor(.black)
                .clipShape(Circle())
        .position(x: CGFloat(self.randomX()), y: CGFloat(self.randomY()))
        .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 1, y: 0, z: 0))
    }
    }
    func getRandomColor() -> UIColor {
         //Generate between 0 to 1
         let red:CGFloat = CGFloat(drand48())
         let green:CGFloat = CGFloat(drand48())
         let blue:CGFloat = CGFloat(drand48())
    
         return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    func randomX() -> Int{
        let rand = GKRandomDistribution(lowestValue: 75, highestValue: 275)
        return rand.nextInt()
    }
    func randomY() -> Int{
        let rand = GKRandomDistribution(lowestValue: 75, highestValue: 175)
        return rand.nextInt()
    }
}
struct rollDie: View{
    var body: some View{
        VStack{
            Text("")
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
