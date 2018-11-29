//
//  TouchIDFacade.swift
//  TouchID
//
//  Created by Sergey Pogrebnyak on 11/29/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import LocalAuthentication

struct ResponseTouchID {
    var errorDescription: ErrorTouchID?
    var isError: Bool
    var isSucces: Bool
}

enum ErrorTouchID: String {
    case notSupportedOnDevice = "Ooops!!.. This feature is not supported."
    case notEvaluateBiometric = "Sorry!!.. Could not evaluate policy."
}

struct TouchIdFacade {
    static func showTouchIDAlert(localozeReasonForShow: String, canAuthorizWithPassword: Bool, callback: @escaping (ResponseTouchID) -> Void) {
        let myContext = LAContext()

        guard checkVersionDevice() else {
            let responseTouchID = ResponseTouchID(errorDescription: ErrorTouchID.notSupportedOnDevice, isError: true, isSucces: false)
            callback(responseTouchID)
            return
        }

        guard checkIsCanUseBiometricAuthorization() else {
            let responseTouchID = ResponseTouchID(errorDescription: ErrorTouchID.notEvaluateBiometric, isError: true, isSucces: false)
            callback(responseTouchID)
            return
        }

        var authorizeWith = LAPolicy.deviceOwnerAuthentication
        if !canAuthorizWithPassword {
            myContext.localizedFallbackTitle = ""
            authorizeWith = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        }

        myContext.evaluatePolicy(authorizeWith, localizedReason: localozeReasonForShow) { success, evaluateError in
            DispatchQueue.main.async {
                if success {
                    let responseTouchID = ResponseTouchID(errorDescription: nil, isError: false, isSucces: true)
                    callback(responseTouchID)
                } else {
                    let responseTouchID = ResponseTouchID(errorDescription: nil, isError: false, isSucces: false)
                    callback(responseTouchID)
                }
            }
        }

    }

    static fileprivate func checkVersionDevice() -> Bool {
        if #available(iOS 8.0, macOS 10.12.1, *) {
            return true
        } else {
            return false
        }
    }

    static fileprivate func checkIsCanUseBiometricAuthorization() -> Bool {
        let myContext = LAContext()
        var authError: NSError?
        return myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
    }
}
