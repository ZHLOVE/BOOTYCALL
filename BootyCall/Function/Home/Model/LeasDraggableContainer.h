//
//  LeasDraggableContainer.h
//  BootyCall
//
//  Created by dazhongdiy on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeasDraggableCardView.h"
#import "LeasDraggableConfig.h"
#import <Foundation/Foundation.h>

@class LeasDraggableContainer;

//  -------------------------------------------------
//  MARK: Delegate
//  -------------------------------------------------

@protocol LeasDraggableContainerDelegate <NSObject>

- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer
        draggableDirection:(LeasDraggableDirection)draggableDirection
                widthRatio:(CGFloat)widthRatio
               heightRatio:(CGFloat)heightRatio;

- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer
                  cardView:(LeasDraggableCardView *)cardView
            didSelectIndex:(NSInteger)didSelectIndex;

- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer
 finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;

// 选择对象
- (void)selectedCardView:(LeasDraggableCardView *) cardView
               draggableDirection:(LeasDraggableDirection)draggableDirection
          didSelectIndex:(NSInteger)didSelectIndex;


@end

//  -------------------------------------------------
//  MARK: DataSource
//  -------------------------------------------------

@protocol LeasDraggableContainerDataSource <NSObject>

@required

- (LeasDraggableCardView *)draggableContainer:(LeasDraggableContainer *)draggableContainer
                               viewForIndex:(NSInteger)index;

- (NSInteger)numberOfIndexs;

@end

//  -------------------------------------------------
//  MARK: CCDraggableContainer
//  -------------------------------------------------



@interface LeasDraggableContainer : UIView

@property (nonatomic, weak) IBOutlet id <LeasDraggableContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <LeasDraggableContainerDataSource>dataSource;

@property (nonatomic) LeasDraggableStyle     style;
@property (nonatomic) LeasDraggableDirection direction;


- (instancetype)initWithFrame:(CGRect)frame style:(LeasDraggableStyle)style;
- (void)removeFormDirection:(LeasDraggableDirection)direction;
- (void)reloadData;


@end
