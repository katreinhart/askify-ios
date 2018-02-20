//
//  inputAnswerTVCell.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/20/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import UIKit

protocol UpdateAnswerDelegate: class {
    func didPressCancelButton(_ sender: inputAnswerTVCell) -> Void
    func didPressSubmitButton(_ sender: inputAnswerTVCell, answer: String) -> Void
}

class inputAnswerTVCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var answerInput: UITextView!
    
    weak var delegate: UpdateAnswerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        answerInput.text = ANSWER_PLACEHOLDER
        answerInput.delegate = self
    }
    
    // Text View Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == ANSWER_PLACEHOLDER {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = ANSWER_PLACEHOLDER
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.didPressCancelButton(self)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if answerInput.text == ANSWER_PLACEHOLDER { return }
        delegate?.didPressSubmitButton(self, answer: answerInput.text)
    }
}
