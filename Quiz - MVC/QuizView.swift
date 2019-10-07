import UIKit
import iosMath
class QuizView: UIView {
    var label:[UILabel] = [UILabel(),UILabel(),UILabel(),UILabel()]
    var answearLabel:[MTMathUILabel] = [MTMathUILabel(),MTMathUILabel(),MTMathUILabel(),MTMathUILabel()]
    var button:[UIButton] = [UIButton(),UIButton(),UIButton(),UIButton()]
    let question: MTMathUILabel = {
        let lbl = MTMathUILabel()
        lbl.backgroundColor = Theme.current.mainColor
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        return lbl
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.backgroundColor = UIColor(red: 193, green: 202, blue: 192, alpha: 0)
        return button
    }()
    var boardButton = UIButton()
    var calculatorButton = UIButton()
    func createButton(view: UIView , xPosition: CGFloat, yPosition: CGFloat, width1 : CGFloat, height1 : CGFloat, i: Int) {
        let text = ["A" , "B" , "C" , "D"]
        button[i] = {
            let button = UIButton()
            button.backgroundColor = Theme.current.ButtonsBackColor
            button.tag = i + 1
            return button
        }()
        label[i] = {
            let lbl = UILabel()
            lbl.textAlignment = .left
            lbl.text = text[i]
            lbl.font = UIFont.boldSystemFont(ofSize: 24)
            lbl.textColor = Theme.current.mainColor
            return lbl
        }()
        button[i].frame = CGRect(x: xPosition, y: yPosition , width: width1, height: height1)
        button[i].layer.cornerRadius = height1/2
        view.addSubview(button[i])
        label[i].frame = CGRect(x: xPosition, y: 0, width: width1 - xPosition, height: height1)
        button[i].addSubview(label[i])
        answearLabel[i].frame = CGRect(x: xPosition * 3 / 2, y: 0, width: width1 - xPosition, height: height1)
        UIDevice.current.userInterfaceIdiom == .phone ?( answearLabel[i].fontSize = 14 ): (answearLabel[i].fontSize = 26)
        answearLabel[i].textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label[i].addSubview(answearLabel[i])
    }
    func createLogoImage() -> UIImageView {
        let imageViewLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        imageViewLogo.contentMode = .scaleAspectFit
        let imageLogo = UIImage(named: "path2936.png")
        imageViewLogo.image = imageLogo
        return imageViewLogo
    }
    func createMenuButton(vc: UIViewController) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menu-2"), for: UIControl.State.normal)
        button.widthAnchor.constraint(equalToConstant: 23).isActive = true
        button.heightAnchor.constraint(equalToConstant: 23).isActive = true
        button.addTarget(vc.revealViewController(), action: #selector(SWRevealViewController().revealToggle(_:)), for: .touchUpInside)
        let menuBtn = UIBarButtonItem(customView: button)
        return menuBtn
    }
    func createBoardButton(vc: UIViewController) -> UIBarButtonItem {
        boardButton = UIButton(type: .custom)
        boardButton.translatesAutoresizingMaskIntoConstraints = false
        boardButton.setImage(UIImage(named: "board"), for: UIControl.State.normal)
        boardButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        boardButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        let boardBtn = UIBarButtonItem(customView: boardButton)
        return boardBtn
    }
    func createCalculator(vc: UIViewController) -> [UIBarButtonItem] {
        calculatorButton = UIButton(type: .custom)
        calculatorButton.layer.cornerRadius = 2.0
        calculatorButton.translatesAutoresizingMaskIntoConstraints = false
        calculatorButton.setImage(UIImage(named: "calculator"), for: UIControl.State.normal)
        calculatorButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
        calculatorButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        let menuBtn = UIBarButtonItem(customView: calculatorButton)
        let buttons = [menuBtn , createBoardButton(vc: vc)]
        return buttons
    }
}
