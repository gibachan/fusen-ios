//
//  ActionViewController.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/14.
//

import UIKit

class ActionViewController: UIViewController {
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    private var presenter: ActionPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ActionPresenterImpl(withView: self)
        presenter.action(withContext: extensionContext)
    }

    @IBAction private func cancel() {
        presenter.cancel()
    }
    
    @IBAction private func save() {
        presenter.save()
    }
}

extension ActionViewController: ActionView {
    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }
    
    func close() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
