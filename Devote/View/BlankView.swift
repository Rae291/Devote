//
//  BlankView.swift
//  Devote
//
//  Created by APPLE on 07/12/22.
//

import SwiftUI

struct BlankView: View {
    
    //MARK: - Property
    var bgColor: Color
    var bgOpacity: Double
    
    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(bgColor)
        .opacity(bgOpacity)
        .blendMode(.overlay)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(bgColor: .black, bgOpacity: 0.3)
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
    }
}
