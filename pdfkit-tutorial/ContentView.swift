//
//  ContentView.swift
//  pdfkit-tutorial
//
//  Created by Alex Modroño Vara on 30/8/22.
//

import SwiftUI
import PDFKit

struct PDFViewRepresentable: UIViewRepresentable {

    // MARK: – TYPE ALIASES
    typealias UIViewType = PDFKit.PDFView
    
    // MARK: – STORED PROPERTIES
    let document: PDFDocument
    
    // MARK: – INITIALIZERS
    public init(document: PDFDocument) {
        self.document = document
    }

    // MARK: – METHODS
    func makeUIView(
        context: Self.Context
    ) -> Self.UIViewType {

        // Create a `PDFView` and set its `PDFDocument`.
        let view = PDFKit.PDFView()
        view.document = document
        view.autoScales = true

        return view
    }

    func updateUIView(
        _ uiView: Self.UIViewType,
        context: Self.Context
    ) {
        // Not used but we still need to implement it to conform to protocol.
    }
}

struct PDFView: View {
    // MARK: – ENUMS
    enum PDFError: Error, CustomStringConvertible {
        case invalidUrl, documentReturnedNil
        
        public var description: String {
            switch self {
            case .invalidUrl:
                return "The provided URL is not valid."
            case .documentReturnedNil:
                return "PDFDocument initializer returned nil."
            }
        }
    }
    
    // MARK: – STORED PROPERTIES
    let url: URL?
    
    // MARK: – COMPUTED PROPERTIES
    var document: PDFDocument {
        get throws {

            guard let url = url else {
                throw PDFError.invalidUrl
            }

            guard let doc = PDFDocument(url: url) else {
                throw PDFError.documentReturnedNil
            }

            return doc
        }
    }
    
    // MARK: – INITIALIZERS
    init(for url: URL?) {
        self.url = url
    }
    
    // MARK: – BODY
    var body: some View {
        load()
    }
    
    func load() -> AnyView {
        do {
            return AnyView(
                PDFViewRepresentable(
                    document: try document
                )
            )
        } catch let error as PDFError {
            return AnyView(
                Text("\(error.description)")
                    .foregroundColor(.red)
            )
        } catch {
            return AnyView(
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            )
        }
    }
}

struct ContentView: View {
    var body: some View {
        PDFView(
            for: Bundle.main.url(
                forResource: "sat-practice-test-1",
                withExtension: "pdf"
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
