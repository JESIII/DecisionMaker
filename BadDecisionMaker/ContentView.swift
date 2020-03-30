//
//  ContentView.swift
//  BadDecisionMaker
//
//  Created by CSUFTitan on 12/15/1398 AP.
//  Copyright © 1398 CSUFTitan. All rights reserved.
//

import SwiftUI
import AVFoundation
enum ViewState {
    case ShowingHome
    case ShowingDecisions
    case ShowingHelp
    case ShowingCoinFlip
    case ShowingShaker
    case ShowingPlaceholder
    case ShowingDisclaimer
}
var audioPlayer: AVAudioPlayer!

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find sound resource")
        }
    }
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
            Shaker(showing:$showing, decisions: $decisions)
            .opacity( showing == .ShowingShaker ? 1.0 : 0.0 )
            PlaceHolder(showing:$showing)
            .opacity( showing == .ShowingPlaceholder ? 1.0 : 0.0 )
            DisclaimerView(showing:$showing)
            .opacity( showing == .ShowingDisclaimer ? 1.0 : 0.0 )
        }
        .animation(.easeInOut)
    }
}
struct HomeView: View {
    @Binding var showing : ViewState
    var body: some View {
        ZStack{
            Color(.white).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Bad").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-5Regular", size: 64)).foregroundColor(.black)
                Text("Decision").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-3Light", size: 48)).foregroundColor(.black)
                Text("Maker").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 32)).foregroundColor(.black)
                Image("sheep").resizable().aspectRatio(contentMode: .fit).frame(width: 300)
                Button(action:{
                    playSound(sound: "click", type: "wav")
                    self.showing = .ShowingDecisions
                }){
                    Text("Start").font(.custom("RootSans-5Regular", size: 18)).padding().background(Color.black).foregroundColor(Color.white).cornerRadius(40).padding(4).overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 2)
                    ).padding(10)
                }
                Button(action:{
                    playSound(sound: "click", type: "wav")
                    self.showing = .ShowingHelp
                }){
                    Text("Help").font(.custom("RootSans-5Regular", size: 18)).padding().background(Color.black).foregroundColor(Color.white).cornerRadius(40).padding(4).overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 2)
                    ).padding(10)
                }
                Button(action:{
                    playSound(sound: "click", type: "wav")
                    self.showing = .ShowingDisclaimer
                }){
                    Text("Disclaimer").font(.custom("RootSans-5Regular", size: 18)).foregroundColor(.black).padding(10)
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
            Text("To use the app simply press the button that says, \"Start,\" enter your terrible decisions, and click the only button on the screen so it can make up your mind.\n2 decisions will do a coinflip, and greater than 2 will let you shake for an answer.").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 18)).padding(.bottom, 200.0)
            Button("Back"){
                playSound(sound: "click", type: "wav")
                self.showing = .ShowingHome
            }
        }
    }
}
struct DisclaimerView: View {
    @Binding var showing : ViewState
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("I'm not responsible for your decisions, all I do is randomize D:\nDon't do anything dumb, thanks.").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 18)).padding(.bottom, 200.0)
            Button("Back"){
                playSound(sound: "click", type: "wav")
                self.showing = .ShowingHome
            }
        }
    }
}
struct PlaceHolder: View{
    @Binding var showing : ViewState
    var body: some View{
        VStack{
            Text("Looks like you already made your decision...").multilineTextAlignment(.leading).frame(width: 300.0).font(.custom("RootSans-1Thin", size: 18)).padding(.bottom, 200.0)
            Button("Back"){
                playSound(sound: "click", type: "wav")
                self.showing = .ShowingDecisions
            }
        }
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
                        playSound(sound: "click", type: "wav")
                        self.showing = .ShowingHome
                    }
                    Spacer()
                    Spacer()
                }.padding()
                TextField("Enter a decision", text: $newDecision, onCommit: addNewDecision).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                            List{
                                ForEach(self.decisions, id: \.self){
                                    Text("\($0)")
                                }.onDelete(perform: removeRows)
                            }
                Button(action:{
                    playSound(sound: "click", type: "wav")
                    if self.decisions.count == 2 {
                        self.decisions.shuffle()
                        self.showing = .ShowingCoinFlip
                    }else if self.decisions.count == 1{
                        self.showing = .ShowingPlaceholder
                    }else{
                        self.decisions.shuffle()
                        self.showing = .ShowingShaker
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
                        playSound(sound: "click", type: "wav")
                        self.showing = .ShowingDecisions
                    }
                    Spacer()
                    Spacer()
                }.padding()
                Spacer()
                Button(action:{
                    playSound(sound: "blop", type: "wav")
                    withAnimation(.interpolatingSpring(stiffness: 20, damping: 15)) {
                        self.animationAmount += 360
                    }
                    
                }){
                    self.animationAmount >= 360 ? Text(decisions[0]).frame(width: 300, height: 300).font(.custom("RootSans-3Light", size: 18)) : Text("Click to Flip").frame(width: 300, height: 300).font(.custom("RootSans-3Light", size: 24))
                    
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
                Spacer()
            }
                
            
        }
        func getRandomColor() -> UIColor {
             //Generate between 0 to 1
             let red:CGFloat = CGFloat(drand48())
             let green:CGFloat = CGFloat(drand48())
             let blue:CGFloat = CGFloat(drand48())
        
             return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
        }
}
struct Shaker: View{
    @Binding var showing : ViewState
    @Binding var decisions : [String]
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    @State private var currColor = Color.gray
    @State private var result = "Shake Me!"
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button("Back"){
                        playSound(sound: "click", type: "wav")
                        self.showing = .ShowingDecisions
                    }.padding()
                    Spacer()
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            Text(result).frame(width: 250, height: 250).background(currColor).clipShape(Circle())
                .foregroundColor(.black)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                .gesture(DragGesture()
                .onChanged { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.currColor = Color(self.getRandomColor())
                    self.result = self.randomString()
            }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.newPosition = self.currentPosition
                    self.result = self.decisions[0]
                }
            )
        }
    }
    func randomString()->String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        return String((0..<10).map{ _ in letters.randomElement()! })
    }
    func getRandomColor() -> UIColor {
         let red:CGFloat = CGFloat(drand48())
         let green:CGFloat = CGFloat(drand48())
         let blue:CGFloat = CGFloat(drand48())
         return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
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
