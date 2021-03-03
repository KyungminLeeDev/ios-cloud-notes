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
    
    var fetchedNote: Memo?
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
        guard let memo = fetchedNote, let title = memo.title, let body = memo.body else {
            return
        }
        
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
        }
    }
    
    private func saveNote() {
        let noteTexts: (title: String, body: String)
        noteTexts = divdeTextForNote(text: detailNoteTextView.text)
        
        if let fetchedNote = self.fetchedNote {
            if (fetchedNote.title != noteTexts.title) || (fetchedNote.body != noteTexts.body) {
                CoreDataManager.shared.update(memo: fetchedNote, title: noteTexts.title, body: noteTexts.body)
            }
        } else {
            self.fetchedNote = CoreDataManager.shared.saveMemo(title: noteTexts.title, body: noteTexts.body)
        }
        
        NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
    }
    
    private func divdeTextForNote(text: String) -> (title: String, body: String) {
        let noteTexts: (title: String, body: String)
        
        guard text != UIConstants.strings.textInitalizing else {
            noteTexts.title = UIConstants.strings.emptyNoteTitleText
            noteTexts.body = UIConstants.strings.textInitalizing
            return noteTexts
        }
        
        let splitedText = detailNoteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        if splitedText.count == 1 {
            noteTexts.title = String(splitedText[0])
            noteTexts.body = UIConstants.strings.textInitalizing
        } else {
            noteTexts.title = String(splitedText[0])
            noteTexts.body = String(splitedText[1])
        }
        
        return noteTexts
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
