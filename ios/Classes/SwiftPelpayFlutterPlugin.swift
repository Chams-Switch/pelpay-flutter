import Flutter
import UIKit
import Pelpay

public class SwiftPelpayFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pelpay_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftPelpayFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments else {
            return result("iOS could not recognize flutter arguments in method: (sendParams)")
        }
        
        let argsMap = args as! NSDictionary
        
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        
        if (call.method == "makePayment"){
            
            DispatchQueue.main.async {
                
                let clientId: String = argsMap.value(forKey: "clientId") as! String
                let clientSecret: String = argsMap.value(forKey: "clientSecret") as! String
                let transaction: [String: Any] = argsMap.value(forKey: "transaction") as! [String: Any]
                let isProduction: Bool = argsMap.value(forKey: "isProduction") as! Bool
                let brandPrimaryColorInHex: String = argsMap.value(forKey: "brandPrimaryColorInHex") as! String
                
                let _brandColor = UIColor.init(hexString: brandPrimaryColorInHex)
                let shouldHidePelpaySecureLogo: Bool = argsMap.value(forKey: "shouldHidePelpaySecureLogo") as! Bool
                
                let _integrationKey = transaction["integrationKey"] as! String
                let _amount = transaction["amount"] as! Int
                let _currency = transaction["currency"] as! String
                let _merchantReference = transaction["merchantReference"] as! String
                let _narration = transaction["narration"] as! String
                let _callbackUrl = transaction["callbackUrl"] as! String
                let _productCode = transaction["productCode"] as! String
                let _splitCode = transaction["splitCode"] as! String
                let _shouldTokenise = transaction["shouldTokenise"] as! Bool
                let _customer = transaction["customer"] as! [String: Any]
                
                //CUSTOMER PARSING
                let _customerId = _customer["customerId"] as! String
                let _customerLastName = _customer["customerLastName"] as! String
                let _customerFirstName = _customer["customerFirstName"] as! String
                let _customerEmail = _customer["customerEmail"] as! String
                let _customerPhoneNumber = _customer["customerPhoneNumber"] as! String
                let _customerAddress = _customer["customerAddress"] as! String
                let _customerCity = _customer["customerCity"] as! String
                let _customerStateCode = _customer["customerStateCode"] as! String
                let _customerPostalCode = _customer["customerPostalCode"] as! String
                let _customerCountryCode = _customer["customerCountryCode"] as! String
                
                //1. Set the Transaction, each field is important and must not be nil
                PelpaySdk.shared.setTransaction(integrationKey: _integrationKey, amount: _amount, currency: _currency, merchantReference: _merchantReference, narration: _narration, callackUrl: _callbackUrl, productCode: _productCode, splitCode: _splitCode, shouldTokenise: _shouldTokenise)
                
                //2. Set the Customer, each field is important and must not be nil
                PelpaySdk.shared.setCustomer(customerID: _customerId, customerLastName: _customerLastName, customerFirstName:_customerFirstName, customerEmail: _customerEmail, customerPhoneNumber: _customerPhoneNumber, customerAddress: _customerAddress, customerCity: _customerCity, customerStateCode: _customerStateCode, customerPostalCode: _customerPostalCode, customerCountryCode: _customerCountryCode)
                
                //3. Initialize the SDK
                PelpaySdk.shared.initialise(
                    withEnvironment: isProduction ? .Production : .Staging,
                    withClientId: clientId,
                    withClientSecret: clientSecret,
                    withController: controller).setBrandPrimaryColor(color: _brandColor).setHidePelpayLogo(isHidden: shouldHidePelpaySecureLogo).withCallBack(callback: PelpayCallback(result: result))
                
            }
            
        }
        
    }
}

class PelpayCallback : PelpaySdkCallback {
    
    var result: FlutterResult? = nil
    init(result: @escaping FlutterResult){
        self.result = result
    }
    func onPaymentSuccess(adviceReference: String?) {
        self.result!(adviceReference)
    }
    
    func onPaymentError(errorMessage: String?) {
        self.result!(FlutterError(code: "ERROR",
                                  message: errorMessage,
                                  details: errorMessage))
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
