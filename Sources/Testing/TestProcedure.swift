//
//  ProcedureKit
//
//  Copyright © 2016 ProcedureKit. All rights reserved.
//

import Foundation
import ProcedureKit

public struct TestError: Error, Equatable {
    public static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    public static func verify(errors: [Error], count: Int = 1, contains error: TestError) -> Bool {
        return (errors.count == count) && errors.contains { ($0 as? TestError) ?? TestError() == error }
    }

    let uuid = UUID()
    public init() { }
}

open class TestProcedure: Procedure, ResultInjectionProtocol {

    public let delay: TimeInterval
    public let error: Error?
    public let producedOperation: Operation?
    public var requirement: Void = ()
    public var result: String? = "Hello World"
    public private(set) var didExecute = false
    public private(set) var procedureWillFinishCalled = false
    public private(set) var procedureDidFinishCalled = false
    public private(set) var procedureWillCancelCalled = false
    public private(set) var procedureDidCancelCalled = false

    public init(name: String = "Test Procedure", delay: TimeInterval = 0.000_001, error: Error? = .none, produced: Operation? = .none) {
        self.delay = delay
        self.error = error
        self.producedOperation = produced
        super.init()
        self.name = name
    }

    open override func execute() {

        if let operation = producedOperation {
            let deadline = DispatchTime(uptimeNanoseconds: UInt64(delay * 0.001 * Double(NSEC_PER_SEC)))
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.produce(operation: operation)
            }
        }

        let deadline = DispatchTime(uptimeNanoseconds: UInt64(delay * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.didExecute = true
            self.finish(withError: self.error)
        }
    }

    open override func procedureWillCancel(withErrors: [Error]) {
        procedureWillCancelCalled = true
    }

    open override func procedureDidCancel(withErrors: [Error]) {
        procedureDidCancelCalled = true
    }

    open override func procedureWillFinish(withErrors: [Error]) {
        procedureWillFinishCalled = true
    }

    open override func procedureDidFinish(withErrors: [Error]) {
        procedureDidFinishCalled = true
    }
}
