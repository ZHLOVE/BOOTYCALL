//
//  ColorView.h
//  BootyCall
//
//  Created by rimi on 16/8/25.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewDelegate <NSObject>

-(void)changeContentTextColor:(UIColor *)color;

@end

@interface ColorView : UIView

+(ColorView *) shareColorView ;
/**
 *  协议
 */
@property(nonatomic,assign)id<ColorViewDelegate> delegate;



@end
