//
//  FavoriteGenreBoxSUI.swift
//  Movarium
//
//  Created by Anton Solovev on 20.10.2024.
//

import SwiftUI

struct FavoriteGenreBoxSUI: View {
    var genre: String
    var action: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Color(.darkFaded)
            .cornerRadius(8)

            HStack {
                Text(genre)
                    .font(.custom("Manrope-Medium", size: 16))
                    .foregroundColor(.textDefault)

                Spacer()
                
                Button(action: {
                    action()
                }) {
                    Image(uiImage: UIImage(named: "unlike_genre")!)
                        .padding(8)
                        .background(Color.dark)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
}
