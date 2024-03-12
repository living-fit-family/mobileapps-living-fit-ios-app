//
//  QueryTag.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct QueryTag: View {
    var query: String
    var isSelected: Bool
    var body: some View {
        Text(query == "hiit" ? query.uppercased() : query.capitalized)
            .font(.caption)
            .bold()
            .foregroundStyle(isSelected ? .black : .gray)
            .padding(10)
            .background(.thinMaterial)
            .cornerRadius(8)
    }
}

struct QueryTag_Previews: PreviewProvider {
    static var previews: some View {
        QueryTag(query: "back", isSelected: false)
    }
}
