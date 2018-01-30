//
//  SCLAlertViewResponder.h
//  SCLAlertView
//
//  Created by Diogo Autilio on 9/26/14.
//  Copyright (c) 2014-2017 AnyKey Entertainment. All rights reserved.
//

#if defined(__has_feature) && __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif
#import "SCLAlertsView.h"

@interface SCLAlertViewResponder : NSObject

/** TODO
 *
 * TODO
 */
- (instancetype)init:(SCLAlertsView *)alertview;

/** TODO
 *
 * TODO
 */
- (void)close;

@end
