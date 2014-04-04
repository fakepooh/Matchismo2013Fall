//
//  CardView.h
//  Matchismo2013Fall
//
//  Created by pooh on 4/4/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)swipeOrTap:(UIGestureRecognizer *)gesture;

@property (nonatomic) CGFloat faceCardScaleFactor;

@end
