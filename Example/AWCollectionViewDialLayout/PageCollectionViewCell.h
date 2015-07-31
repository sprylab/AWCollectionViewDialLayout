//
//  PageCollectionViewCell.h
//  AWCollectionViewDialLayoutDemo
//
//  Created by Melanie Sommer on 19.05.15.
//  Copyright (c) 2015 Antoine Wette. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subheadlineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headlineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;

@end
