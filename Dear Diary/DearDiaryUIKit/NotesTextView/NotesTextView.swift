//
//  NotesTextView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

public protocol NotesImageDelegate: AnyObject {
    func showImagePickerScreen()
}

public class NotesTextView: UITextView{
    
    public enum TextStyle {
        case title
        case heading
        case body
        case monospaced
    }
    
    let textFieldAnimationDuration: TimeInterval = 0.3
    
    let accessaryView = UIView()
    var keyboardView: UIView? = nil
    
    // Delay timer to switch between keyboards
    var kTimer: Timer?
    
    var isSwitchingKeyboard = false
    
    let styleKeyboard = TextStyleKeyboardView()
    
    var textFormatBarButtonForiPad: UIBarButtonItem!
    
    let accessoryViewHeight: CGFloat = 50
    let styleKeyboardHeight: CGFloat = 280
    let indentWidth: CGFloat = 20
    let minimumIndent: CGFloat = 0
    let maximumIndent: CGFloat = 200
    
    struct TextState{
        let selectedRange: NSRange
        let attributedText: NSAttributedString
    }
    
    var keyboardHeight: CGFloat = 0.0
    
    override public var selectedTextRange: UITextRange?{
        didSet{
            updateVisualForKeyboard()
        }
    }
    
    public weak var hostingViewController: UIViewController?
    public weak var imageDelegate: NotesImageDelegate?
    public var shouldAdjustInsetBasedOnKeyboardHeight = false
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(with textStyle: TextStyle) {
        setupTextView(with: textStyle)
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        let isAlreadyFirstResponder = isFirstResponder
        
        let willBecomeFirstResponder = super.becomeFirstResponder()
        
        if !isAlreadyFirstResponder && willBecomeFirstResponder{
            
            if !isSwitchingKeyboard{
                
                var targetLocationForAttributes: Int = 0
                
                if selectedRange.location != NSNotFound && textStorage.length != 0{
                    
                    // selectedRange.Location is actually the length of the string so it becomes out of bounds when the selected range is actually at last character
                    if selectedRange.location == textStorage.length && selectedRange.length == 0{
                        let lastChar = text.suffix(1) as NSString
                        targetLocationForAttributes = max(0, textStorage.length - lastChar.length)
                        
                        // we don't need to update typing attributes here..
                        // it creates a problem if the last character is emoji. (emoji length is variable)
                    } else {
                        targetLocationForAttributes = selectedRange.location
                        typingAttributes = textStorage.attributes(at: targetLocationForAttributes, longestEffectiveRange: nil, in: selectedRange)
                    }
                }
                
                updateVisualForKeyboard()
                
            }
        }
        return willBecomeFirstResponder
    }
    
    override public func resignFirstResponder() -> Bool {
        let willResignFirstResponder = super.resignFirstResponder()
        
        return willResignFirstResponder
    }
    
    override public func paste(_ sender: Any?) {
        
        // Setup code in overridden UITextView.copy/paste
        let pb = UIPasteboard.general
        
        
        // pasting from external source might paste some attributes like images, fonts, colors which are not supported.
        // converting it to plain text to remove all the attributes and give it default font of body.
        
        // UTI List
        let utf8StringType = "public.utf8-plain-text"
        
        pb.items.forEach { (pbDict) in
            if let pastedString = pbDict[utf8StringType] as? String{
                
                // When pasting apply body font attributes
                let attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font : NotesFontProvider.shared.bodyFont,
                    NSAttributedString.Key.foregroundColor : Color.label.shade]
                
                let attributed = NSAttributedString(string: pastedString, attributes: attributes)
                
                // how many characters to advance?
                // string counts emojis as single character so don't use string.count
                // convert it to NSString and check its length
                
                let rawString = pastedString as NSString
                
                // Insert pasted string
                self.textStorage.insert(attributed, at:selectedRange.location)
                self.selectedRange.location += rawString.length
                self.selectedRange.length = 0
            }
        }
    }
    
    override public func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        
        
        // after the Title or Heading line,
        // next line should be body font
        
        if text == "\n"{
            if let font = typingAttributes[NSAttributedString.Key.font] as? UIFont{
                if font == NotesFontProvider.shared.headingFont || font == NotesFontProvider.shared.titleFont{
                    typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.bodyFont
                    updateVisualForKeyboard()
                }
            }
            
            if typingAttributes[NSAttributedString.Key.backgroundColor] != nil{
                typingAttributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            }
        }
        
        return true
    }
    
    func setupTextView(with textStyle: TextStyle){
        
        let typingFont = textStyle == .title ? NotesFontProvider.shared.titleFont : NotesFontProvider.shared.bodyFont
        font = typingFont
        typingAttributes[NSAttributedString.Key.font] = typingFont
        typingAttributes[NSAttributedString.Key.foregroundColor] = Color.label.shade
        alwaysBounceVertical = true
        allowsEditingTextAttributes = true
        keyboardDismissMode = .interactive
        
        setupKeyboardActions()
        
        if traitCollection.userInterfaceIdiom == .pad{
            // TODO: - Make similar as for iPhone
            let Aa_IconConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small)
            let textfomratImage = UIImage(systemName: "textformat.size", withConfiguration: Aa_IconConfig)
            textFormatBarButtonForiPad = UIBarButtonItem(image: textfomratImage, style: .plain, target: self, action: #selector(showPopOverKeyboardForiPad))
            
            let buttonGroup = UIBarButtonItemGroup(barButtonItems: [textFormatBarButtonForiPad], representativeItem: nil)
            
            inputAssistantItem.trailingBarButtonGroups = [buttonGroup]
        } else {
            prepareAccessoryView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        styleKeyboard.delegate = self
    }
    
    @objc private func textDidChange(_ notification: Notification){
        updateVisualForKeyboard()
    }
    
    private func setupKeyboardActions(){
        styleKeyboard.boldButton.addTarget(self, action: #selector(makeTextBold), for: .touchUpInside)
        styleKeyboard.italicButton.addTarget(self, action: #selector(makeTextItalics), for: .touchUpInside)
        styleKeyboard.underlineButton.addTarget(self, action: #selector(makeTextUnderline), for: .touchUpInside)
        styleKeyboard.strikethroughButton.addTarget(self, action: #selector(makeTextStrikethrough), for: .touchUpInside)
        
        styleKeyboard.leftIndentButton.addTarget(self, action: #selector(indentLeft), for: .touchUpInside)
        styleKeyboard.rightIndentButton.addTarget(self, action: #selector(indentRight), for: .touchUpInside)
        
        styleKeyboard.titleButton.tapGesture.addTarget(self, action: #selector(useTitle))
        styleKeyboard.headingButton.tapGesture.addTarget(self, action: #selector(useHeading))
        styleKeyboard.bodyButton.tapGesture.addTarget(self, action: #selector(useBody))
        styleKeyboard.monospacedButton.tapGesture.addTarget(self, action: #selector(useMonospaced))
        
        styleKeyboard.returnButton.addTarget(self, action: #selector(showDefaultKeyboard), for: .touchUpInside)
        
        styleKeyboard.leftAlignButton.addTarget(self, action: #selector(useLeftAlignment), for: .touchUpInside)
        styleKeyboard.centerAlignButton.addTarget(self, action: #selector(useCenterAlignment), for: .touchUpInside)
        styleKeyboard.rightAlignButton.addTarget(self, action: #selector(useRightAlignment), for: .touchUpInside)
    }
    
    private func prepareAccessoryView(){
        accessaryView.frame = .init(origin: .zero, size: CGSize(width: 10, height: accessoryViewHeight))
        accessaryView.backgroundColor = Color.secondaryBackground.shade
        accessaryView.accessibilityIdentifier = "accessoryView"
        inputAccessoryView = accessaryView
        
        let textFormatButton = UIButton(type: .system)
        textFormatButton.tintColor = Color.secondaryLabel.shade
        textFormatButton.titleLabel?.font = Font.title2(.regular)
        textFormatButton.setTitle(Strings.Note.textFormatting, for: .normal)
        textFormatButton.addTarget(self, action: #selector(showStyleKeyboard), for: .touchUpInside)
        
        let scribbleButton = UIButton(type: .system)
        let scribbleButtonImage = Image.scribble.asset?.resize(to: CGSize(width: 24, height: 24))?
            .withTintColor(Color.secondaryLabel.shade)
        scribbleButton.tintColor = Color.secondaryLabel.shade
        scribbleButton.setImage(scribbleButtonImage, for: .normal)
        scribbleButton.addTarget(self, action: #selector(scribble), for: .touchUpInside)
        
        let cameraButton = UIButton(type: .system)
        let cameraButtonImage = Image.camera.asset?.resize(to: CGSize(width: 24, height: 24))?
            .withTintColor(Color.secondaryLabel.shade)
        cameraButton.tintColor = Color.secondaryLabel.shade
        cameraButton.setImage(cameraButtonImage, for: .normal)
        cameraButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
                
        let lockButton = UIButton(type: .system)
        let lockButtonImage = Image.lock.asset?.resize(to: CGSize(width: 24, height: 24))?
            .withTintColor(Color.secondaryLabel.shade)
        lockButton.tintColor = Color.secondaryLabel.shade
        lockButton.setImage(lockButtonImage, for: .normal)
        lockButton.addTarget(self, action: #selector(lockNote), for: .touchUpInside)
        
        let copyButton = UIButton(type: .system)
        let copyButtonImage = Image.copy.asset?.resize(to: CGSize(width: 24, height: 24))?
            .withTintColor(Color.secondaryLabel.shade)
        copyButton.setImage(copyButtonImage, for: .normal)
        copyButton.addTarget(self, action: #selector(copyNote), for: .touchUpInside)
        
        let formatStack = UIStackView(arrangedSubviews: [textFormatButton, scribbleButton, cameraButton])
        formatStack.spacing = 20
                
        let extrasStack = UIStackView(arrangedSubviews: [copyButton, lockButton])
        extrasStack.spacing = 20
        
        accessaryView.addSubview(formatStack)
        formatStack.anchor(top: accessaryView.topAnchor, leading: accessaryView.safeAreaLayoutGuide.leadingAnchor, bottom: accessaryView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0))
        
        accessaryView.addSubview(extrasStack)
        extrasStack.anchor(top: accessaryView.topAnchor, leading: nil, bottom: accessaryView.bottomAnchor, trailing: accessaryView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
    }
    
}
