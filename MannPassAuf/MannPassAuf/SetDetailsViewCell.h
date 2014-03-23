//
//  SetDetailsViewCell.h
//  MandarinFlashierCards
//
//  Created by Jürgen Schwietering on 2/1/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetDetailsViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UITextView *articleView;

@end
