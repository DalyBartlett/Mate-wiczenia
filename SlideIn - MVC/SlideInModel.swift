import Foundation
import CoreData
class SlideInModel
{
    struct cellData {
        var opened = Bool()
        var title = String()
        var sectionData = [String]()
    }
    var opcje = [cellData]()
    let titles = ["Menu Główne", "Ucz się!", "Wzory Maturalne","Motywy", "Statystyki","Kategorie", "Feedback", "O Nas", "Wyzeruj"]
    let sectionsData = [[] , [] , [] , [] , [] , ["Algebra" , "Funkcje" , "Trygonometria" , "Geometria" , "Prawdopodobienstwo"] , [] , [] , []]
    let picturesName = ["menu" , "books-stack-of-three" , "blackboard" , "artistic-brush" , "data-pie-chart" , "list" , "feedback" , "multiple-users-silhouette" , "delete-button" , "function-mathematical-symbol" , "maths-2" , "mathematics" , "cube" , "dice"]
    let goodCounterStrings = ["AgoodAnswerCounter" , "FgoodAnswerCounter" , "TgoodAnswerCounter" , "GgoodAnswerCounter" , "PgoodAnswerCounter"]
    let badCounterStrings = ["AbadAnswerCounter" , "FbadAnswerCounter" , "TbadAnswerCounter" , "GbadAnswerCounter" , "PbadAnswerCounter"]
    let userDefaultsCategory = ["AlgebraCategory" , "FunkcjeCategory" , "TrygonometriaCategory" , "GeometriaCategory" , "PrawdopodobienstwoCategory"]
    var coreDataQuestionArrays: [Array<Int>] = []
    var result1: [Array<String>] = []
    var result2: [Array<String>] = []
    var result3: [Array<String>] = []
    var result4: [Array<String>] = []
    var result5: [Array<String>] = []
    var results: [Array<Array<String>>] = [[[]]]
    init() {
        createOptionsData()
    }
    func createOptionsData() {
        for index in 0 ..< titles.count {
            opcje.append(cellData(opened: false, title: titles[index], sectionData: sectionsData[index]))
        }
    }
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    func generatorPytan(_ kategoria: String) {
        odczyt()
        if kategoria == sectionsData[5][0] {
            let losowanie = GenerateRandomNumbers(1, results[0].count, (results[0].count - 1))
            DatabaseController.saveToCoreData(entityName: "Algebra", questions: losowanie)
        }
        else if kategoria == sectionsData[5][1] {
            let losowanie = GenerateRandomNumbers(1, results[1].count, (results[1].count - 1))
            DatabaseController.saveToCoreData(entityName: "Funkcje", questions: losowanie)
        }
        else if kategoria == sectionsData[5][2] {
            let losowanie = GenerateRandomNumbers(1, results[2].count, (results[2].count - 1))
            DatabaseController.saveToCoreData(entityName: "Trygonometria", questions: losowanie)
        }
        else if kategoria == sectionsData[5][3] {
            let losowanie = GenerateRandomNumbers(1, results[3].count, (results[3].count - 1))
            DatabaseController.saveToCoreData(entityName: "Geometria", questions: losowanie)
        }
        else if kategoria == sectionsData[5][4] {
            let losowanie = GenerateRandomNumbers(1, results[4].count, (results[4].count - 1))
            DatabaseController.saveToCoreData(entityName: "Prawdopodobienstwo", questions: losowanie)
        }
    }
    func odczyt() {
        results = [result1 , result2 , result3 , result4 , result5]
        for kategoria in sectionsData[5] {
            let fileURL = Bundle.main.path(forResource: kategoria, ofType: "txt")
            var readString = ""
            do {
                readString = try String(contentsOfFile: fileURL! , encoding: String.Encoding.utf8)
                let myStrings = readString.components(separatedBy: "\n")
                for row in myStrings {
                    let columns = row.components(separatedBy: "#")
                    if kategoria == sectionsData[5][0] {
                        results[0].append(columns)
                    }
                    else if kategoria == sectionsData[5][1] {
                        results[1].append(columns)
                    }
                    else if kategoria == sectionsData[5][2] {
                        results[2].append(columns)
                    }
                    else if kategoria == sectionsData[5][3] {
                        results[3].append(columns)
                    }
                    else if kategoria == sectionsData[5][4] {
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
