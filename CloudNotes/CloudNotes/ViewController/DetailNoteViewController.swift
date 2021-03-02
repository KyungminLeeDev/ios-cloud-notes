//
//  DetailNoteViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/18.
//

import UIKit
import CoreData

class DetailNoteViewController: UIViewController {
    static let memoDidSave = Notification.Name(rawValue: "memoDidSave")
    
    var fetchedNote: NSManagedObject?
    private let detailNoteTextView = UITextView()
    private let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
    private let moreButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(touchUpCompleteButton))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureTextView()
        setTextViewFromFetchedNote()
    }
    
    private func configureTextView() {
        addTapGestureRecognizerToTextView()
        detailNoteTextView.delegate = self
        if let _ = fetchedNote {
            detailNoteTextView.isEditable = false
        } else {
            detailNoteTextView.isEditable = true
            detailNoteTextView.becomeFirstResponder()
        }
        detailNoteTextView.dataDetectorTypes = .all
        detailNoteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailNoteTextView)
        detailNoteTextView.font = .preferredFont(forTextStyle: .body)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailNoteTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailNoteTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            detailNoteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailNoteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setTextViewFromFetchedNote() {
        guard let noteData = fetchedNote else {
            return
        }
        let title: String = noteData.value(forKey: "title") as! String
        let body: String = noteData.value(forKey: "body") as! String
        detailNoteTextView.text = "\(title)\n\(body)"
    }
    
    @objc private func touchUpCompleteButton() {
        detailNoteTextView.isEditable = false
        saveNote()
        if let _ = navigationController?.presentingViewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func touchUpMoreButton() {
        // 다음 스텝에서 구현
    }
    
    private func addTapGestureRecognizerToTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTextViewEditableState))
        detailNoteTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func changeTextViewEditableState() {
        detailNoteTextView.isEditable.toggle()
        if detailNoteTextView.isEditable {
            detailNoteTextView.becomeFirstResponder()
        } else {
            saveNote()
        }
    }
    
    private func saveNote() {
        if detailNoteTextView.text == UIConstants.strings.textInitalizing {
            CoreDataManager.shared.saveMemo(title: UIConstants.strings.emptyNoteTitleText, body: UIConstants.strings.textInitalizing)
        } else {
            let textViewText = detailNoteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            checkTextView(text: textViewText)
        }

        if let fetchedNote = self.fetchedNote {
            let title: String = fetchedNote.value(forKey: "title") as! String
            let body: String = fetchedNote.value(forKey: "body") as! String
            CoreDataManager.shared.updateMemo(object: fetchedNote, title: title, body: body)
        } else {
            // 이 경우에 대해서 좀 더 생각해보기!
//            CoreDataManager.shared.saveMemo(title: <#T##String#>, body: <#T##String#>)
//            self.fetchedNote = note
        }
        
        NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
    }
    
    private func checkTextView(text: [String.SubSequence]) {
        //저장하는 역할까지 하고있음 개선필요
        if text.count == 1 {
            let titleText = String(text[0])
            CoreDataManager.shared.saveMemo(title: titleText, body: UIConstants.strings.textInitalizing)
//            return Memo(context: <#T##NSManagedObjectContext#>)
        } else {
            let titleText = String(text[0])
            let bodyText = String(text[1])
            CoreDataManager.shared.saveMemo(title: titleText, body: bodyText)
//            return
        }
    }
}

extension DetailNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.setRightBarButton(completeButton, animated: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.setRightBarButton(moreButton, animated: false)
    }
}
