//
//  ActionPresenter.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers
import UIKit

protocol ActionPresenter: AnyObject {
    func action(withContext context: NSExtensionContext?)
    func inputText(_ text: String)
    func inputQuote(_ text: String)
    func inputPage(_ text: String)
    func save()
    func cancel()
    func openApp()
}

final class ActionPresenterImpl: ActionPresenter {
    // TODO: Should replace with repository
    private let dataSource: UserDefaultsDataSource

    private var text: String = "" {
        didSet {
            onChange()
        }
    }
    private var quote: String = "" {
        didSet {
            onChange()
        }
    }
    private var page: String = ""

    private weak var view: ActionView!
    
    init(withView view: ActionView,
         dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()) {
        self.view = view
        self.dataSource = dataSource
    }
    
    func action(withContext context: NSExtensionContext?) {
        // Initialize view
        view.setSaveButtonEnabled(false)
        view.showDescription()

        // Check if the reading book has been already set
        guard let book = dataSource.readingBook else {
            return
        }
        
        // Show book information
        let placeholderImage = UIImage(systemName: "book")!
        view.showBook(title: book.title, image: placeholderImage)
        if let url = book.imageURL {
           URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, _ in
               guard let data = data,
                     let image = UIImage(data: data) else { return }
               DispatchQueue.main.async { [weak self] in
                   self?.view.showBook(title: book.title, image: image)
               }
           }).resume()
        }
        
        guard let items = context?.inputItems as? [NSExtensionItem] else { return }
        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                guard provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) else { continue }
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { [weak self] text, _ in
                    guard let self = self else { return }
                    self.view.showInput()
                    self.quote = text as? String ?? ""
                    self.view.setQuote(self.quote)
                }
            }
        }
    }
    
    func inputText(_ text: String) {
        self.text = text
    }
    
    func inputQuote(_ text: String) {
        self.quote = text
    }
    
    func inputPage(_ text: String) {
        self.page = text
    }
    
    func save() {
        guard let book = dataSource.readingBook else {
            view.close()
            return
        }

        let draft = MemoDraft(bookId: book.id,
                              text: text.trimmingCharacters(in: .whitespaces),
                              quote: quote.trimmingCharacters(in: .whitespaces),
                              page: Int(page))
        dataSource.readingBookMemoDraft = draft
        
        view.close()
        view.openApp()
    }
    
    func cancel() {
        view.close()
    }
    
    func openApp() {
        view.openApp()
    }
}

private extension ActionPresenterImpl {
    func onChange() {
        if !text.isEmpty || !quote.isEmpty {
            view.setSaveButtonEnabled(true)
        } else {
            view.setSaveButtonEnabled(false)
        }
    }
}
