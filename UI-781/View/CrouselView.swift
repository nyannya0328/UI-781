//
//  CrouselView.swift
//  UI-781
//
//  Created by nyannyan0328 on 2022/10/29.
//

import SwiftUI

struct CrouselView<Content : View,ID,Item>: View where Item:RandomAccessCollection,Item.Element : Equatable,Item.Element : Identifiable,ID : Hashable{
    var cardSize : CGSize
    var items : Item
    var id : KeyPath<Item.Element,ID>
    var content : (Item.Element) ->Content
    
    var hostingViews : [UIView] = []

    @State var offset : CGFloat = 0
    @State var lastStoredoffset : CGFloat = 0
    @State var animationDulation : CGFloat = 0

    
    
    init(size: CGSize, items: Item, id: KeyPath<Item.Element, ID>,@ViewBuilder content: @escaping (Item.Element) -> Content) {
        self.cardSize = size
        self.items = items
        self.id = id
        self.content = content
        
        for item in items{
            
            
            let hostiongView = convertToUIView(item: item).view!
            
            
            hostingViews.append(hostiongView)
            
            
        }
    }
   
    
    
    
    var body: some View {
        CaroselHelper(views: hostingViews, cardSize: cardSize, animationDulation: animationDulation, offset: offset)
            .frame(width: cardSize.width,height: cardSize.height)
            .frame(maxWidth: .infinity,alignment: .center)
            .contentShape(Rectangle())
            .gesture(
            
                DragGesture().onChanged({ value in
                    
                    animationDulation = 0
                    
                    offset = (value.translation.width * 0.3) + lastStoredoffset
                    
                })
                .onEnded({ value in
                    
                    guard items.count > 0 else{
                        lastStoredoffset = offset
                        
                        return
                        
                    }
                    
                    animationDulation = 0.2
                    
                    let angleperCard = 360 / CGFloat(items.count)
                    
                    offset = CGFloat(Int((offset / angleperCard.rounded()))) * angleperCard
                    
                    
                    lastStoredoffset = offset
                    
                   
                    
                })
            
            
            )
            .onChange(of: items.count) { newValue in
                
                guard newValue > 0 else{return}
                
                animationDulation = 0.2
                let angleperCard = 360 / CGFloat(newValue)
                
                offset = CGFloat(Int((offset / angleperCard.rounded()))) * angleperCard
                
                lastStoredoffset = offset
                
            }
    }
    
    func convertToUIView(item : Item.Element) -> UIHostingController<Content>{
        
        let hostiongView = UIHostingController(rootView: content(item))
        hostiongView.view.frame.origin = .init(x: cardSize.width / 2, y: cardSize.height / 2)
        hostiongView.view.backgroundColor = .clear
        
        return hostiongView
        
        
    }
}

struct CrouselView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate
struct CaroselHelper : UIViewRepresentable{
    var views : [UIView]
    var cardSize : CGSize
    var animationDulation : CGFloat
    var offset : CGFloat
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
       // view.backgroundColor = .clear
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let circleAngel = 360.0 / CGFloat(views.count)
        var angle : CGFloat = offset
        
        if uiView.subviews.count > views.count{
            
            
            uiView.subviews[uiView.subviews.count - 1].removeFromSuperview()
        }
        
        
        for (view,index) in zip(views, views.indices){
            
            if uiView.subviews.indices.contains(index){
                
                applyTransForm(view: uiView.subviews[index], angle: angle)
                angle += circleAngel
                
            }
            else{
                
                
                let hostingView = view
                hostingView.frame = .init(origin: .zero, size: cardSize)
                uiView.addSubview(hostingView)
                
                
                applyTransForm(view: uiView.subviews[index], angle: angle)
                angle += circleAngel
            }
        }
        
        
        
        
    }
    func applyTransForm(view : UIView,angle : CGFloat){
        var transForm3D = CATransform3DIdentity
        transForm3D.m34 = -1 / 500
        
        transForm3D = CATransform3DRotate(transForm3D, degToRead(deg: angle), 0, 1, 0)
        transForm3D = CATransform3DTranslate(transForm3D, 0, 0, 150)
    
        UIView.animate(withDuration:animationDulation) {
            
            view.transform3D = transForm3D
            
            
            
            
        }
        
        
    }
    func degToRead(deg : CGFloat)->CGFloat{
        
        return (deg * .pi) / 180
    }
}
