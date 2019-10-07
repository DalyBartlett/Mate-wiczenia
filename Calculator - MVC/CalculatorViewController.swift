import UIKit
class CalculatorViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var showLabel: UILabel!
    var userIsInTheMiddleOfTyping = false
    private var calculatorModel = CalculatorModel()
    var displayValue: Double {
        get {
            return Double(showLabel.text!)!
        }
        set {
            showLabel.text = String(newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        setSliderWidth()
    }
    @IBAction func numberDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let currentlyTextInDisplay = showLabel!.text!
            showLabel.text = currentlyTextInDisplay + digit
            print(digit)
        } else {
            showLabel.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    @IBAction func performOperand(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            calculatorModel.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            calculatorModel.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = calculatorModel.result
    }
    func setSliderWidth() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.revealViewController()?.rightViewRevealWidth = self.view.center.x*2*85/100
        }
        else if UIDevice.current.userInterfaceIdiom == .pad{
            self.revealViewController()?.rightViewRevealWidth = self.view.center.x*2*5/10
        }
    }
}
