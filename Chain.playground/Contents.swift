import Foundation
/// 责任链协议
protocol Chain {
    /// 定义是否合理的方法，由具体的责任链实体实现
    func isValidate() -> Bool
    /// 定义id，区分不同的责任链，用于提示等
    func getIdentifier() -> String
    /// 获取下一个责任链实体
    func getNextChain() -> Chain?
    /// 实际操作过程
    func request(_ completion: (_ error: NSError?) -> (Void))
}
/// 默认实现
extension Chain {
    func request(_ completion: (_ error: NSError?) -> (Void)) {
        if !self.isValidate() {
            // 不满足条件，抛出错误
            let msg = "error: \(self.getIdentifier()) is empty"
            let error = NSError.init(domain: "", code: 1, userInfo: ["msg" : msg])
            completion(error)
            return
        }
        if let c = self.getNextChain() {
            c.request { completion($0) }
        } else {
            // 此时表示责任链执行完成
            let error = NSError.init(domain: "", code: 0, userInfo: ["msg" : "No error, and this is the last Chain"])
            completion(error)
        }
    }
}

/// 用户名
class NameChain {
    var chain: Chain?
}
extension NameChain: Chain {
    func isValidate() -> Bool {
        // 此处省略一些判断逻辑
        return true
    }
    func getNextChain() -> Chain? {
        return self.chain
    }
    func getIdentifier() -> String {
        return "name"
    }
}

/// 手机号
class PhoneChain {
    var chain: Chain?
}
extension PhoneChain: Chain {
    func isValidate() -> Bool {
        // 此处省略一些判断逻辑
        return true
    }
    func getNextChain() -> Chain? {
        return self.chain
    }
    func getIdentifier() -> String {
        return "phone"
    }
}

/// 头部实体
class Head {
    var chain: Chain?
}
extension Head: Chain {
    func isValidate() -> Bool {
        return true
    }
    func getNextChain() -> Chain? {
        return self.chain
    }
    func getIdentifier() -> String {
        return "Head"
    }
}

let head = Head.init()
let name = NameChain.init()
let phone = PhoneChain.init()

head.chain = name
name.chain = phone

head.request {
    if let error = $0 {
        if (error.code == 0) {
            // 成功，执行业务逻辑
        }
        else {
            // 失败，执行业务逻辑
        }
        print(error)
    } else {
        // 此处省略业务逻辑
        print("no error")
    }
}
