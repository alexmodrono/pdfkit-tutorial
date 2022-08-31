//
//  ContentView.swift
//  pdfkit-tutorial
//
//  Created by Alex Modroño Vara on 30/8/22.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    var body: some View {
        PDFView(
            .init(
                url: Bundle.main.url(
                    forResource: "sat-practice-test-1",
                    withExtension: "pdf"
                )
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
