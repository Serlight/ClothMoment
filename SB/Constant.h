//
//  Constant.h
//  SB
//
//  Created by serlight on 11/9/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#ifndef SB_Constant_h
#define SB_Constant_h

#define BaseURL     @"http://121.40.181.141"
#define RequestTimeoutInterval 30
#define easeMobApnsCertName @"ClothMoment_Development"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#ifdef DEBUG
#   define MLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define MLog(...)
#endif

#define UIColorFromRGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height

#define SignUpUrl       @"/api/Account/RegUser2"
#define LoginUrl        @"/api/Account/Login"
#define ResetPasswordUrl   @"/api/Account/ChangePwd"
#define LogOutUrl       @"/api/Account/Logout"
#define UpdateUserInfo  @"/api/Account/EditUser"
#define SetProfile      @"http://121.40.181.141/api2/Account/SetProfile"
#define SaveSuggestion  @"/api/Suggestion/SaveSuggestion"
#define GetCreditScore  @"/api/Data/CreditScore"
#define AddFriend       @"/api/Contact/AddOne"
#define DeleteOneUser   @"/api/Contact/DelOne"
#define SearchFriend    @"/api/Contact/SearchShop"
#define GetUserInfo     @"/api/Account/UserList"

#define MomentsUrl      @"/api/Circle/InfoList"
#define RecommendDataUrl @"/api/Recommendation/InfoList"
#define MomentInfoUrl      @"/api/Supply/OneSupply"
#define buyInfoUrl      @"/api/Purchase/OnePurchase"
#define ClothType       @"/api/Data/ClothType"
#define FriendListUrl   @"/api/Contact/MyList"
#define AddFavorite    @"/api/Favorite/AddOne"
#define GetShopInfo     @"/api/Data/ShopInfo"
#define AttendUrl       @"/api/Score/SignIn"
#define PostBuyInfo      @"api/Purchase/SavePurchaseInfo"
#define PostSupplyInfo   @"/api/Supply/SaveSupplyInfo"
#define GetFavoriteList @"/api/Favorite/MyList"
#define GetNearByInfo   @"/api/Recommendation/NearbyShop"

#define UploadFile      @"http://121.40.181.141/api2/Data/UploadFile"
#define UploadPurchase  @"/api/Purchase/SavePurchaseInfo"
#define UploadSupplyInfo @"/api/Supply/SaveSupplyInfo"

#define RefreshViewHeight  ScreenWidth
#define RefreshOperationViewHeight 60.0f
#define ArrowWidth      15.0f
#define ArrowHeight     18.0f
#define LargeHeight     4000.0f
#define DefaultDis      192

#define LogOutNotifier  @"LogOut"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define FONT(F) [UIFont systemFontOfSize:F]

#define bNotifyNetWorkException ([[notification object] currentReachabilityStatus] == NotReachable)
#define NetWorkExceptionPrompt  @"联网失败，请检查网络"

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

typedef enum ResponseType {
    RequestSucceed,
    RequestFailed,
    RequestTimeout,
    ResponseFromCache,
    RequestDuplicate
} ResponseType;

typedef enum RequestType {
    PostRequest,
    GetRequest,
    PutRequest,
    DeleteRequest
}RequestType;

typedef enum PostType {
    Buy,
    Sell
} PostType;

typedef void(^CompletionBlock)(ResponseType responseType, id responseObj);


#endif
