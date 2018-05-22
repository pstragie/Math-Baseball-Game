//
//  ViewController.swift
//  Math Baseball Game
//
//  Created by Pieter Stragier on 19/05/2018.
//  Copyright © 2018 Pieter Stragier. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    // MARK: - Variables and Constants
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["+", "-", "x", ":"]
    let localdata = UserDefaults.standard
    var iapProducts = [SKProduct]()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var parentalGate = UIView()
    var parentalCheck: Bool = false
    let answerField = UITextField()
    var selectedMaths: Array<String> = []
    
    // MARK: - Outlets
    @IBOutlet var myButtons: [UIButton]!
    
    @IBOutlet weak var ageLabelAway: UILabel!
    @IBOutlet weak var ageLabelHome: UILabel!
    @IBOutlet weak var totalInnings: UISlider!
    @IBOutlet weak var startingOuts: UISlider!
    @IBOutlet weak var startingStrikes: UISlider!
    @IBOutlet weak var startingBalls: UISlider!
    @IBOutlet weak var awayPlayerAge: UISlider!
    @IBOutlet weak var awayPlayerName: UITextField!
    @IBOutlet weak var homePlayerAge: UISlider!
    @IBOutlet weak var homePlayerName: UITextField!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    
    @IBOutlet weak var startingBallsLabel: UILabel!
    @IBOutlet weak var startingStrikesLabel: UILabel!
    @IBOutlet weak var startingOutsLabel: UILabel!
    @IBOutlet weak var totalInningsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var gamePlayView: UIView!
    
    
    
    @IBOutlet weak var unlockButton: UIButton!
    
    @IBAction func homePlayerAgeSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        ageLabelHome.text = String(Int(homePlayerAge.value))
    }
    @IBAction func awayPlayerAgeSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        ageLabelAway.text = String(Int(awayPlayerAge.value))
    }
    @IBAction func startingBallsSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        startingBallsLabel.text = String(Int(startingBalls.value))
    }
    @IBAction func startingStrikesSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)

        startingStrikesLabel.text = String(Int(startingStrikes.value))
    }
    @IBAction func startingOutsSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)

        startingOutsLabel.text = String(Int(startingOuts.value))
    }
    @IBAction func totalInningsSliderChanged(_ sender: UISlider) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        totalInningsLabel.text = String(Int(totalInnings.value))
    }
    
    @IBAction func restorePurchaseTapped(_ sender: UIButton) {
        restorePurchaseButton.setTitleColor(.red, for: .highlighted)
        activityIndicatorShow(NSLocalizedString("restoring purchase...", comment: ""))
        restorePurchaseButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        MathBaseballGameFull.store.restorePurchases()
        self.setupLayout()
        self.viewWillLayoutSubviews()
    }
    
    @IBAction func unlockTapped(_ sender: UIButton) {
        unlockButton.setTitleColor(.red, for: .highlighted)
        activityIndicatorShow(NSLocalizedString("contacting AppStore...", comment: ""))
        unlockButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.enableButton), userInfo: nil, repeats: false)
        setupParentalGateView(option: "buy")
        //parentalGate window will continue to passParentalControlAndBuy
        parentalGate.isHidden = false
        self.setupLayout()
        self.viewWillLayoutSubviews()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let orientationvalue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationvalue, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view, typically from a nib.
        MathBaseballGameFull.store.requestProducts{success, products in
            if success {
                self.iapProducts = products!
                self.viewWillLayoutSubviews()
            }
        }
        awayPlayerName.delegate = self
        homePlayerName.delegate = self
        collectionView.allowsMultipleSelection = true
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if unlockButton.isHidden == true {
            restorePurchaseButton.isHidden = false
        } else {
            restorePurchaseButton.isHidden = true
        }
    }
    
    // MARK: - SetupLayout()
    func setupLayout() {
        for button in myButtons {
            button.layer.borderColor = UIColor.FlatColor.Blue.Denim.cgColor
            button.layer.borderWidth = 2
            button.backgroundColor = UIColor.FlatColor.Blue.BlueWhale
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10
            button.tintColor = UIColor.FlatColor.Gray.AlmondFrost
            button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        }
        ageLabelAway.text = String(Int(awayPlayerAge.value))
        ageLabelHome.text = String(Int(homePlayerAge.value))
        startingBallsLabel.text = String(Int(startingBalls.value))
        startingStrikesLabel.text = String(Int(startingStrikes.value))
        startingOutsLabel.text = String(Int(startingOuts.value))
        totalInningsLabel.text = String(Int(totalInnings.value))
        
        gamePlayView.backgroundColor = UIColor.FlatColor.Gray.Iron
        gamePlayView.layer.borderWidth = 2
        gamePlayView.layer.borderColor = UIColor.FlatColor.Gray.IronGray.cgColor
        gamePlayView.layer.cornerRadius = 10
        gamePlayView.layer.masksToBounds = true
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "1P Mode":
            let destination = segue.destination as! GameViewController
            destination.playerMode = 1
            destination.startingBalls = Int(startingBalls.value)
            destination.startingStrikes = Int(startingStrikes.value)
            destination.startingOuts = Int(startingOuts.value)
            destination.totalInnings = Int(totalInnings.value)
            if awayPlayerName.text == "" {
                awayPlayerName.text = "Oudenaarde Frogs"
            }
            if homePlayerName.text == "" {
                homePlayerName.text = "Ronse Wolverines"
            }
            destination.awayPlayerName = awayPlayerName.text!
            destination.homePlayerName = homePlayerName.text!
            destination.player1Age = Int(ageLabelAway.text!)!
            destination.player2Age = Int(ageLabelHome.text!)!
            destination.selectedMaths = selectedMaths
        default:
            let destination = segue.destination as! GameViewController
            destination.playerMode = 2
            destination.startingBalls = Int(startingBalls.value)
            destination.startingStrikes = Int(startingStrikes.value)
            destination.startingOuts = Int(startingOuts.value)
            destination.totalInnings = Int(totalInnings.value)
            if awayPlayerName.text == "" {
                awayPlayerName.text = "Oudenaarde Frogs"
            }
            if homePlayerName.text == "" {
                homePlayerName.text = "Ronse Wolverines"
            }
            destination.awayPlayerName = awayPlayerName.text!
            destination.homePlayerName = homePlayerName.text!
            destination.player1Age = Int(ageLabelAway.text!)!
            destination.player2Age = Int(ageLabelHome.text!)!
            destination.selectedMaths = selectedMaths
        }
        
    }
    
    // MARK: - Unwind
    @IBAction func unwindToOverview(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Activity Indicator
    func activityIndicatorShow(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 220, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.5, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 220, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        self.view.addSubview(effectView)
    }
    
    @objc func enableButton() {
        self.unlockButton.isEnabled = true
        self.restorePurchaseButton.isEnabled = true
    }
    
    // MARK: - setup parental gate window
    func setupParentalGateView(option: String) {
        //        print("setup AppVersionView")
        self.parentalGate.isHidden = true
        self.parentalGate.translatesAutoresizingMaskIntoConstraints = false
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height
        self.parentalGate=UIView(frame:CGRect(x: (self.view.center.x)-(width/3), y: (self.view.center.y)-(height/3), width: width / 1.5, height: height / 2.5))
        
        parentalGate.backgroundColor = UIColor.orange
        parentalGate.layer.cornerRadius = 8
        parentalGate.layer.borderWidth = 1
        parentalGate.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(parentalGate)
        self.parentalGate.isHidden = true
        
        let viewTitle = UILabel()
        viewTitle.text = NSLocalizedString("Parental control", comment: "")
        viewTitle.font = UIFont.boldSystemFont(ofSize: 14)
        viewTitle.textColor = UIColor.white
        viewTitle.textAlignment = .center
        viewTitle.adjustsFontSizeToFitWidth = true
        viewTitle.minimumScaleFactor = 0.2
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let parGateText = UILabel()
        if option == "buy" {
            parGateText.text = NSLocalizedString("Grown ups only!", comment: "") + "\n" + NSLocalizedString("Answer correct to buy the full version", comment: "")
        } else {
            parGateText.text = NSLocalizedString("Grown ups only!", comment: "") + "\n" + NSLocalizedString("Answer correct to continue", comment: "")
        }
        parGateText.font = UIFont.boldSystemFont(ofSize: 16)
        parGateText.textColor = UIColor.white
        parGateText.textAlignment = .center
        parGateText.adjustsFontSizeToFitWidth = true
        parGateText.minimumScaleFactor = 0.2
        parGateText.translatesAutoresizingMaskIntoConstraints = false
        
        let parGateQuestion = UILabel()
        parGateQuestion.text = NSLocalizedString("How much is SEVENTEEN + SEVEN - THIRTEEN? (in words)", comment: "")
        parGateQuestion.font = UIFont.systemFont(ofSize: 20)
        parGateQuestion.textColor = UIColor.white
        parGateQuestion.numberOfLines = 3
        parGateQuestion.textAlignment = .center
        parGateQuestion.adjustsFontSizeToFitWidth = true
        parGateQuestion.minimumScaleFactor = 0.2
        parGateQuestion.translatesAutoresizingMaskIntoConstraints = false
        
        
        answerField.font = UIFont.systemFont(ofSize: 20)
        answerField.keyboardType = .alphabet
        answerField.tintColor = UIColor.black
        answerField.backgroundColor = UIColor.white
        answerField.textColor = UIColor.black
        answerField.textAlignment = .center
        answerField.adjustsFontSizeToFitWidth = true
        answerField.layer.cornerRadius = 8
        answerField.layer.borderWidth = 2
        answerField.layer.borderColor = UIColor.black.cgColor
        answerField.becomeFirstResponder()
        answerField.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Cancel button!
        let buttonCancel = UIButton()
        buttonCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        buttonCancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonCancel.setTitleColor(.blue, for: .normal)
        buttonCancel.setTitleColor(.red, for: .highlighted)
        buttonCancel.backgroundColor = .white
        buttonCancel.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonCancel.titleLabel?.minimumScaleFactor = 0.2
        buttonCancel.layer.cornerRadius = 8
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.gray.cgColor
        buttonCancel.showsTouchWhenHighlighted = true
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        buttonCancel.addTarget(self, action: #selector(answerCancel), for: .touchUpInside)
        
        // MARK: OK button!
        let buttonOK = UIButton()
        buttonOK.setTitle("OK", for: .normal)
        buttonOK.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        buttonOK.setTitleColor(.blue, for: .normal)
        buttonOK.setTitleColor(.red, for: .highlighted)
        buttonOK.backgroundColor = .white
        buttonOK.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonOK.titleLabel?.minimumScaleFactor = 0.2
        buttonOK.layer.cornerRadius = 8
        buttonOK.layer.borderWidth = 1
        buttonOK.layer.borderColor = UIColor.gray.cgColor
        buttonOK.showsTouchWhenHighlighted = true
        buttonOK.translatesAutoresizingMaskIntoConstraints = false
        buttonOK.addTarget(self, action: #selector(answeredOK), for: .touchUpInside)
        
        // MARK: Vertical
        
        let vertStack = UIStackView(arrangedSubviews: [parGateText, parGateQuestion, answerField, buttonCancel, buttonOK])
        
        vertStack.axis = .vertical
        vertStack.distribution = .fillProportionally
        vertStack.alignment = .fill
        vertStack.spacing = 8
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.parentalGate.addSubview(vertStack)
        
        //Stackview Layout (constraints)
        vertStack.leftAnchor.constraint(equalTo: parentalGate.leftAnchor, constant: 20).isActive = true
        vertStack.topAnchor.constraint(equalTo: parentalGate.topAnchor, constant: 15).isActive = true
        vertStack.rightAnchor.constraint(equalTo: parentalGate.rightAnchor, constant: -20).isActive = true
        vertStack.heightAnchor.constraint(equalTo: parentalGate.heightAnchor, constant: -20).isActive = true
        vertStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        vertStack.isLayoutMarginsRelativeArrangement = true
    }
    
    
    @objc func answeredOK() {
        //        print("Answer: \(answerField.text!)")
        let parAnswer = answerField.text?.trimmingCharacters(in: .whitespaces)
        if parAnswer == "Eleven" || parAnswer == "eleven" || parAnswer == "ELEVEN" {
            parentalCheck = true
            passParentalControlAndBuy()
        } else {
            answerField.resignFirstResponder()
            self.effectView.removeFromSuperview()
            parentalCheck = false
            let wrongAnswerAlert = UIAlertController(title: NSLocalizedString("Wrong answer", comment: ""), message: NSLocalizedString("The answer you provided was not correct, try again.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            wrongAnswerAlert.addAction(ok)
            present(wrongAnswerAlert, animated: true, completion: nil)
        }
        answerField.text = ""
        answerField.resignFirstResponder()
        parentalGate.isHidden = true
    }
    
    @objc func answerCancel() {
        self.effectView.removeFromSuperview()
        parentalGate.isHidden = true
        parentalCheck = false
        answerField.text = ""
        answerField.resignFirstResponder()
    }
    func passParentalControlAndBuy() {
        if ConnectionCheck.isConnectedToNetwork() {
            if parentalCheck == true {
                //            print("parental gate passed")
                if IAPHelper.canMakePayments() {
                    //                print("Can make payments")
                    MathBaseballGameFull.store.buyProduct(iapProducts[0])
                    self.setupLayout()
                    self.viewWillLayoutSubviews()
                } else {
                    // MARK: in-app-purchase fail message
                    let failController = UIAlertController(title: NSLocalizedString("In-app purchases not enabled", comment: ""), message: NSLocalizedString("Please enable in-app purchase in settings", comment: ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { alertAction in
                    }
                    let settings = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { alertAction in
                        failController.dismiss(animated: true, completion: nil)
                        let url: URL? = URL(string: UIApplicationOpenSettingsURLString)
                        //let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                        if url != nil {
                            if UIApplication.shared.canOpenURL(url!) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url!)
                                }
                            }
                        }
                    })
                    failController.addAction(ok)
                    failController.addAction(settings)
                    present(failController, animated: true, completion: nil)
                }
                parentalCheck = false
            }
            self.setupLayout()
            self.viewWillLayoutSubviews()
        } else {
            self.answerField.resignFirstResponder()
            let alertcontroller = UIAlertController(title: NSLocalizedString("You need a working internet connection", comment: ""), message: NSLocalizedString("Check your connection settings and try again.", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertcontroller.addAction(ok)
            present(alertcontroller, animated: true, completion: nil)
            self.effectView.removeFromSuperview()
        }
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MathCollectionViewCell
        // use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.FlatColor.Gray.IronGray.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.FlatColor.Violet.Wisteria
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.FlatColor.Violet.BlueGem.cgColor
        print("You selected cell #\(indexPath.item)!")
        selectedMaths.append(items[indexPath.item])
        print("selected maths = \(selectedMaths)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // handle deselect events
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.FlatColor.Gray.IronGray.cgColor
        print("You deselected cell #\(indexPath.item)!")
        if let indexInSelected = selectedMaths.index(of: items[indexPath.item]) {
            selectedMaths.remove(at: indexInSelected)
        }
        print("selected maths = \(selectedMaths)")
    }
    
    
    // MARK: - Textfield Delegate
    // MARK: allowed characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.alphanumerics
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    // MARK: textfield becomes active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        print("textFieldShouldBeginEditing")
        textField.isUserInteractionEnabled = true
        textField.isEnabled = true
        return true
    }
    
    // MARK: keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if awayPlayerName.isFirstResponder {
            homePlayerName.becomeFirstResponder()
        } else if homePlayerName.isFirstResponder {
            awayPlayerName.becomeFirstResponder()
        }
        return true
    }
}


