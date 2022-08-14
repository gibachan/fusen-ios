//
//  ActionViewController.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/14.
//

import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let items = self.extensionContext?.inputItems as? [NSExtensionItem] else { return }
        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                guard provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) else { continue }
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { data, error in
                    print("attributedTitle=\(item.attributedTitle)") // null
                    print("attributedContentText=\(item.attributedContentText)") // null
                    print("data=\(data)") // コピーしたテキスト
                }
            }
            
//            if imageFound {
//                // We only handle one image, so stop looking for more.
//                break
//            }
        }
    }

    @IBAction private func done() {
        print("done")
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
