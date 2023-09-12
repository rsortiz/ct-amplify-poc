//
//  PartnersView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 11/09/2023.
//

import SwiftUI

struct PartnersView: View {
    
    @State var partners: [Partner] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Partners")
            List {
                ForEach(partners, id: \.implementationID) { partner in
                    if let name = partner.name {
                        Text(name)
                    }
                }
            }
        }
        .onAppear() {
            PartnerService().listPartners(completion: { partners in
                self.partners = partners
            })
        }
    }
}

struct PartnersView_Previews: PreviewProvider {
    static var previews: some View {
        PartnersView()
    }
}
