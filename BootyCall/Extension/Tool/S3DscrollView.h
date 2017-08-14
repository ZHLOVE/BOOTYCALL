//
//  S3DscrollView.h
//  BootyCall
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3DscrollView : UIScrollView

@property(nonatomic,assign)BOOL dScrollView;   // 当前属性设置位置必须位于添加子视图之后
@property(nonatomic,assign)NSUInteger pageNum;
@property(nonatomic,assign)CGFloat rightScale;
@property(nonatomic,assign)CGFloat leftScale;

- (void)make3Dscrollview; // 调用此方法实现3D效果

@end
