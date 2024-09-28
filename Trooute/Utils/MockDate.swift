//
//  MockDate.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//
import Foundation
class MockDate {
    
    class func getTripsResponse() -> GetTripsResponse? {
        let jsonData = Data(MockDate.SearchTripsResponse.utf8)
        let decoder = JSONDecoder()

        do {
            let tripsResponse = try decoder.decode(GetTripsResponse.self, from: jsonData)
            return tripsResponse
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    
    static let SearchTripsResponse = """
{
    "success": true,
    "data": [
        {
            "_id": "66422f9d233ef9ddbf6b2dde",
            "driver": {
                "_id": "6591a55d32c2449434ce2e7a",
                "name": "Jahangir",
                "photo": "cover-image-1707597881040.jpg",
                "carDetails": {
                    "make": "Honda",
                    "model": "City",
                    "registrationNumber": "ABD300",
                    "year": 2023,
                    "color": "Green",
                    "photo": "carphoto-1707596900138-16302-img_20240210_212807.jpg",
                    "reviews": [
                        "65c7ace1175d0619a4c609a7",
                        "6626630dd5dac51d3a520ab4"
                    ],
                    "reviewsStats": {
                        "totalReviews": 4,
                        "avgRating": 2.975,
                        "ratings": {
                            "4": 1,
                            "1.7": 1,
                            "4.7": 1,
                            "1.5": 1
                        }
                    },
                    "driverLicense": "driverlicense-1704640237381-87445-image_2022_11_22t12_20_57_979z.png"
                },
                "gender": "male",
                "reviewsStats": {
                    "totalReviews": 5,
                    "avgRating": 3.72,
                    "ratings": {
                        "4": 1,
                        "2.9": 1,
                        "3.6": 1,
                        "4.4": 1,
                        "3.7": 1
                    }
                }
            },
            "from_address": "Berlin, Germany",
            "from_location": {
                "type": "Point",
                "coordinates": [
                    13.404954,
                    52.52000659999999
                ]
            },
            "whereTo_address": "Hamburg, Germany",
            "whereTo_location": {
                "type": "Point",
                "coordinates": [
                    9.987170299999999,
                    53.5488282
                ]
            },
            "totalSeats": 4,
            "pricePerPerson": 160,
            "luggageRestrictions": [
                {
                    "type": "HandCarry",
                    "weight": 10,
                    "_id": "66422f9d233ef9ddbf6b2ddf"
                },
                {
                    "type": "SuitCase",
                    "_id": "66422f9d233ef9ddbf6b2de0"
                }
            ],
            "roundTrip": false,
            "smokingPreference": false,
            "petPreference": true,
            "isAddedInWishList": false,
            "note": "",
            "status": "Scheduled",
            "passengers": [],
            "departureDate": "2024-06-08T14:00:00.000Z",
            "totalAmount": 0,
            "availableSeats": 4,
            "createdAt": "2024-05-13T15:19:58.000Z",
            "updatedAt": "2024-05-13T15:19:58.000Z",
            "__v": 0
        },
        {
            "_id": "66f478441e29b8cbda04a133",
            "driver": {
                "_id": "6591a55d32c2449434ce2e7a",
                "name": "Jahangir",
                "photo": "cover-image-1707597881040.jpg",
                "carDetails": {
                    "make": "Honda",
                    "model": "City",
                    "registrationNumber": "ABD300",
                    "year": 2023,
                    "color": "Green",
                    "photo": "carphoto-1707596900138-16302-img_20240210_212807.jpg",
                    "reviews": [
                        "65c7ace1175d0619a4c609a7",
                        "6626630dd5dac51d3a520ab4"
                    ],
                    "reviewsStats": {
                        "totalReviews": 4,
                        "avgRating": 2.975,
                        "ratings": {
                            "4": 1,
                            "1.7": 1,
                            "4.7": 1,
                            "1.5": 1
                        }
                    },
                    "driverLicense": "driverlicense-1704640237381-87445-image_2022_11_22t12_20_57_979z.png"
                },
                "gender": "male",
                "reviewsStats": {
                    "totalReviews": 5,
                    "avgRating": 3.72,
                    "ratings": {
                        "4": 1,
                        "2.9": 1,
                        "3.6": 1,
                        "4.4": 1,
                        "3.7": 1
                    }
                }
            },
            "from_address": "Stockholm, Sweden",
            "from_location": {
                "type": "Point",
                "coordinates": [
                    18.0685808,
                    59.32932349999999
                ]
            },
            "whereTo_address": "Berlin, Germany",
            "whereTo_location": {
                "type": "Point",
                "coordinates": [
                    13.404954,
                    52.52000659999999
                ]
            },
            "totalSeats": 4,
            "pricePerPerson": 500,
            "luggageRestrictions": [
                {
                    "type": "HandCarry",
                    "weight": 20,
                    "_id": "66f478441e29b8cbda04a134"
                },
                {
                    "type": "SuitCase",
                    "weight": 40,
                    "_id": "66f478441e29b8cbda04a135"
                }
            ],
            "roundTrip": false,
            "smokingPreference": true,
            "petPreference": true,
            "isAddedInWishList": false,
            "languagePreference": "Swedish",
            "note": "Other relevant details goes there",
            "status": "Scheduled",
            "passengers": [],
            "departureDate": "2025-01-01T03:51:00.000Z",
            "totalAmount": 0,
            "availableSeats": 4,
            "createdAt": "2024-09-25T20:53:24.635Z",
            "updatedAt": "2024-09-25T20:53:24.635Z",
            "__v": 0
        },
        {
            "_id": "66f7adcd6c3d7ba2736392c8",
            "driver": {
                "_id": "6591a55d32c2449434ce2e7a",
                "name": "Jahangir",
                "photo": "cover-image-1707597881040.jpg",
                "carDetails": {
                    "make": "Honda",
                    "model": "City",
                    "registrationNumber": "ABD300",
                    "year": 2023,
                    "color": "Green",
                    "photo": "carphoto-1707596900138-16302-img_20240210_212807.jpg",
                    "reviews": [
                        "65c7ace1175d0619a4c609a7",
                        "6626630dd5dac51d3a520ab4"
                    ],
                    "reviewsStats": {
                        "totalReviews": 4,
                        "avgRating": 2.975,
                        "ratings": {
                            "4": 1,
                            "1.7": 1,
                            "4.7": 1,
                            "1.5": 1
                        }
                    },
                    "driverLicense": "driverlicense-1704640237381-87445-image_2022_11_22t12_20_57_979z.png"
                },
                "gender": "male",
                "reviewsStats": {
                    "totalReviews": 5,
                    "avgRating": 3.72,
                    "ratings": {
                        "4": 1,
                        "2.9": 1,
                        "3.6": 1,
                        "4.4": 1,
                        "3.7": 1
                    }
                }
            },
            "from_address": "Upplands Väsby, Sweden",
            "from_location": {
                "type": "Point",
                "coordinates": [
                    17.92834,
                    59.51961
                ]
            },
            "whereTo_address": "Uppsala, Sweden",
            "whereTo_location": {
                "type": "Point",
                "coordinates": [
                    17.6389267,
                    59.85856380000001
                ]
            },
            "totalSeats": 10,
            "pricePerPerson": 50,
            "luggageRestrictions": [
                {
                    "type": "HandCarry",
                    "_id": "66f7adcd6c3d7ba2736392c9"
                },
                {
                    "type": "SuitCase",
                    "_id": "66f7adcd6c3d7ba2736392ca"
                }
            ],
            "roundTrip": false,
            "smokingPreference": false,
            "petPreference": false,
            "isAddedInWishList": false,
            "note": "",
            "status": "Scheduled",
            "passengers": [],
            "departureDate": "2024-11-30T17:00:00.000Z",
            "totalAmount": 0,
            "availableSeats": 10,
            "createdAt": "2024-09-28T07:18:37.551Z",
            "updatedAt": "2024-09-28T07:18:37.551Z",
            "__v": 0
        }
    ],
    "message": "Trips fetched successfully"
}
"""
    
    
    static let LoginResponse = """
{
    "success": true,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OTFhNTVkMzJjMjQ0OTQzNGNlMmU3YSIsImlhdCI6MTcyNzM2ODA2NSwiZXhwIjoxNzM1MTQ0MDY1fQ.3vxEZcVJo6Dhikx7sQoHwxYbKKNVLzOej1g9Kv_yiEA",
    "data": {
        "carDetails": {
            "make": "Honda",
            "model": "City",
            "registrationNumber": "ABD300",
            "year": 2023,
            "color": "Green",
            "photo": "carphoto-1707596900138-16302-img_20240210_212807.jpg",
            "reviews": [
                "65c7ace1175d0619a4c609a7",
                "6626630dd5dac51d3a520ab4"
            ],
            "reviewsStats": {
                "totalReviews": 4,
                "avgRating": 2.975,
                "ratings": {
                    "4": 1,
                    "1.7": 1,
                    "4.7": 1,
                    "1.5": 1
                }
            },
            "driverLicense": "driverlicense-1704640237381-87445-image_2022_11_22t12_20_57_979z.png"
        },
        "_id": "6591a55d32c2449434ce2e7a",
        "name": "Jahangir",
        "email": "imcreativedeveloper@gmail.com",
        "role": "user",
        "photo": "cover-image-1707597881040.jpg",
        "driverMode": false,
        "isApprovedDriver": "approved",
        "phoneNumber": "+46 76 696 60 66",
        "isEmailVerified": true,
        "status": "active",
        "createdAt": "2023-12-31T17:31:09.513Z",
        "updatedAt": "2024-09-25T20:51:36.570Z",
        "__v": 2,
        "emailverifyOTP": null,
        "passwordChangedAt": "2024-02-18T13:04:26.009Z",
        "stripeConnectedAccountId": "acct_1P4yjZL5q4rA7qOb",
        "stripeToken": "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",
        "gender": "male",
        "reviewsStats": {
            "totalReviews": 5,
            "avgRating": 3.72,
            "ratings": {
                "4": 1,
                "2.9": 1,
                "3.6": 1,
                "4.4": 1,
                "3.7": 1
            }
        }
    },
    "message": "Logged in successfully"
}
"""
}

