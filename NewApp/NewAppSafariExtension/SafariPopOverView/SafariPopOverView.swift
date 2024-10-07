//
//  SafariPopOverView.swift
//  NewAppSafariExtension
//
//  Created by Emre Karaoğlu on 7.10.2024.
//

import SwiftUI

struct SafariPopOverView: View {
    var selectedText = ""
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                print("There you go: \(selectedText)")
            }, label: {
                Text("Click me!")
            })
        }
        .frame(width: 300, height: 200, alignment: .center)
    }
}

#Preview {
    SafariPopOverView()
}
