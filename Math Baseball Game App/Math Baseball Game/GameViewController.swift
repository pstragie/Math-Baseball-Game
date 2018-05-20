//
//  GameViewController.swift
//  Math Baseball Game
//
//  Created by Pieter Stragier on 19/05/2018.
//  Copyright © 2018 Pieter Stragier. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Var & Let
    var playerMode: Int?
    var player1Age: Int = 4
    var player2Age: Int = 20
    
    var inning: Int = 0
    var top: Bool = true
    var progress: Int = -1
    var action: String = "pitching"
    var outs: Int = 0
    var balls: Int = 0
    var strikes: Int = 0
    var strike: Bool = false
    var timer = Timer()
    var honderdsten: Double = 0
    var runs: Int = 0
    var totalruns: Int = 0
    var hits: Int = 0
    var errors: Int = 0
    var offensiveTime: Double = 0.0
    var defensiveTime: Double = 0.0
    var oTimeHandicapTime: Double = 0.0
    var dTimeHandicapTime: Double = 0.0
    var player1Handicap: Double = 0.0
    var player2Handicap: Double = 0.0
    
    var runnersPositions: Dictionary<String, Bool> = ["1": false, "2": false, "3": false]
    var runnersPosAlgo: Int = 0
    var runningSuccessful: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var myButtons: [UIButton]!
    @IBOutlet var keypadButtons: [UIButton]!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var mathQuestionView: UIView!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var mathLabel1: UILabel!
    @IBOutlet weak var mathEquationLabel: UILabel!
    @IBOutlet weak var mathLabel2: UILabel!
    @IBOutlet weak var actionMessage: UILabel!
    @IBOutlet weak var top1: UILabel!
    @IBOutlet weak var bottom1: UILabel!
    @IBOutlet weak var top2: UILabel!
    @IBOutlet weak var bottom2: UILabel!
    @IBOutlet weak var top3: UILabel!
    @IBOutlet weak var bottom3: UILabel!
    @IBOutlet weak var top4: UILabel!
    @IBOutlet weak var bottom4: UILabel!
    @IBOutlet weak var top5: UILabel!
    @IBOutlet weak var bottom5: UILabel!
    @IBOutlet weak var top6: UILabel!
    @IBOutlet weak var bottom6: UILabel!
    @IBOutlet weak var top7: UILabel!
    @IBOutlet weak var bottom7: UILabel!
    @IBOutlet weak var top8: UILabel!
    @IBOutlet weak var bottom8: UILabel!
    @IBOutlet weak var top9: UILabel!
    @IBOutlet weak var bottom9: UILabel!
    @IBOutlet weak var topRuns: UILabel!
    @IBOutlet weak var bottomRuns: UILabel!
    @IBOutlet weak var topHits: UILabel!
    @IBOutlet weak var bottomHits: UILabel!
    @IBOutlet weak var topErrors: UILabel!
    @IBOutlet weak var bottomErrors: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var basesImage: UIImageView!
    @IBOutlet weak var ball1: UILabel!
    @IBOutlet weak var ball2: UILabel!
    @IBOutlet weak var ball3: UILabel!
    @IBOutlet weak var strike1: UILabel!
    @IBOutlet weak var strike2: UILabel!
    @IBOutlet weak var out1: UILabel!
    @IBOutlet weak var out2: UILabel!
    @IBOutlet var bsoLabels: [UILabel]!
    
    
    // MARK: - Actions
    @IBAction func keypadEraseButtonTapped(_ sender: UIButton) {
        var currentText: String = answerField.text!
        currentText.remove(at: currentText.index(before: currentText.endIndex))
        answerField.text = currentText
    }
    
    @IBAction func keypadDoneButtonTapped(_ sender: UIButton) {
        invalidateTimer()
        if action == "batting" || action == "defense" {
            defensiveTime = checkTime()
            print("defensive time = \(defensiveTime)")
        } else {
            offensiveTime = checkTime()
            print("offensive time = \(offensiveTime)")
        }
        if top {
            oTimeHandicapTime = offensiveTime * player1Handicap
            dTimeHandicapTime = defensiveTime * player2Handicap
        } else {
            oTimeHandicapTime = offensiveTime * player2Handicap
            dTimeHandicapTime = defensiveTime * player1Handicap
        }
        print("oTimeHandicapTime = \(oTimeHandicapTime)")
        print("dTimeHandicapTime = \(dTimeHandicapTime)")
        
        resetTimer()
        self.mathQuestionView.isHidden = true
        progressView.progress = 0.0
        progressView.isHidden = true
        actionResult(success: checkResult())
    }
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        goButton.isHidden = true
        if progress == -1 || progress == 4 {
            progress = 0
            self.action = "pitching"
            self.inning = 0
            self.top = true
            self.balls = 0
            self.strikes = 0
            storyBoard()
        } else {
            resetTimer()
            if outs == 3 {
                inning += 1
                runs = 0
                balls = 0
                strikes = 0
                progress = 0
                action = "pitching"
            }
            moveOn()
            progressView.isHidden = false
            runTimer()
        }
        
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        answerField.delegate = self
        // Do any additional setup after loading the view.
        if player1Age > 16 {
            player1Age = 16
        }
        if player2Age > 16 {
            player2Age = 16
        }
        player1Handicap = Double(player1Age) / 20.0
        player2Handicap = Double(player2Age) / 20.0
        print("player 1 handicap = \(player1Handicap)")
        print("player 2 handicap = \(player2Handicap)")
        for keypad in keypadButtons {
            keypad.addTarget(self, action: #selector(keypadTouched(_:)), for: .touchUpInside)
        }
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        basesImage.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/4))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in keypadButtons {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
        }
        for label in bsoLabels {
            label.layer.cornerRadius = 0.5 * label.bounds.size.width
            label.clipsToBounds = false
            label.layer.masksToBounds = true
        }
        
        
    }
    
    // MARK: - setupLayout
    func setupLayout() {
        for button in keypadButtons {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.FlatColor.Blue.Denim.cgColor
            button.backgroundColor = UIColor.FlatColor.Blue.BlueWhale
            button.tintColor = UIColor.FlatColor.Gray.AlmondFrost
        }
        for label in bsoLabels {
            label.backgroundColor = UIColor.white
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1
        }
        mathQuestionView.isHidden = true
        mathQuestionView.layer.borderColor = UIColor.FlatColor.Red.TerraCotta.cgColor
        mathQuestionView.backgroundColor = UIColor.FlatColor.Red.Valencia
        mathQuestionView.layer.masksToBounds = true
        mathQuestionView.layer.cornerRadius = 10
        
        goButton.layer.borderWidth = 2
        goButton.layer.borderColor = UIColor.FlatColor.Green.ChateauGreen.cgColor
        goButton.layer.cornerRadius = 10
        goButton.layer.masksToBounds = true
        goButton.backgroundColor = UIColor.FlatColor.Green.Fern
        goButton.tintColor = UIColor.black
        
        if self.progress == -1 {
            messageLabel.text = "Are you ready to play ball?"
            actionMessage.text = "Tap on Go! to continue"
        }
        
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.borderWidth = 2
        messageLabel.layer.borderColor = UIColor.FlatColor.Violet.Wisteria.cgColor
        messageLabel.backgroundColor = UIColor.init(white: 0.8, alpha: 0.8)
        
        actionMessage.layer.cornerRadius = 10
        actionMessage.layer.masksToBounds = true
        actionMessage.layer.borderWidth = 2
        actionMessage.layer.borderColor = UIColor.FlatColor.Red.WellRead.cgColor
        actionMessage.backgroundColor = UIColor.init(white: 0.8, alpha: 0.8)
        
        progressView.layer.cornerRadius = 10
        progressView.layer.masksToBounds = true
        progressView.layer.borderWidth = 2
        progressView.layer.borderColor = UIColor.FlatColor.Yellow.Turbo.cgColor
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = UIColor.FlatColor.Orange.Sun
        progressView.progress = 0.0
        progressView.isHidden = true
    }
    
    // MARK: - storyboard
    func storyBoard() {
        print("storyBoard! inning: \(inning), top: \(top), progress: \(progress), action: \(action), balls: \(balls), strikes: \(strikes), outs: \(outs), runs: \(runs), hits: \(hits), errors: \(errors)")
        updateBoxScore(inning: inning, top: top)
        var defplayer: String = "Player 2"
        var offplayer: String = "Player 1"
        if top {
            offplayer = "Player 1"
            defplayer = "Player 2"
        } else {
            offplayer = "Player 2"
            defplayer = "Player 1"
        }
        if progress == 0 {
            self.messageLabel.text = "\(defplayer) ready to pitch?"
            self.action = "pitching"
            confirm()
        } else if progress == 1 {
            self.messageLabel.text = "\(offplayer) ready to bat?"
            self.action = "batting"
            confirm()
        } else if progress == 2 {
            self.messageLabel.text = "\(offplayer) how fast can you run?"
            self.action = "running"
            confirm()
        } else if progress == 3 {
            self.messageLabel.text = "\(defplayer) can you make the out?"
            self.action = "defense"
            confirm()
        }
        updateBSOlabels()
        updateBoxScore(inning: inning, top: top)
    }
    
    // MARK: - action result
    func actionResult(success: Bool) {
        //Upon success (pitching, batting, running, defense)
        print("actionResult! inning: \(inning), top: \(top), progress: \(progress), action: \(action), success: \(success), runs: \(runs), total runs: \(totalruns), hits: \(hits)")
        if action == "pitching" {
            if success {
                //strike
                print("Strike")
                strike = true
                self.actionMessage.text = "Good pitch!"
                progress = 1
                action = "batting"
                storyBoard()
            } else {
                //ball
                print("Ball")
                strike = false
                self.actionMessage.text = "Going wide"
                progress = 1
                self.action = "batting"
                storyBoard()
            }
        } else if action == "batting" {
            if strike {
                if success {
                    print("success on a strike!")
                    var outcome: String = ""
                    if oTimeHandicapTime < 1.0 {
                        outcome = "Going for the fence!"
                    } else if oTimeHandicapTime < 2.0 {
                        outcome = "Flyball deep to left field!"
                    } else if oTimeHandicapTime < 4.0 {
                        outcome = "Nice line drive into the outfield!"
                    } else if oTimeHandicapTime < 6.0 {
                        outcome = "Good hit. Hussle for the single!"
                    } else {
                        outcome = "Hmmm. You better hussle!"
                    }
                    self.actionMessage.text = "Nice swing! \(outcome)"
                    progress = 2
                    self.action = "running"
                    balls = 0
                    strikes = 0
                    storyBoard()
                
                } else {
                    strikes += 1
                    progress = 0
                    self.actionMessage.text = "Swing and a miss!"
                    action = "pitching"
                    checkStrikesAndOuts()
                    storyBoard()
                    
                }
                strike = false
            } else {
                if success {
                    print("Didn't swing at a ball")
                    self.actionMessage.text = "Great job with the check swing."
                    balls += 1
                    if balls < 4 {
                        progress = 0
                        action = "pitching"
                    } else {
                        actionMessage.text = "Base on balls!"
                        balls = 0
                        strikes = 0
                        progress = 0
                        action = "pitching"
                        progressRunners("bob")
                    }
                    storyBoard()
                } else {
                    //swing and a miss unless very very good time?
                    print("Swing and a miss at a ball")
                    actionMessage.text = "Swing and a miss!"
                    if oTimeHandicapTime < 2 {
                        if outs == 2 {
                            // dropped third strike
                            actionMessage.text = "Dropped third strike! Run!"
                            action = "running"
                            progress = 3
                            action = "defense"
                            balls = 0
                            strikes = 0
                        } else if outs < 2 {
                            if runnersPosAlgo == 1 || runnersPosAlgo == 3 || runnersPosAlgo == 5 || runnersPosAlgo == 7 {
                                //Dropped third strike not possible
                                actionMessage.text = "Batter is out!"
                                outs += 1
                                balls = 0
                                strikes = 0
                                checkStrikesAndOuts()
                            } else {
                                //Dropped third strike, 1B not occupied
                                actionMessage.text = "Dropped third strike! 1B is empty, go for it!"
                                balls = 0
                                strikes = 0
                                progress = 3
                                action = "defense"
                            }
                        }
                        storyBoard()
                    } else {
                        strikes += 1
                        progress = 0
                        self.action = "pitching"
                        storyBoard()
                    }
                }
            }
            
        } else if action == "running" {
            if success {
                //if correct continue to defense
                print("correct answer for running")
                actionMessage.text = "Hussling to first base"
                progress = 3
                runningSuccessful = true
                self.action = "defense"
                storyBoard()
            } else {
                //if wrong answer and defense correct: runner out
                print("wrong answer for running")
                actionMessage.text = "Jogging to first base"
                progress = 3
                runningSuccessful = false
                self.action = "defense"
                storyBoard()
            }
        } else if action == "defense" {
            if runningSuccessful {
                if success {
                    if dTimeHandicapTime < oTimeHandicapTime {
                        // Defense is faster, batter is out
                        print("batter runner is out")
                        actionMessage.text = "Runner is out on first!"
                        outs += 1
                        balls = 0
                        strikes = 0
                        progress = 0
                        self.action = "pitching"
                        if outs < 3 {
                            self.outs += 1
                        } else {
                            if top {
                                self.top = false
                            } else {
                                self.top = true
                                self.inning += 1
                            }
                        }
                        storyBoard()
                    } else {
                        print("defense too slow")
                        actionMessage.text = "Defense too slow. Runner safe on first!"
                        progressRunners("single")
                        updateBasesImage()
                    }
                } else {
                    // Defense too slow, runner safe on first
                    print("runner safe")
                    actionMessage.text = "Runner is safe on first!"
                    progressRunners("single")
                    updateBasesImage()
                    balls = 0
                    strikes = 0
                    progress = 0
                    hits += 1
                    self.action = "pitching"
                }
            } else {
                if success && dTimeHandicapTime < oTimeHandicapTime {
                    // Defense is faster, batter is out
                    print("batter runner is out")
                    actionMessage.text = "Runner is out on first!"
                    outs += 1
                    balls = 0
                    strikes = 0
                    progress = 0
                    self.action = "pitching"
                    if outs < 3 {
                        self.outs += 1
                    } else {
                        if top {
                            self.top = false
                        } else {
                            self.top = true
                            self.inning += 1
                        }
                    }
                    storyBoard()
                } else if !success {
                    print("reached on error")
                    actionMessage.text = "Reached first base on error."
                    progressRunners("single")
                    updateBasesImage()
                    balls = 0
                    strikes = 0
                    progress = 0
                    errors += 1
                    action = "pitching"
                    storyBoard()
                } else {
                    // foul ball
                    print("foul ball")
                    actionMessage.text = "Foul ball! Try again."
                    if strikes < 2 {
                        strikes += 1
                    }
                    progress = 0
                    self.action = "pitching"
                    storyBoard()
                }
            }
        }
        updateBoxScore(inning: inning, top: top)
        updateBSOlabels()
    }

    // MARK: - check strikes and outs
    func checkStrikesAndOuts() {
        if strikes == 3 {
            print("3 strikes, batter is out")
            self.actionMessage.text = "Strike out!"
            strikes = 0
            balls = 0
            outs += 1
            progress = 0
            action = "pitching"
        }
        if outs == 3 {
            balls = 0
            strikes = 0
            progress = 0
            
            if top {
                top = false
            } else {
                top = true
                inning += 1
            }
            runs = 0
            progress = 0
            action = "pitching"
        }
    }
    
    // MARK: - show confirm button
    func confirm() {
        goButton.isHidden = false
    }
    
    // MARK: - moveOn to math question
    func moveOn() {
        actionMessage.text = action + "..."
        // Show math
        mathQuestionView.isHidden = false
        // Fill math question
        mathLabel1.text = "5"
        mathLabel2.text = "3"
        mathEquationLabel.text = "+"
        
        answerField.becomeFirstResponder()
    }
    
    // MARK: keyboard return function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // go to next inputfield
        invalidateTimer()
        if action == "batting" || action == "defense" {
            defensiveTime = checkTime()
            
        } else {
            offensiveTime = checkTime()
        }
        if top {
            oTimeHandicapTime = offensiveTime * player1Handicap
            dTimeHandicapTime = defensiveTime * player2Handicap
        } else {
            oTimeHandicapTime = offensiveTime * player2Handicap
            dTimeHandicapTime = defensiveTime * player1Handicap
        }
        resetTimer()
        self.mathQuestionView.isHidden = true
        actionResult(success: checkResult())
        
        return true
    }
    
    // MARK: - check Result
    func checkResult() -> Bool {
        let result: Bool = answerField.text == "8"
        print("result: \(result)")
        print("progressView progress = \(progressView.progress)")
        if result {
            return true
        } else {
            return false
        }
    }
    
    
    
    // MARK: allowed characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    // MARK: - Textfield Delegate
    // MARK: textfield becomes active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        print("textFieldShouldBeginEditing")
        textField.isUserInteractionEnabled = true
        textField.isEnabled = true
        return true
    }
    
    // MARK: - progress runners on the image
    func progressRunners(_ hit: String) {
        if hit == "bob" {
            // advance only forced runners
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 1
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 3
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 7
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 7
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 7
                runs += 1
                totalruns += 1
            }
        }
        if hit == "fielderschoice" {
            // only with runners on base (force out)
            if runnersPosAlgo == 1 {
                runnersPosAlgo = 1
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 3
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 1
                if outs < 3 {
                    runs += 1
                    totalruns += 1
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 7
            }
        }
        if hit == "outonfirst" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 0
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 2
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 4
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 4
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 6
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 6
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 6
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 7
                if outs < 3 {
                    runs += 1
                    totalruns += 1
                }
            }
        }
        if hit == "single" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 1
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 3
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 5
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 1
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 5
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 3
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 5
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 7
                runs += 1
                totalruns += 1
            }
        } else if hit == "double" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 2
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 5
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 1
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 1
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 5
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 5
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 1
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 5
                runs += 2
                totalruns += 2
            }
        } else if hit == "triple" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 4
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 4
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 4
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 4
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 4
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 4
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 4
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 4
                runs += 3
                totalruns += 3
            }
        } else if hit == "homerun" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 0
                runs += 1
                totalruns += 1
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 0
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 0
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 0
                runs += 2
                totalruns += 2
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 0
                runs += 3
                totalruns += 3
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 0
                runs += 3
                totalruns += 3
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 0
                runs += 3
                totalruns += 3
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 0
                runs += 4
                totalruns += 4
            }
        }
    }
    
    // MARK: - update bases image
    func updateBasesImage() {
        if runnersPosAlgo == 0 {
            basesImage.image = #imageLiteral(resourceName: "emptyBases")
        } else if runnersPosAlgo == 1 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnFirst")
        } else if runnersPosAlgo == 2 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnSecond")
        } else if runnersPosAlgo == 4 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnThird")
        } else if runnersPosAlgo == 3 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnFirstAndSecond")
        } else if runnersPosAlgo == 5 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnFirstAndThird")
        } else if runnersPosAlgo == 6 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnSecondAndThird")
        } else if runnersPosAlgo == 7 {
            basesImage.image = #imageLiteral(resourceName: "runnerOnFirstSecondAndThird")
        }
    }
    
    // MARK: - update box score
    func updateBoxScore(inning: Int, top: Bool) {
        if inning == 1 {
            if top {
                top1.text = String(runs)
            } else {
                bottom1.text = String(runs)
            }
        } else if inning == 2 {
            if top {
                top2.text = String(runs)
            } else {
                bottom2.text = String(runs)
            }
        } else if inning == 3 {
            if top {
                top3.text = String(runs)
            } else {
                bottom3.text = String(runs)
            }
        } else if inning == 4 {
            if top {
                top4.text = String(runs)
            } else {
                bottom4.text = String(runs)
            }
        } else if inning == 5 {
            if top {
                top5.text = String(runs)
            } else {
                bottom5.text = String(runs)
            }
        } else if inning == 6 {
            if top {
                top6.text = String(runs)
            } else {
                bottom6.text = String(runs)
            }
        } else if inning == 7 {
            if top {
                top7.text = String(runs)
            } else {
                bottom7.text = String(runs)
            }
        } else if inning == 8 {
            if top {
                top8.text = String(runs)
            } else {
                bottom8.text = String(runs)
            }
        } else if inning == 9 {
            if top {
                top9.text = String(runs)
            } else {
                bottom9.text = String(runs)
            }
        } // add extra inning
        if top {
            topRuns.text = String(totalruns)
            topHits.text = String(hits)
            topErrors.text = String(errors)
        } else {
            bottomRuns.text = String(totalruns)
            bottomHits.text = String(hits)
            bottomErrors.text = String(hits)
        }
        
    }
    // MARK: - Timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1/100, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }
    
    // MARK: update timer objc
    @objc func updateTimer() {
        honderdsten += 1
        if honderdsten > 100000.0 {
            self.invalidateTimer()
        }
        var H: Double = 1.0
        if top {
            if action == "batting" || action == "running" {
                H = player1Handicap
            } else {
                H = player2Handicap
            }
        } else {
            if action == "batting" || action == "running" {
                H = player2Handicap
            } else {
                H = player1Handicap
            }
        }
        let xfactor: Float = Float(10 / H) * 10.0
        let prog: Float = Float(honderdsten) / xfactor
        progressView.setProgress(prog, animated: true)
    }
    
    // MARK: check time
    func checkTime() -> Double {
        timer.invalidate()
        return honderdsten
    }
    
    // MARK: reset timer
    func resetTimer() {
        self.honderdsten = 0.0
    }
    
    // MARK:  invalidate timer
    func invalidateTimer() {
        self.timer.invalidate()
    }
    
    // MARK: - objc keypad touched
    @objc func keypadTouched(_ button: UIButton) {
        var currentText: String = answerField.text!
        currentText = currentText + String(button.tag)
        answerField.text = currentText
    }
    
    // MARK: - update BSO labels
    func updateBSOlabels() {
        print("updating BSO: balls: \(balls), strikes: \(strikes), outs: \(outs)")
        if balls == 0 {
            ball1.backgroundColor = UIColor.white
            ball2.backgroundColor = UIColor.white
            ball3.backgroundColor = UIColor.white
        } else if balls == 1 {
            ball1.backgroundColor = UIColor.FlatColor.Green.PersianGreen
        } else if balls == 2 {
            ball1.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball2.backgroundColor = UIColor.FlatColor.Green.PersianGreen
        } else if balls == 3 {
            ball1.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball2.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball3.backgroundColor = UIColor.FlatColor.Green.PersianGreen
        }
        if strikes == 0 {
            strike1.backgroundColor = UIColor.white
            strike2.backgroundColor = UIColor.white
        } else if strikes == 1 {
            strike1.backgroundColor = UIColor.FlatColor.Red.Valencia
        } else if strikes == 2 {
            strike1.backgroundColor = UIColor.FlatColor.Red.Valencia
            strike2.backgroundColor = UIColor.FlatColor.Red.Valencia
        }
        if outs == 0 {
            out1.backgroundColor = UIColor.white
            out2.backgroundColor = UIColor.white
        } else if outs == 1 {
            out1.backgroundColor = UIColor.FlatColor.Red.Valencia
        } else if outs == 2 {
            out1.backgroundColor = UIColor.FlatColor.Red.Valencia
            out2.backgroundColor = UIColor.FlatColor.Red.Valencia
        }
        
    }
}
