//
//  LeasDraggableCardView.h
//  BootyCall
//
//  Created by dazhongdiy on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeasDraggableCardView : UIView

@property (nonatomic) CGAffineTransform originalTransform;

- (void)leas_layoutSubviews;

@end
