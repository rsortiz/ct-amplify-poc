//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import AWSPluginsCore
import Foundation

final public class AWSGraphQLOperation<R: Decodable>: GraphQLOperation<R> {

    let session: URLSessionBehavior
    let mapper: OperationTaskMapper
    let pluginConfig: AWSAPICategoryPluginConfiguration
    let graphQLResponseDecoder: GraphQLResponseDecoder<R>

    init(request: GraphQLOperationRequest<R>,
         session: URLSessionBehavior,
         mapper: OperationTaskMapper,
         pluginConfig: AWSAPICategoryPluginConfiguration,
         resultListener: AWSGraphQLOperation.ResultListener?) {

        self.session = session
        self.mapper = mapper
        self.pluginConfig = pluginConfig
        self.graphQLResponseDecoder = GraphQLResponseDecoder(request: request)

        super.init(categoryType: .api,
                   eventName: request.operationType.hubEventName,
                   request: request,
                   resultListener: resultListener)
    }

    // swiftlint:disable:next cyclomatic_complexity
    override public func main() {
        Amplify.API.log.debug("Starting \(request.operationType) \(id)")

        if isCancelled {
            finish()
            return
        }

        // Validate the request
        do {
            try request.validate()
        } catch let error as APIError {
            dispatch(result: .failure(error))
            finish()
            return
        } catch {
            dispatch(result: .failure(APIError.unknown("Could not validate request", "", nil)))
            finish()
            return
        }

        // Retrieve endpoint configuration
        let endpointConfig: AWSAPICategoryPluginConfiguration.EndpointConfig
        let requestInterceptors: [URLRequestInterceptor]

        do {
            endpointConfig = try pluginConfig.endpoints.getConfig(for: request.apiName, endpointType: .graphQL)

            if let pluginOptions = request.options.pluginOptions as? AWSPluginOptions,
               let authType = pluginOptions.authType {
                requestInterceptors = try pluginConfig.interceptorsForEndpoint(withConfig: endpointConfig,
                                                                               authType: authType)
            } else {
                requestInterceptors = try pluginConfig.interceptorsForEndpoint(withConfig: endpointConfig)
            }
        } catch let error as APIError {
            dispatch(result: .failure(error))
            finish()
            return
        } catch {
            dispatch(result: .failure(APIError.unknown("Could not get endpoint configuration", "", nil)))
            finish()
            return
        }

        // Prepare request payload
        let queryDocument = GraphQLOperationRequestUtils.getQueryDocument(document: request.document,
                                                                          variables: request.variables)
        if Amplify.API.log.logLevel == .verbose,
           let serializedJSON = try? JSONSerialization.data(withJSONObject: queryDocument,
                                                            options: .prettyPrinted),
           let prettyPrintedQueryDocument = String(data: serializedJSON, encoding: .utf8) {
            Amplify.API.log.verbose("\(prettyPrintedQueryDocument)")
        }
        let requestPayload: Data
        do {
            requestPayload = try JSONSerialization.data(withJSONObject: queryDocument)
        } catch {
            dispatch(result: .failure(APIError.operationError("Failed to serialize query document",
                                                              "fix the document or variables",
                                                              error)))
            finish()
            return
        }

        // Create request
        let urlRequest = GraphQLOperationRequestUtils.constructRequest(
            with: endpointConfig.baseURL,
            requestPayload: requestPayload)

        // Intercept request
        chainInterceptors(iterator: requestInterceptors.makeIterator(),
                          request: urlRequest) { finalRequest in
            if self.isCancelled {
                self.finish()
                return
            }

            // Begin network task
            Amplify.API.log.debug("Starting network task for \(self.request.operationType) \(self.id)")
            let task = self.session.dataTaskBehavior(with: finalRequest)
            self.mapper.addPair(operation: self, task: task)
            task.resume()
        }
    }

    private func chainInterceptors<I: IteratorProtocol>(
        iterator: I,
        request: URLRequest,
        completion: @escaping (URLRequest) -> Void
    ) where I.Element == URLRequestInterceptor {

        if isCancelled {
            completion(request)
            return
        }

        var mutableIterator = iterator
        guard let interceptor = mutableIterator.next() else {
            completion(request)
            return
        }
        interceptor.intercept(request) { result in
            do {
                let interceptedRequest = try result.get()
                self.chainInterceptors(
                    iterator: mutableIterator,
                    request: interceptedRequest,
                    completion: completion)
                return
            } catch let error as APIError {
                self.dispatch(result: .failure(error))
                self.cancel()
                completion(request)
                return
            } catch {
                self.dispatch(result: .failure(
                    APIError.operationError("Failed to intercept request fully.",
                                            "Something wrong with the interceptor",
                                            error)))
                self.cancel()
                completion(request)
                return
            }

        }
    }
}
