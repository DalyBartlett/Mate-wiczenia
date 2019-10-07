import UIKit
import CoreData
import MessageUI
class SlideInViewController: UIViewController, MFMailComposeViewControllerDelegate {
    let mvcs = ["menuNavigation" , "QuizView" , "FormulasView" , "" , "Statystyki" , "" , "" , "AboutUs" , ""]
    let defaults = UserDefaults.standard
    fileprivate let slideInModel = SlideInModel()
    @IBOutlet weak var slideInTableView: UITableView? { didSet {
        slideInTableView?.delegate = self
        slideInTableView?.dataSource = self
        }}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.current.mainColor
        slideInTableView?.backgroundColor = Theme.current.mainColor
        slideInTableView?.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        setSliderWidth()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    func setSliderWidth() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.revealViewController()?.rearViewRevealWidth = self.view.center.x*2*8/10
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            self.revealViewController()?.rearViewRevealWidth = self.view.center.x*2*5/10
        }
    }
    func deleteDataAction() {
        let alertController = UIAlertController(title: "Czy na pewno chcesz usunąć wszystkie zapisane dane oraz postępy ?", message: "Uwaga! Cały twój dotychczasowy postęp zostanie usunięty bez mozliwości odzyskania!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Wyzeruj", style: UIAlertAction.Style.destructive, handler: { action in
            DatabaseController.clearCoreDataStore()
            for index in 0...4 {
                self.defaults.removeObject(forKey: self.slideInModel.goodCounterStrings[index])
                self.defaults.removeObject(forKey: self.slideInModel.badCounterStrings[index])
            }
            self.defaults.synchronize()
            self.slideInModel.result1.removeAll()
            self.slideInModel.result2.removeAll()
            self.slideInModel.result3.removeAll()
            self.slideInModel.result4.removeAll()
            self.slideInModel.result5.removeAll()
            for kategoria in self.slideInModel.sectionsData[5] {
                self.slideInModel.generatorPytan(kategoria)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "menuNavigation")
            self.navigationController?.revealViewController()?.pushFrontViewController(vc, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Anuluj", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    func initMail(subject: String, to: String) -> MFMailComposeViewController {
             let mailto = MFMailComposeViewController()
             mailto.mailComposeDelegate = self
             mailto.setSubject(subject)
             mailto.setToRecipients([to])
             let df = DateFormatter()
             let now = Date()
             mailto.setMessageBody("\n\n"+df.string(from: now), isHTML: false)
             return mailto
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension SlideInViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = slideInTableView?.dequeueReusableCell(withIdentifier: slideInModel.titles[indexPath.section]) as? BasicTableViewCell {
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.row != 0 && indexPath.row < 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.slideInModel.sectionsData[5][indexPath.row - 1]) else { return UITableViewCell()}
            cell.selectionStyle = .none
            let tickView = UIImageView(image: UIImage(named: "tick"), highlightedImage: nil) as UIImageView
            cell.accessoryView = tickView
            cell.accessoryView?.isHidden = defaults.bool(forKey: slideInModel.userDefaultsCategory[indexPath.row - 1])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.slideInModel.opcje.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if slideInModel.opcje[section].opened == true {
            return self.slideInModel.opcje[section].sectionData.count + 1
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.center.y * 2 * 11 / 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if slideInModel.opcje[indexPath.section].opened == true {
                slideInModel.opcje[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                slideInModel.opcje[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 4 || indexPath.section == 7 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: mvcs[indexPath.section])
                self.navigationController?.revealViewController()?.pushFrontViewController(vc, animated: true)
            } else if indexPath.section == 3 {
                if Theme.current == .default {
                    if let selectedTheme = Theme(rawValue: Theme.dark.rawValue) {
                        selectedTheme.apply()
                    }
                    let windows = UIApplication.shared.windows
                    for window in windows {
                        for view in window.subviews {
                            view.removeFromSuperview()
                            window.addSubview(view)
                        }
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: mvcs[0])
                    revealViewController()?.setFront(vc, animated: false)
                    let rearReload = storyboard.instantiateViewController(withIdentifier: "navslideIn")
                    revealViewController()?.setRear(rearReload, animated: false)
                } else if Theme.current == .dark {
                    if let selectedTheme = Theme(rawValue: Theme.default.rawValue) {
                        selectedTheme.apply()
                    }
                    let windows = UIApplication.shared.windows
                    for window in windows {
                        for view in window.subviews {
                            view.removeFromSuperview()
                            window.addSubview(view)
                        }
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: mvcs[0])
                    revealViewController()?.setFront(vc, animated: false)
                    let rearReload = storyboard.instantiateViewController(withIdentifier: "navslideIn")
                    revealViewController()?.setRear(rearReload, animated: false)
                }
            } else if indexPath.section == 6 {
                let alert = UIAlertController(title: "Napisz do nas lub oceń aplikację w App Store", message: "W razie jakichkolwiek błędów powiadom Nas, żeby Twoja aplikacja działała lepiej", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Napisz Maila", style: .default) { (action:UIAlertAction!) in
                    let mailvc = self.initMail(subject: "Opinie o aplikacji", to: "melodyseanrpe@gmail.com")
                    if !MFMailComposeViewController.canSendMail() {
                    }
                    else {
                        self.present(mailvc, animated: true)
                    }
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "sendEmail")
//                    self.navigationController?.revealViewController()?.pushFrontViewController(vc, animated: true)
                })
                alert.addAction(UIAlertAction(title: "Oceń Nas", style: .default) { (action:UIAlertAction!) in
                    self.slideInModel.rateApp(appId: "id1482604631") { success in
                        print("RateApp \(success)")
                    }
                })
                alert.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            } else if indexPath.section == 8 {
                deleteDataAction()
            }
        }
        else if indexPath.row != 0 {
            if defaults.bool(forKey: slideInModel.userDefaultsCategory[indexPath.row - 1]) == false {
                defaults.set(true, forKey: slideInModel.userDefaultsCategory[indexPath.row - 1])
                tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = true
                defaults.synchronize()
            }
            else if defaults.bool(forKey: slideInModel.userDefaultsCategory[indexPath.row - 1]) == true {
                defaults.set(false, forKey: slideInModel.userDefaultsCategory[indexPath.row - 1])
                tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
                defaults.synchronize()
            }
        }
     
}
    
}
extension SlideInViewController: UITableViewDelegate {
}
