//
//  Constants.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

struct Constants {
    static let baseUrl = "https://backened.trooute.com"
    static let baseImageUrl = "\(Constants.baseUrl)/files"
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
    static let updateDeviceId =     base + "users/updateDeviceId"
    ///: Driver ENDPOINTS
    static let switchDriverMode =   base + "users/driver/switch-to-driver-mode"
    static let becomeADriver =      base + "users/driver/upload-driver-details"
    static let updateCarInfo =      base + "users/driver/update-car-info"
    ///: TRIPS ENDPOINTS
    static let trip =               base + "trips"
    static let updateTripStatus =   base + "trips/update-trip-status"
    static let updatePickupStatus = base + "trips/updatePickupStatus"
    ///: Bookings ENDPOINTS
    static let booking =            base + "bookings"
    ///: Review ENDPOINTS
    static let review =             base + "review"
    ///: Wish ENDPOINTS
    static let getWishList =               base + "users/get-my-wishlist"
    
   
}
//// TRIPS END POINT
//  const val CREATE_TRIPS_END_POINT = "/api/v1/trips"
//  const val GET_TRIPS_END_POINT = "/api/v1/trips"
//  const val GET_TRIPS_DETAILS_END_POINT = "/api/v1/trips"
//  const val TRIPS_HISTORY_END_POINT = "/api/v1/trips/trips-history"
//  const val UPDATE_TRIP_STATUS = "api/v1/trips/update-trip-status"
//  const val GET_PICKUP_PASSENGERS_STATUS = "api/v1/trips/getPickupStatus"
//  const val UPDATE_PICKUP_PASSENGERS_STATUS = "api/v1/trips/updatePickupStatus"
//
//  // BOOKINGS END POINT
//  const val CREATE_BOOKING_END_POINT = "/api/v1/bookings"
//  const val GET_BOOKING_END_POINT = "/api/v1/bookings"
//  const val GET_BOOKING_DETAILS_END_POINT = "/api/v1/bookings"
//  const val APPROVE_BOOKING_END_POINT = "/api/v1/bookings"
//  const val CONFIRM_BOOKING_END_POINT = "/api/v1/bookings"
//  const val CANCEL_BOOKING_END_POINT = "/api/v1/bookings"
//  const val COMPLETE_BOOKING_END_POINT = "/api/v1/bookings"
//
//  // REVIEW END POINT
//  const val REVIEW_END_POINT = "/api/v1/review"
//  const val GET_REVIEW_END_POINT = "/api/v1/review/"
//
//  // DRIVER END POINT
//  const val UPLOAD_DRIVER_END_POINT = "/api/v1/users/driver/upload-driver-details"
//  const val SWITCH_DRIVER_END_POINT = "/api/v1/users/driver/switch-to-driver-mode"
//  const val GET_DRIVERS_REQUESTS_END_POINT = "/api/v1/users/driver/get-drivers-requests"
//  const val APPROVE_DRIVER_END_POINT = "/api/v1/users/driver"
//  const val UPDATE_CAR_INFO_END_POINT = "/api/v1/users/driver/update-car-info"
//
//  // WISH LIST POINT
//  const val ADD_TO_WISH_LIST = "api/v1/trips"
//  const val GET_MY_WISH_LIST = "api/v1/users/get-my-wishlist"
