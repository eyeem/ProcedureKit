//
//  ProcedureKit
//
//  Copyright © 2016 ProcedureKit. All rights reserved.
//

import Foundation

public protocol ProcedureProcotol: class {

    var procedureName: String { get }

    var isExecuting: Bool { get }

    var isFinished: Bool { get }

    var isCancelled: Bool { get }

    var errors: [Error] { get }

    var log: LoggerProtocol { get }

    // Execution

    func willEnqueue()

    func execute()

    func produce(operation: Operation)

    // Cancelling

    func cancel(withErrors: [Error])

    func procedureWillCancel(withErrors: [Error])

    func procedureDidCancel(withErrors: [Error])

    // Finishing

    func finish(withErrors: [Error])

    func procedureWillFinish(withErrors: [Error])

    func procedureDidFinish(withErrors: [Error])

    // Observers

    func add<Observer: ProcedureObserver>(observer: Observer) where Observer.Procedure == Self

    // Dependencies

    func add<Dependency: ProcedureProcotol>(dependency: Dependency)
}

public extension ProcedureProcotol {

    var failed: Bool {
        return errors.count > 0
    }

    func cancel(withError error: Error?) {
        cancel(withErrors: error.map { [$0] } ?? [])
    }

    func procedureWillCancel(withErrors: [Error]) { }

    func procedureDidCancel(withErrors: [Error]) { }

    func finish(withError error: Error? = nil) {
        finish(withErrors: error.map { [$0] } ?? [])
    }

    func procedureWillFinish(withErrors: [Error]) { }

    func procedureDidFinish(withErrors: [Error]) { }

}
