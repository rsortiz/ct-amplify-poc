//
//  CTButton.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI

struct CTButton: View {
    let imageName: String = ""
    let title: String
    let action: () -> Void
    let buttonColor: UIColor
    
    var body: some View {
        
        Button(action: action, label: {
            HStack {
                
                if imageName.count > 0 {
                    Image(systemName: imageName)
                        .font(Font.system(size: 15).bold())
                }
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)

            }
            .frame(maxWidth: .infinity)
            
        })
        .foregroundColor(.white)
        .padding(12)
        .background(Color(buttonColor))
        .cornerRadius(4)
        
    }
}

struct CTButton_Previews: PreviewProvider {
    static var previews: some View {
        CTButton(title: "Click me", action: {
            print("Clicked")
        }, buttonColor: .orange)
    }
}
