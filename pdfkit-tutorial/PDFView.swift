//
//  PDFView.swift
//  pdfkit-tutorial
//
//  Created by Alex Modroño Vara on 31/8/22.
//

import Foundation
import PDFKit
import SwiftUI

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

extension PDFView {
    class ViewModel: ObservableObject {
        
        // MARK: – ENUMS
        enum State {
            case loading
            case success(document: PDFDocument)
            case failure(error: String)
        }

        // MARK: – PUBLISHED VARIABLES
        @Published var state: State = .loading
        
        // MARK: – INITIALIZERS
        init(url: URL?) {
            load(url: url)
        }
        
        // MARK: - METHODS
        func load(url: URL?) {
            guard let url = url else {
                return self.state = .failure(
                    error: "The provided URL is not valid."
                )
            }

            guard let doc = PDFDocument(url: url) else {
                return self.state = .failure(
                    error: "The document returned nil."
                )
            }
            
            self.state = .success(document: doc)
        }
    }
}

struct PDFView: View {
    // MARK: – VIEW MODEL
    @ObservedObject var viewModel: ViewModel
    
    // MARK: – INITIALIZERS
    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: – BODY
    var body: some View {
        VStack {
            switch viewModel.state {
            case .failure(let error): Text(error).foregroundColor(.red)
            case .success(let document): PDFViewRepresentable(document: document)
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}
