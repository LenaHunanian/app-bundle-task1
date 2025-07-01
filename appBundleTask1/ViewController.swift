//
//  ViewController.swift
//  appBundleTask1
//
//  Created by Lena Hunanian on 01.07.25.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - UI components
    private let inputLabel = UILabel()
    private let inputTextView = UITextView()
    private let outputLabel = UILabel()
    private let outputTextView = UITextView()
    private let buttonsStackView = UIStackView()
    private let saveButton = UIButton()
    private let loadButton = UIButton()
    private let clearButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupTextViews()
        setupButtons()
        setupButtonsStackView()
        setupConstraints()
    }
    
    //MARK: - setting up methods
    
    //labels
    private func setupLabels() {
        inputLabel.text = "Input field"
        outputLabel.text = "Output field"
        [inputLabel, outputLabel].forEach {
            $0.font = .systemFont(ofSize: 21)
            $0.numberOfLines = 0
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(inputLabel)
        view.addSubview(outputLabel)
    }
    
    //text views
    private func setupTextViews() {
        [inputTextView, outputTextView].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = true
            view.addSubview( $0 )
        }
    }
    
    //buttons
    private func setupButtons() {
        saveButton.setTitle( "Save text", for: .normal )
        loadButton.setTitle( "Load text", for: .normal )
        clearButton.setTitle( "Clear text", for: .normal )
        
        saveButton.addTarget(self, action: #selector(saveTextToDocuments), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadTextFromDocuments), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTextFromDocuments), for: .touchUpInside)
        
        [saveButton, loadButton, clearButton].forEach {
            $0.setTitleColor( .white, for: .normal )
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 10
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }
    }
    
    //buttons stack view
    private func setupButtonsStackView() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview( buttonsStackView )
        
        buttonsStackView.addArrangedSubview(saveButton)
        buttonsStackView.addArrangedSubview(loadButton)
        buttonsStackView.addArrangedSubview(clearButton)
    }
    
    //constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //input label
            inputLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            inputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            inputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            //input text view
            inputTextView.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 10),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            inputTextView.heightAnchor.constraint(equalToConstant: 170),
            
            //output label
            outputLabel.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            //output text view
            outputTextView.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 10),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            outputTextView.heightAnchor.constraint(equalToConstant: 170),
            
            //buttons stack
            buttonsStackView.topAnchor.constraint(equalTo: outputTextView.bottomAnchor, constant: 15),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -350),
        ])
    }
    //MARK: - File management
    // file url
    private var textFileURL: URL {
        let fileName = "text.txt"
        let documets = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documets.appendingPathComponent(fileName)
    }
    
    //save file to Documents directory
    @objc private func saveTextToDocuments() {
        guard let inputText = inputTextView.text, !inputText.isEmpty else { return }
        let textToSave = inputText + "\n"
        guard let data = textToSave.data(using: .utf8) else { return }
        
        if FileManager.default.fileExists(atPath: textFileURL.path) {
            do {
                let fileHandler = try FileHandle(forWritingTo: textFileURL)
                fileHandler.seekToEndOfFile()
                try fileHandler.write(contentsOf: data)
                try fileHandler.close()
                print("File saved to: \(textFileURL.path)")
            }catch {
                print("Failed appending text to file: \(error)")
            }
        }else {
            do {
                try data.write(to: textFileURL)
            }catch {
                print("Failed creating file: \(error)")
            }
        }
        inputTextView.text = ""
        inputTextView.resignFirstResponder()
    }
    
    //load file from Documents directory
    @objc private func loadTextFromDocuments() {
        do {
            let savedData = try Data(contentsOf: textFileURL)
            if let savedText = String(data: savedData, encoding: .utf8) {
                outputTextView.text = savedText
            }
        }catch {
            print("Error loading file: \(error)")
        }
    }
    
    //clear files from Documents directory (optional method, not in the requirements)
    @objc private func clearTextFromDocuments() {
        outputTextView.text = ""
        if FileManager.default.fileExists(atPath: textFileURL.path) {
            do {
                try FileManager.default.removeItem(at: textFileURL)
            }catch {
                print("Failed removing file: \(error)")
            }
        }else {
            print("No file found at \(textFileURL.path)")
        }
    }
}
