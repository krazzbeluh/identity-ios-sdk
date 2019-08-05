import Foundation
import Alamofire
import BrightFutures

extension DataRequest {
    
    private func parseJson<T: Decodable>(json: Data, type: T.Type, decoder: JSONDecoder) -> Swift.Result<T, ReachFiveError> {
        do {
            let value = try decoder.decode(type, from: json)
            return .success(value)
        } catch {
            return .failure(ReachFiveError.TechnicalError(reason: error.localizedDescription))
        }
    }
    
    func responseJson(decoder: JSONDecoder) -> Future<Void, ReachFiveError> {
        let promise = BrightFutures.Promise<Void, ReachFiveError>()
        self.responseString { responseData in
            let status = responseData.response?.statusCode
            if let data = responseData.data {
                if (status != nil && status! == 400) {
                    switch self.parseJson(json: data, type: RequestErrors.self, decoder: decoder) {
                    case .success(let requestErrors):
                        promise.failure(ReachFiveError.RequestError(requestErrors: requestErrors))
                    case .failure(let error):
                        promise.failure(ReachFiveError.TechnicalError(reason: error.localizedDescription))
                        
                    }
                }
            } else {
                promise.failure(ReachFiveError.TechnicalError(reason: "No response data"))
            }
        }
        return promise.future
    }
    
    func responseJson<T: Decodable>(type: T.Type, decoder: JSONDecoder) -> Future<T, ReachFiveError> {
        let promise = BrightFutures.Promise<T, ReachFiveError>()
        
        self.responseString { responseData in
            let status = responseData.response?.statusCode
            if let data = responseData.data {
                if (status != nil && status! >= 200 && status! < 300) {
                    let value = self.parseJson(json: data, type: type, decoder: decoder)
                    promise.complete(value)
                } else if (status != nil && status! == 400) {
                    switch self.parseJson(json: data, type: RequestErrors.self, decoder: decoder) {
                    case .success(let requestErrors):
                        promise.failure(ReachFiveError.RequestError(requestErrors: requestErrors))
                    case .failure(let error):
                        promise.failure(ReachFiveError.TechnicalError(reason: error.localizedDescription))
                        
                    }
                }
            } else {
                promise.failure(ReachFiveError.TechnicalError(reason: "No response data"))
            }
        }
        
        return promise.future
    }
}
