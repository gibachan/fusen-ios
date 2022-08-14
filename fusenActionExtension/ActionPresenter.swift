//
//  ActionPresenter.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers


protocol ActionPresenter: AnyObject {
    func action(withContext context: NSExtensionContext?)
    func save()
    func cancel()
}

final class ActionPresenterImpl: ActionPresenter {
    private weak var view: ActionView!
    
    init(withView view: ActionView) {
        self.view = view
    }
    
    func action(withContext context: NSExtensionContext?) {
        guard let items = context?.inputItems as? [NSExtensionItem] else { return }
        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                guard provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) else { continue }
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { text, _ in

                    // TODO: save text
                }
            }
        }
    }
    
    func save() {
        print("TODO: Save")
        view.close()
    }
    
    func cancel() {
        view.close()
    }
}
