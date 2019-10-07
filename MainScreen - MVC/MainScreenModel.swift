import Foundation
import CoreData
class MainScreenModel
{
    let AbadAnswerCounter = UserDefaults.standard.integer(forKey: "AbadAnswerCounter")
    let AgoodAnswerCounter = UserDefaults.standard.integer(forKey: "AgoodAnswerCounter")
    let FgoodAnswerCounter = UserDefaults.standard.integer(forKey: "FgoodAnswerCounter")
    let FbadAnswerCounter = UserDefaults.standard.integer(forKey: "FbadAnswerCounter")
    let TgoodAnswerCounter = UserDefaults.standard.integer(forKey: "TgoodAnswerCounter")
    let TbadAnswerCounter = UserDefaults.standard.integer(forKey: "TbadAnswerCounter")
    let GgoodAnswerCounter = UserDefaults.standard.integer(forKey: "GgoodAnswerCounter")
    let GbadAnswerCounter = UserDefaults.standard.integer(forKey: "GbadAnswerCounter")
    let PgoodAnswerCounter = UserDefaults.standard.integer(forKey: "PgoodAnswerCounter")
    let PbadAnswerCounter = UserDefaults.standard.integer(forKey: "PbadAnswerCounter")
    var gooodAnswersNanChecker = Double()
    var goodanswears = Double()
    init() {
    }
    func isQuizStartedAlready() -> Bool {
        gooodAnswersNanChecker = Double(AgoodAnswerCounter + FgoodAnswerCounter + TgoodAnswerCounter + GgoodAnswerCounter + PgoodAnswerCounter) / Double(AgoodAnswerCounter + FgoodAnswerCounter + TgoodAnswerCounter + GgoodAnswerCounter + PgoodAnswerCounter + AbadAnswerCounter + FbadAnswerCounter + TbadAnswerCounter + GbadAnswerCounter + PbadAnswerCounter)
        if gooodAnswersNanChecker.isNaN == true {
            gooodAnswersNanChecker = 0
            return false
        }
        else {
            goodanswears = Double(gooodAnswersNanChecker)
            return true
        }
    }
}
