//
//  ContentView.swift
//  calculatorUI
//
//  Created by Sumit Chandora on 17/10/23.
//

import SwiftUI

class Numbers: ObservableObject {
    @Published var store = ""
    @Published var num = ""
    @Published var operation = ""
}

enum AllElements: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case plus = "+"
    case minus = "-"
    case multiply = "x"
    case divide = "÷"
    case percent = "%"
    case equal = "="
    case dot = "."
    case allClear = "C"
    case negativePositive = "-/+"
    var buttonColor: Color {
        switch self {
            case .allClear, .negativePositive, .percent:
            return Color(red: 0.65, green: 0.65, blue: 0.65)
        case .divide, .multiply, .minus, .plus, .equal:
            return Color(red: 1, green: 0.62, blue: 0.04)
        default:
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
    var buttonSize: CGFloat {
        switch self {
        case .zero:
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        default:
            return (UIScreen.main.bounds.width - (5*12)) / 4
        }
    }
    var buttonHeight: CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView: View {
    var allElements: [[AllElements]] = [[.allClear, .negativePositive, .percent, .divide], [.seven, .eight, .nine, .multiply], [.four, .five, .six, .minus], [.one, .two, .three, .plus], [.zero, .dot, .equal]]
    @EnvironmentObject var num: Numbers
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    if num.num.contains(".") || num.store.contains(".") {
                        let splitStore = num.store.split(separator: ".")
                        let splitNum = num.num.split(separator: ".")
                        if (splitStore.count > 1 && splitStore[1] == "0" && num.num == "") {
                            Text(String(Int(Float(num.store) ?? 0)))
                                .font(.system(size: 55))
                                .foregroundColor(.white)
                        } else if (splitNum.count > 1 && splitNum[1] == "0"){
                            Text(String(Int(Float(num.num) ?? 0)))
                                .font(.system(size: 55))
                                .foregroundColor(.white)
                        }
                        else {
                            Text((num.num != "") ? num.num : num.store)
                                .font(.system(size: 55))
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("\(Int(num.num) ??  (Int(num.store) ?? 0))")
                            .font(.system(size: 55))
                            .foregroundColor(.white)
                    }
                }
                ForEach(allElements, id: \.self){ outer in
                    HStack{
                        ForEach(outer, id: \.self){ inner in
                            Button(action: {
                                 allMethods(actions: inner)
                            }, label: {
                                Text("\(inner.rawValue)").foregroundStyle(.white)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .frame(width: inner.buttonSize, height: inner.buttonHeight)
                                    .background(inner.buttonColor)
                                    .cornerRadius(inner.buttonSize / 2)
                            })
                        }
                    }
                }
            }
        }
    }
    func allMethods(actions: AllElements) {
        switch actions {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            let wrapInt = actions.rawValue
            num.num = num.num + wrapInt
        case .allClear:
            num.num = ""
            num.store = ""
            num.operation = ""
        case .negativePositive:
            if (num.num != "" && num.num.split(separator: ".").count > 0) {
                num.num = "\((Float(num.num) ?? 0) * -1)"
            }
            else if (num.num != "" && num.num.split(separator: "").count == 0) {
                num.num = "\((Int(num.num) ?? 0) * -1)"
            }
            else {
                if num.store.split(separator: ".").count > 0 {
                    num.store =  String(Float(Int(num.store) ?? 0) * -1)
                }
                else {
                    num.store = String((Int(num.store) ?? 0) * -1)
                }
            }
        case .percent:
            num.operation = "%"
            by100()
        case .divide:
            if num.operation == "+" {
                addition()
            } else if num.operation == "-" {
                minus()
            } else if num.operation == "x" {
                multiply()
            } else {}
            num.operation = "÷"
            divide()
        case .multiply:
            if num.operation == "+" {
                addition()
            } else if num.operation == "-" {
                minus()
            } else if num.operation == "÷" {
                divide()
            } else {}
            num.operation = "x"
            multiply()
        case .minus:
            if num.operation == "+" {
                addition()
            } else if num.operation == "x" {
                multiply()
            } else if num.operation == "÷" {
                divide()
            } else {}
            num.operation = "-"
            minus()
        case .plus:
            if num.operation == "x" {
                multiply()
            } else if num.operation == "-" {
                minus()
            } else if num.operation == "÷" {
                divide()
            } else {}
            num.operation = "+"
            addition()
        case .dot:
            if num.num.filter({ $0 == "." }).count == 0 {
                num.num = num.num + "."
            }
        default:
            if num.operation == "+" {
                addition()
            } else if num.operation == "x"{
                multiply()
            } else if num.operation == "-"{
                minus()
            } else if num.operation == "÷" {
                divide()
            } else {
                by100()
            }
        }
    }
    func addition(){
        if num.num.contains(".") || num.store.contains(".") {
            num.store = String((Float(num.num) ?? 0) + (Float(num.store) ?? 0))
            num.num = ""
        } else {
            num.store = String((Int(num.num) ?? 0) + (Int(num.store) ?? 0))
            num.num = ""
        }
    }
    func multiply() {
        if num.num.contains(".") || num.store.contains(".") {
            num.store = String((Float(num.num) ?? 1) * (Float(num.store) ?? 1))
            num.num = ""
        } else {
            num.store = String((Int(num.num) ?? 1) * (Int(num.store) ?? 1))
            num.num = ""
        }
    }
    func minus(){
        if num.num.contains(".") || num.store.contains(".") {
            if num.store == "" {
                num.store = String((Float(num.num) ?? 0) - (Float(num.store) ?? 0))
                num.num = ""
            } else {
                num.store = String((Float(num.store) ?? 0) - (Float(num.num) ?? 0))
                num.num = ""
            }
        } else {
            if num.store == "" {
                num.store = String((Int(num.num) ?? 0) - (Int(num.store) ?? 0))
                num.num = ""
            } else {
                num.store = String((Int(num.store) ?? 0) - (Int(num.num) ?? 0))
                num.num = ""
            }
        }
    }
    func divide() {
            if num.store == "" {
                num.store = String((Float(num.num) ?? 0) / (Float(num.store) ?? 1))
                num.num = ""
            } else {
                num.store = String((Float(num.store) ?? 0) / (Float(num.num) ?? 1))
                num.num = ""
            }
    }
    func decimal() {
        if num.num.filter({ $0 == "." }).count == 0 {
            num.num = num.num + "."
        }
    }
    func by100() {
        if (num.num != "" && num.num.split(separator: ".").count > 0) {
            num.num = String((Float(num.num) ?? 0) / 100)
        } else if (num.num != "" && num.num.split(separator: ".").count == 0) {
            num.num = String(Int(Float(num.num) ?? 0) / 100)
        } else {
            if num.store.split(separator: ".").count > 0 {
                num.store = String((Float(num.store) ?? 0) / 100)
            } else {
                num.store = String((Int(num.store) ?? 0) / 100)
            }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
            .environmentObject(Numbers())
    }
}





