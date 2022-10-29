//
//  Home.swift
//  UI-781
//
//  Created by nyannyan0328 on 2022/10/29.
//

import SwiftUI

struct Home: View {
    @State var cards : [Card] = []
    var body: some View {
        VStack{
            
            
            CrouselView(size: CGSize(width: 150, height: 220), items: cards, id: \.id) { card in
                
                cardView(card: card)
                
            }
            .padding(.bottom,100)
            
            HStack(spacing:15){
                
                Button {
                    
                    if cards.count != 7{
                        cards.append(.init(imageFiles: "p\(cards.count + 1)"))
                    }
                    
                    
                    
                } label: {
                    
                 
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                Button {
                    
                    if !cards.isEmpty{
                        
                        cards.removeLast()
                    }
                    
                } label: {
                    
                 
                    Label("Delete", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            
        }
        .onAppear{
            
            for index in 1...7{
                
                cards.append(.init(imageFiles: "p\(index)"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct cardView : View{
    var card : Card
    
    var body: some View{
        
        ZStack{
            
            Image(card.imageFiles)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
       
         .frame(width: 150,height: 220)
         .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
