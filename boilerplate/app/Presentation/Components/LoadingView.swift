//
//  LoadingView.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI


struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2)
        }
    }
}
