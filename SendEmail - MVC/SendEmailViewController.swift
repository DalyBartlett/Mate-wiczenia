import UIKit
import WebKit
class SendEmailViewController: UIViewController {
    var sendEmailView = SendEmailView()
    private var webView:WKWebView = WKWebView()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureController()
    }
    func configureController() {
        view.backgroundColor = Theme.current.mainColor
        webView = WKWebView.init(frame: CGRect.init(x: 0, y: 44, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 44))
        webView.load(URLRequest(url: URL(string: "http://www.solvedapps.pl")!))
        self.view.addSubview(webView)
        self.navigationItem.titleView = sendEmailView.createLogoImage()
        if revealViewController()  != nil {
            self.navigationItem.leftBarButtonItem = sendEmailView.createMenuButton(vc: self)
            self.view.addGestureRecognizer((revealViewController()?.panGestureRecognizer())!)
        }
    }
}
