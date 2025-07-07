//
//  Constants.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Constants {
    static let baseUrl = "https://backened.trooute.com"
    static let baseImageUrl = "\(Constants.baseUrl)/files"
    static let TERMS_CONDITIONS = "https://trooute.com/terms-and-conditions.html"
    static let callbackURLScheme = "nativexo"
    //Sandbox
    static let PAYPAL_CLIENT_ID_SandBox = "AexkYHCVuMrbut4rDSO4NaB32c33O1bgPURERJZFw-kjtsKoZljPolRWDnE082pmNKYKEQKWn5A0o_Je"
    static let PAYPAL_SECRET_SandBox = "ECeJPJVuHHY0uOuK3aqdccinNCKWJeqRpQhkajjCf5rYA2PknIZrH4Q10rNc5LF3rAgsmh9zKoibbbr6"
    
    //Live
    static let PAYPAL_CLIENT_ID = "ASKA9o51juQ2VwZaLObaDLnm4HZcAIOk321qeuVGdu2-F-OtDrQHM35W3cbzkRTdqktAOLE-HB53BQ9p"
    static let PAYPAL_SECRET = "EPM02FeF4dCh1z73EzIsfizrJUoeVhU2SSRzfzFhra5pHbpbrEM4nk2PVmUhfC9d0WxHKTDxAMh3K9GQ"
    static let payPalredirectUri = "com.travel.trooutee://paypal"
    
}

struct Apis {
    
    static let apiVersion = "/api/v1/"
    static let base = Constants.baseUrl + apiVersion
    ///: AUTH END POINT
    static let signin =             base + "users/login"
    static let signup =             base + "users/signup"
    static let verifyOTP =          base + "users/verify/email"
    static let resendOTP =          base + "users/resend-token"
    static let updateProfile =      base + "users/updateMe"
    static let forgotPassword =     base + "users/forgotPassword"
    static let updatePassword =     base + "users/updateMyPassword"
    static let getMe =              base + "users/me"
    static let deletMe =            base + "users/deletMe"
    static let signout =            base + "users/signout"
    static let updateDeviceId =     base + "users/updateDeviceId"
    static let updatePayPal =       base + "users/driver/connectPayPal"
    static let connectStripe =      base + "users/driver/connectStripe"
    ///: Driver ENDPOINTS
    static let switchDriverMode =   base + "users/driver/switch-to-driver-mode"
    static let becomeADriver =      base + "users/driver/upload-driver-details"
    static let updateCarInfo =      base + "users/driver/update-car-info"
    ///: TRIPS ENDPOINTS
    static let trip =               base + "trips"
    static let updateTripStatus =   base + "trips/update-trip-status"
    static let updatePickupStatus = base + "trips/updatePickupStatus"
    static let getPickupStatus =    base + "trips/getPickupStatus"
    static let tripHistory =        base + "trips/trips-history"
    ///: Bookings ENDPOINTS
    static let booking =            base + "bookings"
    ///: Review ENDPOINTS
    static let review =             base + "review"
    ///: Wish ENDPOINTS
    static let getWishList =        base + "users/get-my-wishlist"
    
    ///: Firebase // FCM
    static let LAST_MESSAGE_FIELD_NAME = "lastMessage"
    static let TIMESTAMP_FIELD_NAME = "timestamp"
    static let MESSAGE_USER_INFO = "UserInfo"
    static let FCM_BASE_URL = "https://fcm.googleapis.com/fcm/send"
    static let SERVER_KEY = "AAAAsRKMUMQ:APA91bGTTdh3bQM6oORh38BawUcjBYokEyDT_j4tFkb2scXMMM7QqFRx6OE8yKTrjs9C5l_hHI3OelhaHDVnSg0LUtl0XQhWa5nPLUJ-Ul046k6w4gqIjElov_c_ycjKxCuUaO_qNaKk"
    static let TOPIC = "/topics/"
    static let TROOUTE_TOPIC = "trooute_topic_"
}
