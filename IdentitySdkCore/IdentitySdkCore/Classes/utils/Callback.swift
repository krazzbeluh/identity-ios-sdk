import Foundation

public typealias Callback<T, E: Error> = (Result<T, E>) -> Void
