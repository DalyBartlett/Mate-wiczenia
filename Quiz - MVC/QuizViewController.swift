import UIKit
import CoreData
class QuizViewController: UIViewController {
    let quizView = QuizView()
    var quizModel: QuizModel!
    var randCategory = Int()
    var timer = Timer()
    var goodAnswerPlacement: Int!
    var badAnswerPlacement: Bool!
    var first: Int? = nil
    var generator: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        quizModel = QuizModel()
        configureController()
        configureCalculatorView()
        UIDevice.current.userInterfaceIdiom == .phone ?( quizView.question.fontSize = 14 ): (quizView.question.fontSize = 26)
        quizModel.odczyt()
        RandomCategoryGenerator()
        NotificationCenter.default.addObserver(self, selector: #selector(stoppingTheTimer), name:UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startingTheTimer), name:UIApplication.didBecomeActiveNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.removeFromParent()
        self.view.removeGestureRecognizer((revealViewController()?.panGestureRecognizer())!)
        print("disappear")
    }
    func configureController() {
        view.backgroundColor = Theme.current.mainColor
        self.navigationItem.titleView = quizView.createLogoImage()
    }
    func configureCalculatorView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "kalkulatorView")
        self.revealViewController()?.setRight(vc, animated: true)
        if revealViewController()  != nil {
            self.navigationItem.rightBarButtonItems = quizView.createCalculator(vc: self)
            quizView.boardButton.addTarget(self, action: #selector(clicked), for: .touchUpInside)
            quizView.calculatorButton.addTarget(vc.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer((revealViewController()?.panGestureRecognizer())!)
        }
    }
    @objc func newQuestion() {
        view.addSubview(quizView.question)
        quizView.question.translatesAutoresizingMaskIntoConstraints = false
        quizView.question.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        quizView.question.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        quizView.question.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        quizView.question.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        let dispbtnx = view.center.x
        let dispbtny = view.center.y
        let placebtn: [[CGFloat]] = [[ dispbtnx * 2 / 20 , dispbtny , dispbtnx*45/20 , dispbtny/5 ] , [ dispbtnx * 2 / 20 , dispbtny + dispbtny / 4 , dispbtnx*45/20 , dispbtny/5 ] , [ dispbtnx * 2 / 20 , dispbtny + dispbtny / 2 , dispbtnx*45/20 , dispbtny/5 ] , [ dispbtnx * 2 / 20 , dispbtny + dispbtny * 3 / 4 , dispbtnx*45/20 , dispbtny/5 ]]
        for index in 0...3 {
            quizView.createButton(view: self.view , xPosition: placebtn[index][0], yPosition: placebtn[index][1], width1: placebtn[index][2], height1: placebtn[index][3], i: index)
            quizView.button[index].addTarget(self, action: #selector(odp), for: .touchUpInside)
        }
        view.sendSubviewToBack(quizView.nextButton)
        quizView.nextButton.isEnabled = false
        for k in 1...4 {
            quizView.button[k - 1].isEnabled = false
        }
        if quizModel.coreDataQuestionArrays[randCategory].count > 0 {
            first = quizModel.coreDataQuestionArrays[randCategory].first
            print("First: \(first!)")
            print(QuizModel.categories[randCategory])
            print(quizModel.coreDataQuestionArrays[randCategory])
            print(quizModel.coreDataQuestionArrays[randCategory].count)
            print("rezultaty: \(quizModel.results[randCategory][first!])")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.quizView.question.latex = self.quizModel.results[self.randCategory][self.first! - 1][0]
                self.generator = self.quizModel.GenerateRandomNumbers(1, 5, 4)
                for x in 0...3 {
                    if self.generator[x] == 4 {
                        self.goodAnswerPlacement = x
                    }
                }
                for i in 1...4 {
                    self.quizView.answearLabel[i - 1].latex = self.quizModel.results[self.randCategory][self.first! - 1][self.generator[i - 1]]
                    self.quizView.button[i-1].backgroundColor = Theme.current.ButtonsBackColor
                }
            }
        }
        else {
            var x: [Int] = []
            if randCategory == 0 {  x = [1 , 2 , 3 , 4] }
            else if randCategory == 1 {  x = [0 , 2 , 3 , 4] }
            else if randCategory == 2 {  x = [0 , 1 , 3 , 4] }
            else if randCategory == 3 {  x = [0 , 1 , 2 , 4] }
            else if randCategory == 4 {  x = [0 , 1 , 2 , 3] }
            randCategory = x.randomElement()!
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for k in 1...4{
                self.quizView.button[k - 1].isEnabled = true
            }
        }
    }
    @objc func odp(_ sender: UIButton) {
        timer.invalidate()
        for x in 0...3 {
            quizView.button[x].isEnabled = false
        }
        if sender.tag == (goodAnswerPlacement + 1) {
            sender.backgroundColor = UIColor(red: 179/255, green: 222/255, blue: 129/255, alpha: 1)
            if quizModel.coreDataQuestionArrays[randCategory].count >= 1 {
                let goodAnswearCounter = UserDefaults.standard.integer(forKey: QuizModel.goodCounterStrings[randCategory])
                let counter: Int = goodAnswearCounter + 1
                quizModel.defaults.set(counter, forKey: QuizModel.goodCounterStrings[randCategory])
                quizModel.defaults.synchronize()
            }
        }
        else {
            sender.backgroundColor = UIColor(red: 235/255, green: 94/255, blue: 48/255, alpha: 1)
            self.badAnswerPlacement = false
            if quizModel.coreDataQuestionArrays[randCategory].count >= 1 {
                let badAnswearCounter = UserDefaults.standard.integer(forKey: QuizModel.badCounterStrings[randCategory])
                let counter: Int = badAnswearCounter + 1
                quizModel.defaults.set(counter, forKey: QuizModel.badCounterStrings[randCategory])
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.badAnswerPlacement == true {
                    if self.quizView.button[0].tag == (self.goodAnswerPlacement + 1) {
                        self.quizView.button[0].backgroundColor = UIColor(red: 179/255, green: 222/255, blue: 129/255, alpha: 1)
                    }
                    else if self.quizView.button[1].tag == (self.goodAnswerPlacement + 1) {
                        self.quizView.button[1].backgroundColor = UIColor(red: 179/255, green: 222/255, blue: 129/255, alpha: 1)
                    }
                    else if self.quizView.button[2].tag == (self.goodAnswerPlacement + 1) {
                        self.quizView.button[2].backgroundColor = UIColor(red: 179/255, green: 222/255, blue: 129/255, alpha: 1)
                    }
                    else if self.quizView.button[3].tag == (self.goodAnswerPlacement + 1) {
                        self.quizView.button[3].backgroundColor = UIColor(red: 179/255, green: 222/255, blue: 129/255, alpha: 1)
                    }
                }
            }
            badAnswerPlacement = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.quizView.nextButton.frame = CGRect(x: 0 , y: 0 , width: self.view.center.x * 2, height: self.view.center.y * 2)
            self.view.addSubview(self.quizView.nextButton)
            self.quizView.nextButton.addTarget(self, action: #selector(self.RandomCategoryGenerator), for: .touchUpInside)
            self.view.sendSubviewToBack(self.quizView.nextButton)
            if self.quizModel.coreDataQuestionArrays[self.randCategory].count >= 1 {
                self.quizModel.coreDataQuestionArrays[self.randCategory].remove(at:0)
                if self.randCategory == 0 {
                    guard let task = Algebra.instance(with: "questions")
                        else { return }
                    task.updatequestions(with: self.quizModel.coreDataQuestionArrays[self.randCategory]) }
                else if self.randCategory == 1 {
                    guard let task = Funkcje.instance(with: "questions")
                        else { return }
                    task.updatequestions(with: self.quizModel.coreDataQuestionArrays[self.randCategory])
                }
                else if self.randCategory == 2 {
                    guard let task = Trygonometria.instance(with: "questions")
                        else { return }
                    task.updatequestions(with: self.quizModel.coreDataQuestionArrays[self.randCategory])
                }
                else if self.randCategory == 3 {
                    guard let task = Geometria.instance(with: "questions")
                        else { return }
                    task.updatequestions(with: self.quizModel.coreDataQuestionArrays[self.randCategory])
                }
                else if self.randCategory == 4 {
                    guard let task = Prawdopodobienstwo.instance(with: "questions")
                        else { return }
                    task.updatequestions(with: self.quizModel.coreDataQuestionArrays[self.randCategory])
                }
                DatabaseController.saveTimerToCoreData(entityName: QuizModel.categories[self.randCategory], timer: self.quizModel.counts)
                self.view.bringSubviewToFront(self.quizView.nextButton)
                self.quizView.nextButton.isEnabled = true
            }
        }
    }
    @objc func RandomCategoryGenerator() {
        print(222)
        quizModel.coreDataQuestionArrays.removeAll()
        for category in QuizModel.categories {
            fetchData(category, "questions")
        }
        quizModel.randCat = []
        let categoryNames = ["AlgebraCategory" , "FunkcjeCategory" , "TrygonometriaCategory" , "GeometriaCategory" , "PrawdopodobienstwoCategory"]
        for index in 0...4 {
            print("prosze: \(quizModel.coreDataQuestionArrays[index].count)")
            if quizModel.coreDataQuestionArrays[index].count > 0 {
                let categoryChecker = quizModel.defaults.bool(forKey: categoryNames[index])
                if categoryChecker == false {
                    quizModel.randCat.append(index)
                }
            }
        }
        quizView.question.removeFromSuperview()
        for index in 0...3 {
            quizView.button[index].removeFromSuperview()
        }
        if quizModel.randCat.count != 0 {
            quizModel.counts = 0
            randCategory = quizModel.randCat.randomElement()!
            print("kategoria nr: \(randCategory)")
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.quizModel.counts += 1
                print(self.quizModel.counts)
            }
            newQuestion()
        }
        else if quizModel.randCat.count == 0 && (quizModel.coreDataQuestionArrays[0].count > 0 || quizModel.coreDataQuestionArrays[1].count > 0 || quizModel.coreDataQuestionArrays[2].count > 0 || quizModel.coreDataQuestionArrays[3].count > 0 || quizModel.coreDataQuestionArrays[4].count > 0){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Brak wiecej pytań")
                self.view.sendSubviewToBack(self.quizView.nextButton)
                self.quizView.nextButton.isEnabled = false
                let dispbtnx = self.view.center.x
                let dispbtny = self.view.center.y
                self.quizView.question.layer.borderColor = Theme.current.mainColor.cgColor
                self.quizView.question.layer.borderWidth = 2.0
                self.quizView.question.textAlignment = .center
                self.quizView.question.latex = " Brak \\ wi\\ee cej \\ pyta \\nn  \\ z \\\\ wybranych \\ kategorii "
                self.view.addSubview(self.quizView.question)
            }
        }
        else if quizModel.randCat.count == 0 && quizModel.coreDataQuestionArrays[0].count == 0 && quizModel.coreDataQuestionArrays[1].count == 0 && quizModel.coreDataQuestionArrays[2].count == 0 && quizModel.coreDataQuestionArrays[3].count == 0 && quizModel.coreDataQuestionArrays[4].count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.sendSubviewToBack(self.quizView.nextButton)
                self.quizView.nextButton.isEnabled = false
                let dispbtnx = self.view.center.x
                let dispbtny = self.view.center.y
                self.quizView.question.frame = CGRect(x: 0, y: dispbtny, width: dispbtnx * 2, height: dispbtny/5)
                self.quizView.question.layer.borderColor = Theme.current.mainColor.cgColor
                self.quizView.question.layer.borderWidth = 2.0
                self.quizView.question.latex = "Koniec \\ Pytan"
                self.view.addSubview(self.quizView.question)
            }
        }
        print(quizModel.randCat)
    }
    func fetchData(_ entityName: String , _ attributeName: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try DatabaseController.getContext().fetch(request)
            for data in result as! [NSManagedObject] {
                if let text = data.value(forKey: attributeName) {
                    print(text)
                    self.quizModel.coreDataQuestionArrays.append(text as! [Int])
                    print(self.quizModel.coreDataQuestionArrays)
                }
            }
        }
        catch let error as NSError {
            print("Failed to fetch due to \(error), \(error.userInfo)")
        }
    }
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuView = storyboard.instantiateViewController(withIdentifier: "menuNavigation")
        self.navigationController?.revealViewController()?.pushFrontViewController(MenuView, animated: true)
        timer.invalidate()
    }
    @objc func clicked(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let formulasPage = storyboard.instantiateViewController(withIdentifier: "FormulasPageView")
        self.navigationController?.pushViewController(formulasPage, animated: true)
    }
    @objc func stoppingTheTimer(notification : NSNotification) {
        print("stop method called")
        timer.invalidate()
        UserDefaults.standard.set(quizModel.counts, forKey: "Stoper")
    }
    @objc func startingTheTimer(notification : NSNotification) {
        print("start method called")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.quizModel.counts += 1
            print(self.quizModel.counts)
        }
    }
}
