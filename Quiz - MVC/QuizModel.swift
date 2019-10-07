import Foundation
import CoreData
class QuizModel
{
    init() {
    }
    let defaults = UserDefaults.standard
    var coreDataQuestionArrays: [Array<Int>] = []
    var randCat: [Int] = []
    var result1: [Array<String>] = []
    var result2: [Array<String>] = []
    var result3: [Array<String>] = []
    var result4: [Array<String>] = []
    var result5: [Array<String>] = []
    var results: [Array<Array<String>>] = [[[]]]
    static let categories = ["Algebra" , "Funkcje" , "Trygonometria" , "Geometria" , "Prawdopodobienstwo"]
    static let goodCounterStrings = ["AgoodAnswerCounter" , "FgoodAnswerCounter" , "TgoodAnswerCounter" , "GgoodAnswerCounter" , "PgoodAnswerCounter"]
    static let badCounterStrings = ["AbadAnswerCounter" , "FbadAnswerCounter" , "TbadAnswerCounter" , "GbadAnswerCounter" , "PbadAnswerCounter"]
    var counts: Int16 = Int16(UserDefaults.standard.integer(forKey: "Stoper"))
    func odczyt() {
        results = [result1 , result2 , result3 , result4 , result5]
        for kategoria in QuizModel.categories {
            let fileURL = Bundle.main.path(forResource: kategoria, ofType: "txt")
            var readString = ""
            do {
                readString = try String(contentsOfFile: fileURL! , encoding: String.Encoding.utf8)
                let myStrings = readString.components(separatedBy: "\n")
                for row in myStrings {
                    let columns = row.components(separatedBy: "#")
                    if kategoria == QuizModel.categories[0] {
                        results[0].append(columns)
                    }
                    else if kategoria == QuizModel.categories[1] {
                        results[1].append(columns)
                    }
                    else if kategoria == QuizModel.categories[2] {
                        results[2].append(columns)
                    }
                    else if kategoria == QuizModel.categories[3] {
                        results[3].append(columns)
                    }
                    else if kategoria == QuizModel.categories[4] {
                        results[4].append(columns)
                    }
                }
            }
            catch let error as NSError {
                print("failed to read from file bazapytan")
                print(error)
            }
        }
    }
    func randomNumber(range: ClosedRange<Int> = 0...4) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    func GenerateRandomNumbers(_ from: Int, _ to: Int, _ howmany: Int?) -> [Int] {
        var myRandomNumbers: [Int] = []
        var numberOfNumbers = howmany
        let lower = UInt32(from)
        let higher = UInt32(to)
        if numberOfNumbers == nil || numberOfNumbers! > (to - from) + 1 {
            numberOfNumbers = (to - from) + 1
        }
        while myRandomNumbers.count != numberOfNumbers {
            let myNumber = arc4random_uniform(higher - lower) + lower
            if !myRandomNumbers.contains(Int(myNumber)) {
                myRandomNumbers.append(Int(myNumber))
            }
        }
        return myRandomNumbers
    }
}
