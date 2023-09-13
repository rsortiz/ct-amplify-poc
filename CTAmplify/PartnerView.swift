//
//  PartnerView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 12/09/2023.
//

import SwiftUI
import Combine

struct PartnerView: View {
    
    @State var implementationID: String
    @State var partner: Partner?
    @State var dict: [String: String] = [:]
    
    var body: some View {
        VStack(spacing: 16) {
            if let partner = self.partner {
                VStack(spacing: 16) {
                    List {
                        ForEach(Array(dict.keys), id: \.self) { key in
                            Section(header: Text(key)) {
                                Text(dict[key] ?? "")
                            }
                        }
                    }
                }
                .navigationBarTitle(partner.name ?? "", displayMode: .inline)
            }
        }
        .onAppear() {
            PartnerService().getPartner(implementationID: implementationID) { partner in
                self.partner = partner
                if let partner = partner {
                    self.dict = partner.allPropertiesString()
                }
            }
        }
    }
}

struct PartnerView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerView(implementationID: "11111111")
    }
}
