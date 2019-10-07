import Foundation
enum Optional<T> {
    case None
    case Some(T)
}
class CalculatorModel
{
    private var accumulator = 0.0
    var result: Double {
        get {
            return accumulator
        }
    }
    private var operations: Dictionary<String,Operation> = [
        "×"  : Operation.BinaryOperation({ $0 * $1 }),
        "÷"  : Operation.BinaryOperation({ $0 / $1 }),
        "+"  : Operation.BinaryOperation({ $0 + $1 }),
        "-"  : Operation.BinaryOperation({ $0 - $1 }),
        "±"  : Operation.UnaryOperation({ -$0 }),
        "√"  : Operation.UnaryOperation(sqrt),
        "%"  : Operation.UnaryOperation({ $0/100 }),
        "C"  : Operation.Constant(0.0),
        "="  : Operation.Equals
    ]
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double , Double) -> Double)
        case Equals
    }
    func setOperand(operand: Double) {
        accumulator = operand
    }
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function): pending = PendingBinaryOperationInfo(binaryFounction: function, firstOperand: accumulator)
            case .Equals:
                if pending != nil {
                    accumulator = pending!.binaryFounction(pending!.firstOperand , accumulator)
                    pending = nil
                }
            }
        }
    }
    private var pending: PendingBinaryOperationInfo?
    private struct PendingBinaryOperationInfo {
        var binaryFounction: (Double,Double) -> Double
        var firstOperand: Double
    }
}
