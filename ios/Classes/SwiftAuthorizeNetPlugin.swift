import Flutter
import UIKit
import AuthorizeNetAccept

public class SwiftAuthorizeNetPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "authorize_net_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftAuthorizeNetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "authorizeNetToken"){
        let argErr = FlutterError(code: "BAD_ARGS", message: "Failed to parse arguments!", details: nil)
          // First check if we can cast the arguments to Dictionary
        guard let args = call.arguments as? Dictionary<String, Any> else {result(argErr); return }
        
        // Check required parameters
        guard let env = args["env"] as? String else { result(argErr); return }
        guard let card_number = args["card_number"] as? String else { result(argErr); return }
        guard let expiration_month = args["expiration_month"] as? String else { result(argErr); return }
        guard let expiration_year = args["expiration_year"] as? String else { result(argErr); return }
        guard let card_cvv = args["card_cvv"] as? String else { result(argErr); return }
        guard let card_holder_name = args["card_holder_name"] as? String else { result(argErr); return }
        guard let api_login_id = args["api_login_id"] as? String else { result(argErr); return }
        guard let client_id = args["client_id"] as? String else { result(argErr); return }
        
        var handler = AcceptSDKHandler(environment: AcceptSDKEnvironment.ENV_TEST)
        if(env == "production"){
            handler = AcceptSDKHandler(environment: AcceptSDKEnvironment.ENV_LIVE)
        }

        let request = AcceptSDKRequest()
        request.merchantAuthentication.name = api_login_id
        request.merchantAuthentication.clientKey = client_id
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardNumber = card_number
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationMonth = expiration_month
        request.securePaymentContainerRequest.webCheckOutDataType.token.expirationYear = expiration_year
        request.securePaymentContainerRequest.webCheckOutDataType.token.cardCode = card_cvv
        request.securePaymentContainerRequest.webCheckOutDataType.token.fullName = card_holder_name
        
        // Optional zip code
        if let zip_code = args["zip_code"] as? String, !zip_code.isEmpty {
            request.securePaymentContainerRequest.webCheckOutDataType.token.zip = zip_code
        }
        
        handler!.getTokenWithRequest(request, successHandler: { (inResponse:AcceptSDKTokenResponse) -> () in
            DispatchQueue.main.async {
                result(inResponse.getOpaqueData().getDataValue())
            };
        }) { (inError:AcceptSDKErrorResponse) -> () in
            result(inError.getMessages().getMessages()[0].getText())
        }
    }
    }
  }