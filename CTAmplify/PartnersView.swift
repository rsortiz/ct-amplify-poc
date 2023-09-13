//
//  PartnersView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 11/09/2023.
//

import SwiftUI
import Combine

struct PartnersView: View {
    
    enum FocusField: Hashable {
        case field
    }
    
    @State var partners: [Partner] = []
    @State var partner: Partner?
    @State private var showingPartner = false
   
    @State var implementationID: String = ""
    @State var showingAlert = false
    
    @State var alertTitle = ""
    @State var alertText = ""
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(partners, id: \.implementationID) { partner in
                    NavigationLink(destination: PartnerView(implementationID: partner.implementationID)) {
                        if let name = partner.name {
                            Text(name)
                        } else {
                            Text(partner.implementationID)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Partners", displayMode: .inline)
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
