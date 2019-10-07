import UIKit
class MainScreenViewController: UIViewController {
    var mainScreenView: MainScreenView!
    var mainScreenModel = MainScreenModel()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureController()
        if mainScreenModel.isQuizStartedAlready() {
            mainScreenView.setupLayout(goodAnswears: mainScreenModel.goodanswears , view: self.view)
            if Int(round(mainScreenModel.goodanswears * 100))  == 0 || Int(round(mainScreenModel.goodanswears * 100))  == 100 {
                UIView.animate(withDuration: 1, delay: 2.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.mainScreenView.label1.alpha = 1
                    self.mainScreenView.label3.alpha = 1
                }) {(_)  in
                }
            }
            else {
                UIView.animate(withDuration: 1, delay: 1.5 + 2 * mainScreenModel.goodanswears, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.mainScreenView.label1.alpha = 1
                    self.mainScreenView.label3.alpha = 1
                }) {(_)  in
                }
            }
            UIView.animate(withDuration: 1, delay: 3.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.mainScreenView.label2.alpha = 1
                self.mainScreenView.label4.alpha = 1
            })
        } else {
            mainScreenView.createBeginText(view: self.view)
        }
    }
    func configureController() {
        view.backgroundColor = Theme.current.mainColor
        mainScreenView = MainScreenView(frame: CGRect.zero)
        mainScreenView.createEssentials(view: view)
        mainScreenView.Startbutton.addTarget(self, action: #selector(buttonStart), for: .touchUpInside)
        self.navigationItem.titleView = mainScreenView.createLogoImage()
        if revealViewController()  != nil {
            self.navigationItem.leftBarButtonItem = mainScreenView.createMenuButton(vc: self)
            self.view.addGestureRecognizer((revealViewController()?.panGestureRecognizer())!)
        }
    }
    @objc func buttonStart(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let QuizPage: UIViewController = storyboard.instantiateViewController(withIdentifier: "QuizView")
        self.navigationController?.revealViewController()?.pushFrontViewController(QuizPage, animated: true)
    }
}
