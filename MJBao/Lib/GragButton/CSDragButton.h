//
//  CSDragButton.h
//  MoveButton
//
//  Created by FreeGeek on 15/5/28.
//  Copyright (c) 2015年 FreeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDragButton : UIButton
{
    CGPoint startPoint;
    CGPoint newcenter;
    UIImageView * view;
}
//+(CSDragButton *)defaultFloatViewWithButton;
//+(void)setDragButtonHidden:(BOOL)hidden;
@end
