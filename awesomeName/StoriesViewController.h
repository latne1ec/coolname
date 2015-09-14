//
//  StoriesViewController.h
//  
//
//  Created by Evan Latner on 9/3/15.
//
//

#import <UIKit/UIKit.h>
#import "MPParallaxLayout.h"
#import "MPParallaxCollectionViewCell.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SDWebImageManager.h"
#import "DateTools.h"


@interface StoriesViewController : UIViewController <UIWebViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,MPParallaxCellDelegate, UIAlertViewDelegate>{
    
    UICollectionView *_collectionView;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (nonatomic, strong) UIImage *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (nonatomic, strong) NSString *articleTitleString;
@property (nonatomic, strong) NSString *newsItemTeaserString;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic) int row;


@property (nonatomic, readwrite) UIView *clearView;
@property (nonatomic, readwrite) UIButton *homeButton;
@property (nonatomic, readwrite) UIButton *readMoreButton;
@property (nonatomic, readwrite) UIButton *shareButton;
@property (nonatomic, readwrite) UIButton *favButton;


@property (nonatomic, readwrite) UIButton *closeButton;
@property (nonatomic, readwrite) UIButton *toolBarshareButton;
@property (nonatomic, readwrite) UIButton *toolBarfavButton;


@property (nonatomic, readwrite) NSMutableDictionary *object;

@property (nonatomic, readwrite) UILabel *countLabel;

@property (nonatomic, strong) UIView *submitView;

@property (weak, nonatomic) IBOutlet UITextField *submitTextfield;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;










@end
