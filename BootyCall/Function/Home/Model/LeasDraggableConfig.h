//
//  LeasDraggableConfig.h
//  BootyCall
//
//  Created by dazhongdiy on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#ifndef CCDraggableConfig_h
#define CCDraggableConfig_h

//  -------------------------------------------------
//  MARK: 拽到方向枚举
//  -------------------------------------------------
typedef NS_OPTIONS(NSInteger, LeasDraggableDirection) {
    LeasDraggableDirectionDefault     = 0,
    LeasDraggableDirectionLeft        = 1 << 0,
    LeasDraggableDirectionRight       = 1 << 1
};

typedef NS_OPTIONS(NSInteger, LeasDraggableStyle) {
    LeasDraggableStyleUpOverlay   = 0,
    LeasDraggableStyleDownOverlay = 1
};

#define LGWidth  [UIScreen mainScreen].bounds.size.width
#define LGHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat kBoundaryRatio = 0.5f;
// static const CGFloat kSecondCardScale = 0.98f;
// static const CGFloat kTherdCardScale  = 0.96f;
static const CGFloat kFirstCardScale  = 1.08f;
static const CGFloat kSecondCardScale = 1.04f;

static const CGFloat kCardEdage = 10.0f;
static const CGFloat kContainerEdage = 30.0f;
static const CGFloat kNavigationHeight = 64.0f;
static const CGFloat kVisibleCount = 3;

#endif /* CCDraggableConfig_h */
