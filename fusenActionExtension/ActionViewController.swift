//
//  ActionViewController.swift
//  fusenActionExtension
//
//  Created by Tatsuyuki Kobayashi on 2022/08/14.
//

import UIKit

class ActionViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var descriptionView: UIView!
    @IBOutlet private var readingBookView: UIView! {
        didSet {
            readingBookView.clipsToBounds = true
        }
    }
    @IBOutlet private var inputStackView: UIStackView!
    @IBOutlet private var memoTextView: UITextView! {
        didSet {
            memoTextView.layer.cornerRadius = 4
            memoTextView.clipsToBounds = true
            memoTextView.delegate = self
        }
    }
    @IBOutlet private var quoteTextView: UITextView! {
        didSet {
            quoteTextView.layer.cornerRadius = 4
            quoteTextView.clipsToBounds = true
            quoteTextView.delegate = self
        }
    }
    @IBOutlet private var pageTextField: UITextField! {
        didSet {
            pageTextField.layer.cornerRadius = 4
            pageTextField.clipsToBounds = true
        }
    }
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    private var presenter: ActionPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ActionPresenterImpl(withView: self)
        presenter.action(withContext: extensionContext)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        readingBookView.layer.cornerRadius = readingBookView.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextView.becomeFirstResponder()
    }
}

private extension ActionViewController {
    @IBAction private func onPageChange() {
        presenter.inputPage(pageTextField.text ?? "")
    }

    @IBAction private func onCancel() {
        presenter.cancel()
    }
    
    @IBAction private func onSave() {
        presenter.save()
    }

    @IBAction private func onOpenApp() {
        presenter.openApp()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let value = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = view.convert(value.cgRectValue, from: nil)
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentOffset = .zero
    }
}

extension ActionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case memoTextView:
            presenter.inputText(memoTextView.text)
        case quoteTextView:
            presenter.inputQuote(quoteTextView.text)
        default:
            break
        }
    }
}

extension ActionViewController: ActionView {
    func setSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }

    func showBook(title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }
    
    func showDescription() {
        descriptionView.isHidden = false
        inputStackView.isHidden = true
    }

    func showInput() {
        descriptionView.isHidden = true
        inputStackView.isHidden = false
    }
    
    func setQuote(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.quoteTextView.text = text
        }
    }

    func close() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    func openApp() {
        openUrl(url: URL(string: "fusen://memo")!)
    }
}

private extension ActionViewController {
    func openUrl(url: URL?) {
            let selector = sel_registerName("openURL:")
            var responder = self as UIResponder?
            while let r = responder, !r.responds(to: selector) {
                responder = r.next
            }
            _ = responder?.perform(selector, with: url)
        }
}
