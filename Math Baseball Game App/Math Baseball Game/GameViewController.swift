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
    var player1Age: Int = 8
    var player2Age: Int = 8
    var startingBalls: Int = 1
    var startingStrikes: Int = 1
    var totalInnings: Int = 9
    var startingOuts: Int = 1
    var homePlayerName: String = "Player 1"
    var awayPlayerName: String = "Player 2"
    var selectedMaths: Array<String>?
    
    var numberOfSigns: Int = 1
    var signArray: Array<Int> = []
    var inning: Int = 1
    var top: Bool = true
    var action: String = ""
    var outs: Int = 0
    var balls: Int = 0
    var strikes: Int = 0
    var strike: Bool = false
    var timer = Timer()
    var honderdsten: Double = 0
    var hit: Int = 1
    var runs: Int = 0
    var totalruns: Int = 0
    var totalRunsHome: Int = 0
    var totalRunsAway: Int = 0
    var hitsAway: Int = 0
    var errorsAway: Int = 0
    var hitsHome: Int = 0
    var errorsHome: Int = 0
    var offensiveTime: Double = 0.0
    var defensiveTime: Double = 0.0
    var oTimeHandicapTime: Double = 0.0
    var dTimeHandicapTime: Double = 0.0
    var player1Handicap: Double = 0.0
    var player2Handicap: Double = 0.0
    var runnersPosAlgo: Int = 0
    var runningSuccessful: Bool = false
    var teamInAction: Int = 2
    // MARK:  math
    var tablesDictVAway: Dictionary<Int,Array<Int>>? = [:]
    var tablesDictDAway: Dictionary<Int, Array<Int>>? = [:]
    var tablesDictVHome: Dictionary<Int,Array<Int>>? = [:]
    var tablesDictDHome: Dictionary<Int, Array<Int>>? = [:]
    var randomVermenigvuldigenAway: Array<Int> = []
    var randomVermenigvuldigenHome: Array<Int> = []
    var randomDelenAway: Array<Int> = []
    var randomDelenHome: Array<Int> = []
    var mult2: Int?
    var mult1: Int?
    var correctAnswer: String = ""
    var randomOptellenAway: Array<Int> = []
    var randomOptellenHome: Array<Int> = []
    var randomAftrekkenAway: Array<Int> = []
    var randomAftrekkenHome: Array<Int> = []
    var somTotaal: Int?
    var minTotaal: Int?
    var computer: String?
    var tijden1steInnning: Array<Double> = []
    
    // MARK: - Outlets
    @IBOutlet weak var extraMessage: UILabel!
    @IBOutlet weak var runMessage: UILabel!
    @IBOutlet weak var keypadView: UIView!
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
    @IBOutlet weak var topPlayer: UILabel!
    @IBOutlet weak var bottomPlayer: UILabel!
    @IBOutlet weak var boxInning1: UILabel!
    @IBOutlet weak var top1: UILabel!
    @IBOutlet weak var bottom1: UILabel!
    @IBOutlet weak var boxInning2: UILabel!
    @IBOutlet weak var top2: UILabel!
    @IBOutlet weak var bottom2: UILabel!
    @IBOutlet weak var boxInning3: UILabel!
    @IBOutlet weak var top3: UILabel!
    @IBOutlet weak var bottom3: UILabel!
    @IBOutlet weak var boxInning4: UILabel!
    @IBOutlet weak var top4: UILabel!
    @IBOutlet weak var bottom4: UILabel!
    @IBOutlet weak var boxInning5: UILabel!
    @IBOutlet weak var top5: UILabel!
    @IBOutlet weak var bottom5: UILabel!
    @IBOutlet weak var boxInning6: UILabel!
    @IBOutlet weak var top6: UILabel!
    @IBOutlet weak var bottom6: UILabel!
    @IBOutlet weak var boxInning7: UILabel!
    @IBOutlet weak var top7: UILabel!
    @IBOutlet weak var bottom7: UILabel!
    @IBOutlet weak var boxInning8: UILabel!
    @IBOutlet weak var top8: UILabel!
    @IBOutlet weak var bottom8: UILabel!
    @IBOutlet weak var boxInning9: UILabel!
    @IBOutlet weak var top9: UILabel!
    @IBOutlet weak var bottom9: UILabel!
    @IBOutlet var inningsLabel: [UILabel]!
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
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
//    var flashMessage: UILabel!
    
    
    // MARK: - Actions
    @IBAction func keypadEraseButtonTapped(_ sender: UIButton) {
        var currentText: String = answerField.text!
        currentText.remove(at: currentText.index(before: currentText.endIndex))
        answerField.text = currentText
    }
    
    @IBAction func keypadDoneButtonTapped(_ sender: UIButton) {
//        print("keypadDone tapped")
        invalidateTimer()
        if action == "batting" || action == "defense" {
            defensiveTime = checkTime()
//            print("defensive time = \(defensiveTime)")
        } else {
            offensiveTime = checkTime()
//            print("offensive time = \(offensiveTime)")
        }
        if top {
            oTimeHandicapTime = offensiveTime * player1Handicap
            dTimeHandicapTime = defensiveTime * player2Handicap
        } else {
            oTimeHandicapTime = offensiveTime * player2Handicap
            dTimeHandicapTime = defensiveTime * player1Handicap
        }
//        print("oTimeHandicapTime = \(oTimeHandicapTime)")
//        print("dTimeHandicapTime = \(dTimeHandicapTime)")
        if top && computer == homePlayerName {
            tijden1steInnning.append(dTimeHandicapTime)
        } else if top == false && computer == awayPlayerName {
            tijden1steInnning.append(dTimeHandicapTime)
        }
        print("tijden: \(tijden1steInnning)")
        resetTimer()
        self.mathQuestionView.isHidden = true
        progressView.progress = 0.0
        progressView.isHidden = true
        actionResult(success: checkResult())
    }
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        keypadView.isUserInteractionEnabled = true
        goButton.isUserInteractionEnabled = false
        goButton.isHidden = true
        if action == "" { // Start of the game
            action = "pitching"
            inning = 1
            top = true
            balls = startingBalls
            strikes = startingStrikes
            outs = startingOuts
            storyBoard()
        } else if action == "endgame"{  // End of the game
            performSegue(withIdentifier: "unwindToViewController", sender: goButton)
        } else if action == "change field" {
            action = "pitching"
            balls = startingBalls
            strikes = startingStrikes
            outs = startingOuts
            runnersPosAlgo = 0
            storyBoard()
        } else { // Game continues
            resetTimer()
            if outs == 3 {
                if top {
                    top = false
                } else {
                    top = true
                    inning += 1
                }
                if inning > totalInnings {
                    endGame()
                }
                runs = 0
                balls = startingBalls
                strikes = startingStrikes
                outs = startingOuts
                runnersPosAlgo = 0
                action = "change field"
            }
            if top {
                if action == "pitching" || action == "defense" {
                    teamInAction = 2
                } else {
                    teamInAction = 1
                }
            } else {
                if action == "pitching" || action == "defense" {
                    teamInAction = 1
                } else {
                    teamInAction = 2
                }
            }
            moveOn(team: teamInAction)
            progressView.progress = 0.0
            progressView.isHidden = false
            runTimer()
        }
        
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("player mode: \(String(describing: playerMode))")
        answerField.delegate = self
        // Do any additional setup after loading the view.
        if player1Age > 16 {
            player1Age = 16
        }
        if player2Age > 16 {
            player2Age = 16
        }
        player1Handicap = 1 - ((8 - Double(player1Age)) * 0.05)    // age 8: handicap = 1 (no handicap)
        player2Handicap = 1 - ((8 - Double(player2Age)) * 0.05)   // e.g. age 6: handicap = 0.90 (handicap advantage), age 10: handicap = 1.10 (handicap)
//        print("player 1 handicap = \(player1Handicap)")
//        print("player 2 handicap = \(player2Handicap)")
        
        for keypad in keypadButtons {
            keypad.addTarget(self, action: #selector(keypadTouched(_:)), for: .touchUpInside)
        }
        
        numberOfSigns = (selectedMaths?.count)!
        if numberOfSigns == 0 {
            selectedMaths = ["+", "-", "x", ":"]
            numberOfSigns = (selectedMaths?.count)!
        }
        for x in 0..<numberOfSigns {
            signArray.append(x)
        }
//        print("selectedMaths = \(String(describing: selectedMaths))")
        for s in selectedMaths! {
            prepareNumbers(sign: s)
        }
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        basesImage.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi/4))
        answerField.resignFirstResponder()
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
    // MARK: - prepare numbers
    func prepareNumbers(sign: String) {
        if sign == "x" {
            // Fill tablesArray from selected rows
            randomVermenigvuldigenAway = shuffleArray(array: vermenigvuldigen(playerAge: player1Age))
            randomVermenigvuldigenHome = shuffleArray(array: vermenigvuldigen(playerAge: player2Age))
            
            // Shuffle multipliers and add to tableDictV
            for x in 0..<randomVermenigvuldigenAway.count {
                self.tablesDictVAway?[randomVermenigvuldigenAway[x]] = randomVermenigvuldigenAway
            }
            for x in 0..<randomVermenigvuldigenHome.count {
                tablesDictVHome?[randomVermenigvuldigenHome[x]] = randomVermenigvuldigenHome
            }
        } else if sign == ":" {
            randomDelenAway = shuffleArray(array: vermenigvuldigen(playerAge: player1Age))
            randomDelenHome = shuffleArray(array: vermenigvuldigen(playerAge: player2Age))
            let numberArrayAway = vermenigvuldigen(playerAge: player1Age)
            // away
            for x in randomDelenAway {
                if x != 0 {
                    for y in numberArrayAway {
                        
                        if ((self.tablesDictDAway?[x]) != nil) {
                            var arr: Array<Int> = (self.tablesDictDAway?[x])!
                            arr.append(x * y)
                            self.tablesDictDAway?[x] = arr
                        } else {
                            let mult = [x * y]
                            self.tablesDictDAway?[x] = mult
                        }
                        
                    }
                }
            }
            // Shuffle dividing numbers and add to tableDictD
            /*
            for x in 0..<randomDelenAway.count {
                print("tablesDictDAway: \(String(describing: tablesDictDAway))")
                print("randomDelenAway: \(String(describing: randomDelenAway))")
                let divideArray = (self.tablesDictDAway?[randomDelenAway[x]])!
                let shuffledDividers = shuffleArray(array: divideArray)
                self.tablesDictDAway?[randomDelenAway[x]] = shuffledDividers
            }
            */
            // home
            let numberArrayHome = vermenigvuldigen(playerAge: player2Age)
            for x in randomDelenHome {
                if x != 0 {
                    for y in numberArrayHome {
                        if ((self.tablesDictDHome?[x]) != nil) {
                            var arr: Array<Int> = (self.tablesDictDHome?[x])!
                            arr.append(x * y)
                            self.tablesDictDHome?[x] = arr
                        } else {
                            let mult = [x * y]
                            self.tablesDictDHome?[x] = mult
                        }
                    }
                }
            }
            // Shuffle dividing numbers and add to tableDictD
            /*
            for x in 0..<randomDelenHome.count {
                let divideArray = (self.tablesDictDHome?[randomDelenHome[x]])!
                let shuffledDividers = shuffleArray(array: divideArray)
                self.tablesDictDHome?[randomDelenHome[x]] = shuffledDividers
            }
            */
//            print("tablesDictDAway: \(String(describing: tablesDictDAway))")
//            print("tablesDictDHome: \(String(describing: tablesDictDHome))")
        } else if sign == "+" {
            randomOptellenAway = shuffleArray(array: optellen(playerAge: player1Age))
            randomOptellenHome = shuffleArray(array: optellen(playerAge: player2Age))
//            print("randomOptellenAway: \(randomOptellenAway)")
//            print("randomOptellenHome: \(randomOptellenHome)")
        } else if sign == "-" {
            randomAftrekkenAway = shuffleArray(array: optellen(playerAge: player1Age))
            randomAftrekkenHome = shuffleArray(array: optellen(playerAge: player2Age))
//            print("randomAftrekkenAway: \(randomAftrekkenAway)")
//            print("randomAftrekkenHome: \(randomAftrekkenHome)")
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
        
        if action == "" {
            messageLabel.text = "Are you ready to play ball?"
            actionMessage.text = "Tap on Go! to continue"
        }
        
//        print("away player: \(awayPlayerName)")
        topPlayer.text = awayPlayerName
//        print("home player: \(homePlayerName)")
        bottomPlayer.text = homePlayerName
        
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.masksToBounds = true
        messageLabel.layer.borderWidth = 2
        messageLabel.layer.borderColor = UIColor.FlatColor.Violet.Wisteria.cgColor
        messageLabel.backgroundColor = UIColor.init(white: 0.8, alpha: 0.8)
        
        actionMessage.alpha = 1.0
        actionMessage.layer.cornerRadius = 10
        actionMessage.layer.masksToBounds = true
        actionMessage.layer.borderWidth = 2
        actionMessage.layer.borderColor = UIColor.FlatColor.Red.WellRead.cgColor
        actionMessage.backgroundColor = UIColor.init(white: 0.8, alpha: 0.8)
        
        extraMessage.alpha = 0.0
        extraMessage.layer.cornerRadius = 10
        extraMessage.layer.masksToBounds = true
        extraMessage.layer.borderWidth = 2
        extraMessage.layer.borderColor = UIColor.FlatColor.Violet.Wisteria.cgColor
        extraMessage.backgroundColor = UIColor.init(white: 0.8, alpha: 0.8)
        
        
        
        /*
        flashMessage = UILabel()
        flashMessage.text = "test"
        flashMessage.layer.cornerRadius = 10
        flashMessage.layer.borderWidth = 2
        flashMessage.font = UIFont.systemFont(ofSize: 25)
        flashMessage.layer.borderColor = UIColor.FlatColor.Red.WellRead.cgColor
        flashMessage.backgroundColor = UIColor.white
        flashMessage.layer.masksToBounds = true
        flashMessage.center = CGPoint(x: 100, y: -40)
        view.addSubview(flashMessage)
        */
        
        runMessage.alpha = 0.0
        runMessage.layer.cornerRadius = 10
        runMessage.layer.borderWidth = 0
        runMessage.layer.masksToBounds = true
        runMessage.tintColor = UIColor.FlatColor.Red.TerraCotta
        runMessage.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        progressView.layer.cornerRadius = 10
        progressView.layer.masksToBounds = true
        progressView.layer.borderWidth = 2
        progressView.layer.borderColor = UIColor.FlatColor.Yellow.Turbo.cgColor
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = UIColor.FlatColor.Orange.Sun
        progressView.backgroundColor = UIColor.FlatColor.Orange.NeonCarrot
        progressView.progress = 0.0
        progressView.isHidden = true
        
        balls = startingBalls
        strikes = startingStrikes
        outs = startingOuts
        updateBSOlabels()
        
    }
    
    // MARK: - storyboard
    func storyBoard() {
        if playerMode == 2 {
            print("2 player mode selected")
            keypadView.isUserInteractionEnabled = false
            updateBoxScore(inning: inning, top: top)
            updateBSOlabels()
            var defplayer: String = awayPlayerName
            var offplayer: String = homePlayerName
            if top {
                offplayer = awayPlayerName
                defplayer = homePlayerName
            } else {
                offplayer = homePlayerName
                defplayer = awayPlayerName
            }
            if action == "pitching" {
                messageLabel.text = "\(defplayer) ready to pitch?"
                if top {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                } else {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                }
                confirm()
            } else if action == "batting" {
                messageLabel.text = "\(offplayer) ready to bat?"
                if top {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                } else {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                }
                confirm()
            } else if action == "running" {
                messageLabel.text = "\(offplayer) how fast can you run?"
                if top {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                } else {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                }
                confirm()
            } else if action == "defense" {
                messageLabel.text = "\(defplayer) can you make the out?"
                if top {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                } else {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                }
                confirm()
            } else if action == "endgame" {
                if totalRunsAway == totalRunsHome {
                    messageLabel.text = "Tie Game!"
                } else {
                    messageLabel.text = "Ball Game!"
                }
                confirm()
            } else if action == "change field" {
                messageLabel.text = "Change field!"
                actionMessage.text = "Pitcher is warming up."
                action = "pitching"
                confirm()
            }
        } else { // player1Mode!
            print("1 player mode selected")
            if homePlayerName == "Oudenaarde Frogs" && awayPlayerName != "Ronse Wolverines" {
                // live player = away team
                computer = homePlayerName
            } else if homePlayerName != "Oudenaarde Frogs" && awayPlayerName == "Ronse Wolverines" {
                // live player = home team
                computer = awayPlayerName
            } else if homePlayerName == "Oudenaarde Frogs" && awayPlayerName == "Ronse Wolverines" {
                // arbitrary live player = away team
                computer = homePlayerName
            } else {
                // arbitrary live player = home team
                computer = awayPlayerName
            }
            
            keypadView.isUserInteractionEnabled = false
            updateBoxScore(inning: inning, top: top)
            updateBSOlabels()
            var defplayer: String = awayPlayerName
            var offplayer: String = homePlayerName
            if top {
                offplayer = awayPlayerName
                defplayer = homePlayerName
            } else {
                offplayer = homePlayerName
                defplayer = awayPlayerName
            }
            if action == "pitching" {
                if top {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                } else {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                }
                if computer == homePlayerName { // computer pitches}
                    messageLabel.text = "\(defplayer) is pitching."
                    actionResult(success: calculateComputerPitch())
                } else {
                    messageLabel.text = "\(defplayer) ready to pitch?"
                    confirm()
                }
            } else if action == "batting" {
                if top {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                } else {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                }
                if computer == homePlayerName { // player bats
                    messageLabel.text = "\(offplayer) ready to bat?"
                    confirm()
                } else { // computer bats
                    messageLabel.text = "\(offplayer) is batting."
                    actionResult(success: calculateComputerBatting())
                }
            } else if action == "running" {
                if top {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                } else {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                }
                if computer == homePlayerName { // player runs
                    messageLabel.text = "\(offplayer) how fast can you run?"
                    confirm()
                } else { // computer runs
                    messageLabel.text = "(Offplayer) is running."
                    actionResult(success: calculateRunning())
                }
            } else if action == "defense" {
                if top {
                    bottomPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                    topPlayer.backgroundColor = UIColor.white
                } else {
                    bottomPlayer.backgroundColor = UIColor.white
                    topPlayer.backgroundColor = UIColor.FlatColor.Green.MountainMeadow
                }
                if computer == homePlayerName { // computer defends
                    messageLabel.text = "\(defplayer) is defending."
                    actionResult(success: calculateDefense())
                } else {
                    messageLabel.text = "\(defplayer) can you make the out?"
                    confirm()
                }
            } else if action == "endgame" {
                if totalRunsAway == totalRunsHome {
                    messageLabel.text = "Tie Game!"
                } else {
                    messageLabel.text = "Ball Game!"
                }
                confirm()
            } else if action == "change field" {
                messageLabel.text = "Change field!"
                actionMessage.text = "Pitcher is warming up."
                action = "pitching"
                confirm()
            }
        }
    }
    
    // MARK: - Calucations computer results
    func calculateComputerPitch() -> Bool {
        // random 1/4 = ball
        let ballsAndStrikes: Array<Bool> = [true, true, true, false]
        let randomPitch = Int(arc4random_uniform(UInt32(ballsAndStrikes.count)))
        let pitchResult = ballsAndStrikes[randomPitch]
        return pitchResult
    }
    
    func calculateComputerBatting() -> Bool {
        // random times
        let battingTimes: Array<Double> = [0.9, 1.9, 2.9, 3.9, 4.9, 5.9, 6.9, 7.9, 8.9, 9.9]
        let randomBatTime = Int(arc4random_uniform(UInt32(battingTimes.count)))
        if computer == homePlayerName {
            oTimeHandicapTime = battingTimes[randomBatTime] * (1 / player1Handicap)
        } else {
            oTimeHandicapTime = battingTimes[randomBatTime] * (1 / player2Handicap)
        }
        // random bat result
        let battingResults: Array<Bool> = [true, true, false]
        let randomBatting = Int(arc4random_uniform(UInt32(battingResults.count)))
        let battingResult = battingResults[randomBatting]
        return battingResult
    }
    
    func calculateRunning() -> Bool {
        // running times
        if inning == 1 { // inning 1 -> random time
            let runTimes: Array<Double> = [0.9, 1.9, 2.9, 3.9, 4.9, 5.9, 6.9, 7.9, 8.9, 9.9]
            let randomRunTime = Int(arc4random_uniform(UInt32(runTimes.count)))
            if computer == homePlayerName {
                oTimeHandicapTime = runTimes[randomRunTime] * (1 / player1Handicap)
            } else {
                oTimeHandicapTime = runTimes[randomRunTime] * (1 / player2Handicap)
            }
        } else { // use mean times from player}
            let sumOfPlayerTimes = tijden1steInnning.reduce(0, +)
            let avgPlayerTime = sumOfPlayerTimes / Double(tijden1steInnning.count)
            if computer == homePlayerName {
                oTimeHandicapTime = avgPlayerTime * (1 / player1Handicap)
            } else {
                oTimeHandicapTime = avgPlayerTime * (1 / player2Handicap)
            }
        }
        // running result
        let runResults: Array<Bool> = [true, true, true, true, true, true, true, true, false]
        let randomRun = Int(arc4random_uniform(UInt32(runResults.count)))
        let runResult = runResults[randomRun]
        return runResult
    }
    
    func calculateDefense() -> Bool {
        // defensive times
        if inning == 1 { // inning 1 -> random time
            let defensiveTimes: Array<Double> = [0.9, 1.9, 2.9, 3.9, 4.9, 5.9, 6.9, 7.9, 8.9, 9.9]
            let randomDefenseTime = Int(arc4random_uniform(UInt32(defensiveTimes.count)))
            if computer == homePlayerName {
                oTimeHandicapTime = defensiveTimes[randomDefenseTime] * (1 / player1Handicap)
            } else {
                oTimeHandicapTime = defensiveTimes[randomDefenseTime] * (1 / player2Handicap)
            }
        } else { // use mean times from player}
            let sumOfPlayerTimes = tijden1steInnning.reduce(0, +)
            let avgPlayerTime = sumOfPlayerTimes / Double(tijden1steInnning.count)
            if computer == homePlayerName {
                dTimeHandicapTime = avgPlayerTime * (1 / player2Handicap)
            } else {
                dTimeHandicapTime = avgPlayerTime * (1 / player1Handicap)
            }
        }
        
        // running result
        let defensiveResults: Array<Bool> = [true, true, true, false]
        let randomDefense = Int(arc4random_uniform(UInt32(defensiveResults.count)))
        let defensiveResult = defensiveResults[randomDefense]
        return defensiveResult
    }
    
    // MARK: - action result
    // MARK: pitching result
    func pitching(success: Bool) {
        if success {
            //strike
            //                print("Strike")
            strike = true
            self.actionMessage.text = "Good pitch!"
        } else {
            //ball
            //                print("Ball")
            strike = false
            actionMessage.text = "Going wide"
        }
        self.action = "batting"
    }
    
    // MARK: batting result
    func batting(success: Bool) {
//        print("strike: \(strike)")
        if strike { // pitch was a strike
            if success { //Contact on a strike
                //                    print("success on a strike!")
                var outcome: String = ""
                if oTimeHandicapTime < 2.0 {
                    outcome = "Going for the fence!"
                    hit = 4
                } else if oTimeHandicapTime < 3.0 {
                    outcome = "Flyball deep to left field!"
                    hit = 3
                } else if oTimeHandicapTime < 5.0 {
                    outcome = "Nice line drive into the outfield!"
                    hit = 2
                } else if oTimeHandicapTime < 7.0 {
                    outcome = "Good hit. Hussle for the single!"
                    hit = 1
                } else {
                    outcome = "Hmmm. You better hussle!"
                    hit = 0
                }
                self.actionMessage.text = "Nice swing! \(outcome)"
                self.action = "running"
            } else { // Miss on a strike
                strikes += 1
                //                    print("strike \(strikes)")
                self.actionMessage.text = "Swing and a miss!"
                action = "pitching"
                if strikes == 3 {
                    //                        print("3 strikes, batter is out")
                    showExtraMessage("Strike out!")
                    strikes = startingStrikes
                    balls = startingBalls
                    outs += 1
                    //                        print("balls: \(balls), strikes: \(strikes), outs: \(outs)")
                    if outs == 3 {
                        balls = startingBalls
                        strikes = startingStrikes
                        if top {
                            top = false
                        } else {
                            top = true
                            inning += 1
                        }
                        outs = startingOuts
                        runs = 0
                        runnersPosAlgo = 0
                        action = "change field"
                        showExtraMessage("Strike out! Change field.")
                    } else {
                        action = "pitching"
                    }
                }
                
            }
            strike = false
        } else { // wide ball
            if success { // Checking on a ball
                //                    print("Didn't swing at a ball")
                self.actionMessage.text = "Great job with the check swing."
                balls += 1
                if balls < 4 {
                    action = "pitching"
                } else {
                    showExtraMessage("Base on balls!")
                    balls = startingBalls
                    strikes = startingStrikes
                    action = "pitching"
                    progressRunners("bob")
                }
            } else { // Swinging at a ball
                //swing and a miss unless very very good time?
                //                    print("Swing and a miss at a ball")
                actionMessage.text = "Swing and a miss!"
                if oTimeHandicapTime < 2 { // Good reaction time on swing and miss at a ball
//                    print("Wrong answer in less than 2 seconds")
                    if outs == 2 {
                        // dropped third strike
                        showExtraMessage("Swing and a miss! Dropped third strike! Run!")
                        action = "running"
                        balls = startingBalls
                        strikes = startingStrikes
                    } else if outs < 2 {
                        if runnersPosAlgo == 1 || runnersPosAlgo == 3 || runnersPosAlgo == 5 || runnersPosAlgo == 7 {
                            //Dropped third strike not possible
                            showExtraMessage("Batter is out!")
                            outs += 1
                            balls = startingBalls
                            strikes = startingStrikes
                            
                            if outs == 3 {
                                balls = startingBalls
                                strikes = startingStrikes
                                if top {
                                    top = false
                                } else {
                                    top = true
                                    inning += 1
                                }
                                outs = startingOuts
                                runs = 0
                                runnersPosAlgo = 0
                                action = "change field"
                            } else {
                                action = "pitching"
                            }
                        } else {
                            //Dropped third strike, 1B not occupied
                            showExtraMessage("Dropped third strike! 1B is empty, go for it!")
                            balls = startingBalls
                            strikes = startingStrikes
                            action = "running"
                        }
                    }
                } else { // Missed a ball
//                    print("wrong answer, swing and a miss at a ball")
                    actionMessage.text = "That's a swing! Strike!"
                    strikes += 1
                    
                    if strikes == 3 {
                        //                            print("3 strikes, batter is out")
                        showExtraMessage("Strike out!")
                        strikes = startingStrikes
                        balls = startingBalls
                        outs += 1
                        if outs == 3 {
                            balls = startingBalls
                            strikes = startingStrikes
                            if top {
                                top = false
                            } else {
                                top = true
                                inning += 1
                            }
                            outs = startingOuts
                            runs = 0
                            runnersPosAlgo = 0
                            action = "change field"
                        } else {
                            action = "pitching"
                        }
                    } else {
                        action = "pitching"
                    }
                }
            }
        }
    }
    
    // MARK: running action
    func running(success: Bool) {
        if success {
            //if correct continue to defense
            //                print("correct answer for running")
            if hit == 0 || hit == 1 {
                actionMessage.text = "Running to first base..."
            } else if hit == 2 {
                actionMessage.text = "Going for second base..."
            } else if hit == 3 {
                actionMessage.text = "Turning the bases..."
            } else if hit == 4 {
                actionMessage.text = "Running home!"
            }
            runningSuccessful = true
            //                print("offensive time(h) = \(oTimeHandicapTime)")
            action = "defense"
        } else {
            //if wrong answer and defense correct: runner out
            //                print("wrong answer for running")
            actionMessage.text = "Jogging to first base..."
            runningSuccessful = false
            //                print("offensive time(h) = \(oTimeHandicapTime)")
            action = "defense"
        }
    }
    
    // MARK: defensive action
    func defense(success: Bool) {
        //            print("defensive time(h) = \(dTimeHandicapTime)")
        if runningSuccessful {
            if success {
                if dTimeHandicapTime < oTimeHandicapTime {
                    // Defense is faster, batter is out
                    outs += 1
                    //                        print("batter runner is out")
                    if hit == 0 || hit == 1 {
                        actionMessage.text = "Runner is out on first!"
                    } else if hit == 2 {
                        actionMessage.text = "Straight in the glove! No runners advance"
                    } else if hit == 3 {
                        if dTimeHandicapTime > 9 && outs < 3 {
                            if runnersPosAlgo == 2 || runnersPosAlgo == 3 {
                                actionMessage.text = "Fly out! Runner tagged up and advanced to third base."
                            } else if runnersPosAlgo == 4 || runnersPosAlgo == 5 {
                                actionMessage.text = "Fly out! Runner tagged up and scored a run."
                            } else if runnersPosAlgo == 6 || runnersPosAlgo == 7 {
                                actionMessage.text = "Fly out! Runners advanced, scoring one run."
                            } else {
                                actionMessage.text = "Fly out! No runners advanced."
                            }
                            progressRunners("tag up")
                        } else {
                            actionMessage.text = "Fly out! No runners could advance."
                        }
                    }
                    
                    balls = startingBalls
                    strikes = startingStrikes
                    action = "pitching"
                    if outs == 3 {
                        balls = startingBalls
                        strikes = startingStrikes
                        if top {
                            top = false
                        } else {
                            top = true
                            inning += 1
                        }
                        outs = startingOuts
                        runs = 0
                        runnersPosAlgo = 0
                        action = "change field"
                    } else {
                        action = "pitching"
                    }
                    updateBasesImage()
                    
                } else {
                    //                        print("defense too slow")
                    
                    if hit == 0 || hit == 1 {
                        actionMessage.text = "Defense too slow. Runner safe on first!"
                        progressRunners("single")
                    } else if hit == 2 {
                        actionMessage.text = "Nice double!"
                        progressRunners("double")
                    } else if hit == 3 {
                        actionMessage.text = "Wow, what a triple!"
                        progressRunners("triple")
                    } else {
                        actionMessage.text = "It's high, it's far, it's out of here!"
                        progressRunners("homerun")
                    }
                    
                    updateBasesImage()
                    balls = startingBalls
                    strikes = startingStrikes
                    if top {
                        hitsAway += 1
                    } else {
                        hitsHome += 1
                    }
                    self.action = "pitching"
                }
            } else { // wrong answer
                // Defense too slow, runner safe on first
                //                    print("runner safe")
                
                if hit == 0 {
                    actionMessage.text = "Safe on first due to a defensive error!"
                    progressRunners("single")
                    if top {
                        errorsAway += 1
                    } else {
                        errorsHome += 1
                    }
                } else if hit == 1 {
                    actionMessage.text = "A single just turned into a double due to an error"
                    progressRunners("double")
                    if top {
                        hitsAway += 1
                    } else {
                        hitsHome += 1
                    }
                } else if hit == 2 {
                    actionMessage.text = "An easy double!"
                    progressRunners("double")
                    if top {
                        hitsAway += 1
                    } else {
                        hitsHome += 1
                    }
                } else if hit == 3 {
                    actionMessage.text = "Nice triple. The defense was stunned!"
                    progressRunners("triple")
                    if top {
                        hitsAway += 1
                    } else {
                        hitsHome += 1
                    }
                } else {
                    actionMessage.text = "Nothing the defense could do there!"
                    progressRunners("homerun")
                    if top {
                        hitsAway += 1
                    } else {
                        hitsHome += 1
                    }
                }
                updateBasesImage()
                balls = startingBalls
                strikes = startingStrikes
                self.action = "pitching"
            }
        } else {
            if success && dTimeHandicapTime < oTimeHandicapTime {
                // Defense is faster, batter is out
                //                    print("batter runner is out")
                actionMessage.text = "Runner is out on first!"
                outs += 1
                balls = startingBalls
                strikes = startingStrikes
                self.action = "pitching"
                if outs == 3 {
                    balls = startingBalls
                    strikes = startingStrikes
                    if top {
                        top = false
                    } else {
                        top = true
                        inning += 1
                    }
                    outs = startingOuts
                    runs = 0
                    runnersPosAlgo = 0
                    action = "change field"
                } else {
                    action = "pitching"
                }
            } else if !success {
                //                    print("reached on error")
                actionMessage.text = "Reached first base on error."
                progressRunners("single")
                showExtraMessage("Single")
                updateBasesImage()
                balls = startingBalls
                strikes = startingStrikes
                if top {
                    errorsAway += 1
                } else {
                    errorsHome += 1
                }
                action = "pitching"
            } else {
                // foul ball
                //                    print("foul ball")
                actionMessage.text = "Foul ball! Try again."
                if strikes < 2 {
                    strikes += 1
                }
                self.action = "pitching"
            }
        }
    }

    // MARK: action result filter
    func actionResult(success: Bool) {
        //Upon success (pitching, batting, running, defense)
//        print("actionResult! inning: \(inning), top: \(top), action: \(action), success: \(success), runs: \(runs), total runs: \(totalruns)")
        if action == "pitching" {
            pitching(success: success)
        } else if action == "batting" {
            batting(success: success)
        } else if action == "running" {
            running(success: success)
        } else if action == "defense" {
            defense(success: success)
        }
        updateBoxScore(inning: inning, top: top)
        if outs == 3 {
            balls = startingBalls
            strikes = startingStrikes
            outs = startingOuts
            if top {
                top = false
            } else {
                top = true
                inning += 1
            }
            runs = 0
            runnersPosAlgo = 0
            action = "change field"
        }
        storyBoard()
       
    }

    
    // MARK: - show confirm button
    func confirm() {
        if top {
            if action == "batting" || action == "running" {
                goButton.setTitle("\(awayPlayerName) GO!", for: .normal)
            } else {
                goButton.setTitle("\(homePlayerName) GO!", for: .normal)
            }
        } else {
            if action == "batting" || action == "running" {
                goButton.setTitle("\(homePlayerName) GO!", for: .normal)
            } else {
                goButton.setTitle("\(awayPlayerName) GO!", for: .normal)
            }
        }
        goButton.isUserInteractionEnabled = true
        goButton.isHidden = false
    }
    
    // MARK: - moveOn to math question
    func moveOn(team: Int) {
        actionMessage.text = action.capitalized + "..."
        // Show math
        mathQuestionView.isHidden = false
        // Fill math question
        // Get random sign
        let shuffledMaths = shuffleArray(array: signArray)
        let mathSign = selectedMaths![shuffledMaths.first!]
        mathEquationLabel.text = mathSign
        answerField.text = ""
        // Numbers
        if mathSign == "+" {
//            print("+")
            if team == 1 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomOptellenAway.count)))
                somTotaal = randomOptellenAway[randomNumber]
            } else if team == 2 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomOptellenHome.count)))
                somTotaal = randomOptellenHome[randomNumber]
            }
            // pick a random number smaller than somTotaal
            let randomGetal = Int(arc4random_uniform(UInt32(somTotaal!)))
            mathLabel1.text = String(randomGetal)
            mathLabel2.text = String(somTotaal! - randomGetal)
            correctAnswer = String(somTotaal!)
        } else if mathSign == "-" {
//            print("-")
            if team == 1 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomAftrekkenAway.count)))
                somTotaal = randomAftrekkenAway[randomNumber]
            } else if team == 2 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomAftrekkenHome.count)))
                somTotaal = randomAftrekkenHome[randomNumber]
            }
            // pick a random number smaller than somTotaal
            let randomGetal = Int(arc4random_uniform(UInt32(somTotaal!)))
            mathLabel1.text = String(somTotaal!)
            mathLabel2.text = String(randomGetal)
            correctAnswer = String(somTotaal! - randomGetal)
            
        } else if mathSign == "x" {
//            print("x")
            // Pick a random number from the dictionary keys
            if team == 1 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomVermenigvuldigenAway.count)))
                mult1 = self.randomVermenigvuldigenAway[randomNumber]
                let randomN = Int(arc4random_uniform(UInt32(self.randomVermenigvuldigenAway.count)))
                mult2 = tablesDictVAway?[mult1!]?[randomN]
            } else {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomVermenigvuldigenHome.count)))
                mult1 = self.randomVermenigvuldigenHome[randomNumber]
                let randomN = Int(arc4random_uniform(UInt32(self.randomVermenigvuldigenAway.count)))
                mult2 = tablesDictVAway?[mult1!]?[randomN]
            }
            
            mathLabel1.text = String(describing: mult2!)
            mathLabel2.text = String(describing: mult1!)
            correctAnswer = String(mult1! * mult2!)
        } else {
//            print(":")
            if team == 1 {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomDelenAway.count)))
                mult1 = Array((tablesDictDAway?.keys)!)[randomNumber]
//                print("mult1: \(String(describing: mult1))")
            } else {
                let randomNumber = Int(arc4random_uniform(UInt32(self.randomDelenHome.count)))
                mult1 = Array((tablesDictDHome?.keys)!)[randomNumber]
//                print("mult1: \(String(describing: mult1))")
                
            }
            let randomN = Int(arc4random_uniform(UInt32(self.randomDelenAway.count)))
            mult2 = tablesDictDAway?[mult1!]?[randomN]
//            print("mult2: \(String(describing: mult2))")
            mathLabel1.text = String(describing: mult2!)
            mathLabel2.text = String(describing: mult1!)
            correctAnswer = String(mult2! / mult1!)
        }
    }
    
    
    // MARK: - check Result
    func checkResult() -> Bool {
        let result: Bool = answerField.text == correctAnswer
//        print("result: \(result)")
//        print("progressView progress = \(progressView.progress)")
        if result {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Textfield Delegate
    // MARK: allowed characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
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
        // go to next inputfield
//        print("textFieldShouldReturn")
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
    // MARK: - progress runners on the image
    func progressRunners(_ hit: String) {
        if hit == "tag up" {
            // advance runners on 2 and or 3 after tag up
            if runnersPosAlgo == 2 {
                runnersPosAlgo = 4
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 5
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 0
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 1
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 4
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 5
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            }
        }
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
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
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
                    showRunMessage(1, message: "")
                    if top {
                        totalRunsAway += 1
                    } else {
                        totalRunsHome += 1
                    }
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
                    showRunMessage(1, message: "")
                    if top {
                        totalRunsAway += 1
                    } else {
                        totalRunsHome += 1
                    }
                }
            }
        }
        if hit == "single" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 1
                showRunMessage(0, message: "single")
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 3
                showRunMessage(0, message: "single")
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 5
                showRunMessage(0, message: "single")
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 1
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 7
                showRunMessage(0, message: "single")
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 3
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 5
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 7
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            }
        } else if hit == "double" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 2
                showRunMessage(0, message: "double")
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 6
                showRunMessage(0, message: "single")
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 2
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 2
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 6
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 5
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 2
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 6
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            }
        } else if hit == "triple" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 4
                showRunMessage(0, message: "triple")
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 4
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 4
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 4
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 4
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 4
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 4
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 4
                runs += 3
                showRunMessage(3, message: "")
                if top {
                    totalRunsAway += 3
                } else {
                    totalRunsHome += 3
                }
            }
        } else if hit == "homerun" {
            if runnersPosAlgo == 0 {
                runnersPosAlgo = 0
                runs += 1
                showRunMessage(1, message: "")
                if top {
                    totalRunsAway += 1
                } else {
                    totalRunsHome += 1
                }
            } else if runnersPosAlgo == 1 {
                runnersPosAlgo = 0
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 2 {
                runnersPosAlgo = 0
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 4 {
                runnersPosAlgo = 0
                runs += 2
                showRunMessage(2, message: "")
                if top {
                    totalRunsAway += 2
                } else {
                    totalRunsHome += 2
                }
            } else if runnersPosAlgo == 3 {
                runnersPosAlgo = 0
                runs += 3
                showRunMessage(3, message: "")
                if top {
                    totalRunsAway += 3
                } else {
                    totalRunsHome += 3
                }
            } else if runnersPosAlgo == 5 {
                runnersPosAlgo = 0
                runs += 3
                showRunMessage(3, message: "")
                if top {
                    totalRunsAway += 3
                } else {
                    totalRunsHome += 3
                }
            } else if runnersPosAlgo == 6 {
                runnersPosAlgo = 0
                runs += 3
                showRunMessage(3, message: "")
                if top {
                    totalRunsAway += 3
                } else {
                    totalRunsHome += 3
                }
            } else if runnersPosAlgo == 7 {
                runnersPosAlgo = 0
                runs += 4
                showRunMessage(4, message: "")
                if top {
                    totalRunsAway += 4
                } else {
                    totalRunsHome += 4
                }
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
        for inn in inningsLabel {
            inn.viewWithTag(inning)?.backgroundColor = UIColor.FlatColor.Blue.CuriousBlue
        }
        if inning == 1 {
            if top {
                top1.text = String(runs)
                top1.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom1.text = String(runs)
                bottom1.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 2 {
            if top {
                top2.text = String(runs)
                top2.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom2.text = String(runs)
                bottom2.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 3 {
            if top {
                top3.text = String(runs)
                top3.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom3.text = String(runs)
                bottom3.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 4 {
            if top {
                top4.text = String(runs)
                top4.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom4.text = String(runs)
                bottom4.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 5 {
            if top {
                top5.text = String(runs)
                top5.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom5.text = String(runs)
                bottom5.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 6 {
            if top {
                top6.text = String(runs)
                top6.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom6.text = String(runs)
                bottom6.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 7 {
            if top {
                top7.text = String(runs)
                top7.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom7.text = String(runs)
                bottom7.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 8 {
            if top {
                top8.text = String(runs)
                top8.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom8.text = String(runs)
                bottom8.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } else if inning == 9 {
            if top {
                top9.text = String(runs)
                top9.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            } else {
                bottom9.text = String(runs)
                bottom9.backgroundColor = UIColor.FlatColor.Gray.WhiteSmoke
            }
        } // add extra inning
        if top {
            topRuns.text = String(totalRunsAway)
            topHits.text = String(hitsAway)
            topErrors.text = String(errorsAway)
        } else {
            bottomRuns.text = String(totalRunsHome)
            bottomHits.text = String(hitsHome)
            bottomErrors.text = String(errorsHome)
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
        let xfactor: Float = Float(10 / H) * 100.0
        let prog: Float = Float(honderdsten) / xfactor
        progressView.setProgress(prog, animated: true)
    }
    
    // MARK: check time
    func checkTime() -> Double {
        timer.invalidate()
        return honderdsten / 100
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
//        print("updating BSO: balls: \(balls), strikes: \(strikes), outs: \(outs)")
        if balls == 0 {
            ball1.backgroundColor = UIColor.white
            ball2.backgroundColor = UIColor.white
            ball3.backgroundColor = UIColor.white
        } else if balls == 1 {
            ball1.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball2.backgroundColor = UIColor.white
            ball3.backgroundColor = UIColor.white
        } else if balls == 2 {
            ball1.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball2.backgroundColor = UIColor.FlatColor.Green.PersianGreen
            ball3.backgroundColor = UIColor.white
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
            strike2.backgroundColor = UIColor.white
        } else if strikes == 2 {
            strike1.backgroundColor = UIColor.FlatColor.Red.Valencia
            strike2.backgroundColor = UIColor.FlatColor.Red.Valencia
        }
        if outs == 0 {
            out1.backgroundColor = UIColor.white
            out2.backgroundColor = UIColor.white
        } else if outs == 1 {
            out1.backgroundColor = UIColor.FlatColor.Red.Valencia
            out2.backgroundColor = UIColor.white
        } else if outs == 2 {
            out1.backgroundColor = UIColor.FlatColor.Red.Valencia
            out2.backgroundColor = UIColor.FlatColor.Red.Valencia
        }
    }
    
    func endGame() {
        if totalRunsHome > totalRunsAway {
            messageLabel.text = "\(homePlayerName) wins the game!"
        } else {
            messageLabel.text = "\(awayPlayerName) wins the game!"
        }
        actionMessage.text = "Tap 'back' to set up a new game."
        goButton.setTitle("Back", for: .normal)
        action = "endgame"
    }
    
    // MARK: - Mathematics
    func optellen(playerAge: Int) -> Array<Int> {
        var optelnummers: Array<Int> = []
        if playerAge < 8 {
            for x in 0...20 {
                optelnummers.append(x)
            }
        } else if playerAge < 10 {
            for x in 0...100 {
                optelnummers.append(x)
            }
        } else {
            for x in 0...1000 {
                optelnummers.append(x)
            }
        }
        return optelnummers
    }
    
    func vermenigvuldigen(playerAge: Int) -> Array<Int> {
        var vermNummers: Array<Int> = []
        if playerAge < 8 {
            for x in 1...5 {
                vermNummers.append(x)
            }
        } else if playerAge < 10 {
            for x in 0...10 {
                vermNummers.append(x)
            }
        } else {
            for x in 0...11 {
                vermNummers.append(x)
            }
        }
        return vermNummers
    }
    
    // MARK: shuffle
    // MARK: shuffle Array
    func shuffleArray(array: Array<Int>) -> Array<Int> {
        var tempShuffled: Array<Int> = []
        var tempArray = array
        while 0 < tempArray.count {
            let rand = Int(arc4random_uniform(UInt32(tempArray.count)))
            tempShuffled.append(tempArray[rand])
            tempArray.remove(at: rand)
        }
        return tempShuffled
    }
    
    func showRunMessage(_ numberOfRuns: Int, message: String) {
        if numberOfRuns == 0 {
            runMessage.text = message
        } else if numberOfRuns == 1 {
            runMessage.text = "1 run!"
        } else if numberOfRuns == 4 {
            runMessage.text = "Grand Slam!"
        } else {
            runMessage.text = "\(numberOfRuns) runs!"
        }
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.runMessage.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            self.runMessage.text = ""
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.runMessage.alpha = 0.0
            }, completion: nil)
        })
    }
    
    func showExtraMessage(_ message: String) {
        extraMessage.text = message
        
        UIView.animate(withDuration: 3.0, animations: {
            self.runMessage.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            self.extraMessage.text = ""
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.extraMessage.alpha = 0.0
            }, completion: nil)
        })
    }
    /*
    func showFlashMessage(message: String) {
        print("showing Flashmessage: \(message)")
        self.flashMessage.text = message
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            self.flashMessage.center = CGPoint(x: 100, y:-40 + 340)
        }, completion: { (finished: Bool) in
            self.flashMessage.center = CGPoint(x: 100, y:-40)
        })
    }
    */
}
