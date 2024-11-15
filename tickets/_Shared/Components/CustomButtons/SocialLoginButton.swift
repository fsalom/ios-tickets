//
//  SocialLoginButton.swift
//  Gula
//
//  Created by Axel Pérez Gaspar on 27/8/24.
//

import SwiftUI

enum SocialButtonType {
    case apple, google
    
    var text: LocalizedStringKey {
        switch self {
        case .apple:
            "continueWithApple"
        case .google:
            "continueWithGoogle"
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .apple:
                .white
        case .google:
                .black.opacity(0.5)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .apple:
                .black
        case .google:
                .white
        }
    }
}

struct SocialLoginButton: View {
    let buttonType: SocialButtonType
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                if buttonType == .apple {
                    Image(systemName: "applelogo")
                        .imageScale(.large)
                } else {
                    Image("googleLogo")
                }
                Spacer()
                Text(buttonType.text)
                    .font(.system(size: 16))
                Spacer()
            }
        })
        .padding()
        .foregroundColor(buttonType.foregroundColor)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(buttonType.backgroundColor)
                .stroke(.black, lineWidth: 1)
        )
    }
}
