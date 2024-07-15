//
//  FWUserModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/7/12.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWUserModel.h"

@implementation FWUserModel

@end

@implementation FWUserDetailsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"userId" : @"user_id", @"token" : @"jwt_token"};
}

@end
