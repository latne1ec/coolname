//
//  StoriesViewController.m
//  
//
//  Created by Evan Latner on 9/3/15.
//
//

#import "StoriesViewController.h"
#import "UIImageView+WebCache.h"




static NSString *kCell=@"cell";
int j;

@interface StoriesViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *teaserLabel;
@property (nonatomic, strong) UIView *blackView;
@property(nonatomic,strong)UIVisualEffectView* blur;
@property (nonatomic) CGFloat currentRow;
@property (nonatomic) int previousRow;

@property (nonatomic) int pageCount;



@end

@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imagesArray = [[NSMutableArray alloc] init];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    self.articleImageView.image = self.articleImage;
    self.articleTitle.text = self.articleTitleString;
    self.articleImageView.clipsToBounds = YES;
    
    MPParallaxLayout *layout=[[MPParallaxLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.pagingEnabled=YES;
    _collectionView.delaysContentTouches = NO;
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.bounces = NO;
    [_collectionView setScrollsToTop:NO];
    [_collectionView addSubview:self.blackView];
    [_collectionView registerClass:[MPParallaxCollectionViewCell class] forCellWithReuseIdentifier:kCell];
    [self.view addSubview:_collectionView];
    
    j = 1;
    
    [self queryForStories];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 96, 100, 60)];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.4];
    self.countLabel.alpha = 0.44;
    //[_collectionView addSubview:self.countLabel];
    
    self.submitView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.submitView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.submitView];
    self.submitView.alpha = 0.0;
    self.submitTextfield.alpha = 0.0;
    
    [self.submitButton setTitle:@"submit" forState:UIControlStateNormal];
    self.submitButton.alpha = 0.0;
    
    
    [self.submitTextfield setValue:[UIColor lightGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    _pageCount = 0;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}
-(void)popBack {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goToNextStory {
    
    if (j >= self.posts.count) {
    }
    else {
        //j++;
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    }
    if (j == self.posts.count) {
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        j = 1;
        
       // [self queryForStories];

    }
        NSLog(@"J: %d", j);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.posts.count*_pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MPParallaxCollectionViewCell* cell =  (MPParallaxCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    
    PFObject *object = [self.posts objectAtIndex:indexPath.item];
    
    if (indexPath.item == 0) {
        //cell.homeButtonLabel.alpha = 0.0;
        //cell.homeButton.alpha = 0.0;
        //cell.swipeDownButton.alpha = 0.0;
        cell.storyCountLabel.hidden = NO;
        cell.storyCountLabel.text = [NSString stringWithFormat:@"%d new stories", (int)self.posts.count];
        cell.title.alpha = 0.87;
        cell.titleTwo.alpha = 0.67;
    }
    
    if (cell.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextStory)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [cell addGestureRecognizer:tap];
    }
    
//    if (cell.gestureRecognizers.count == 1) {
//    
//        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureStarted:)];
//        tap.minimumPressDuration = 0.08;
//        tap.delegate = self;
//        [cell addGestureRecognizer:tap];
//    }
    
    [cell.homeButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *urlString = [object objectForKey:@"postLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    [cell updateWithContent:url];
    
    cell.progressView.alpha = 1.0;
    cell.titleLabel.text = [object objectForKey:@"postTitle"];
    cell.teaserLabel.text = [NSString stringWithFormat:@"Trending in %@ from %@",[object objectForKey:@"postCategory"], [object objectForKey:@"postSource"]];
    cell.sourceTimeAgoLabel.text = [NSString stringWithFormat:@"from %@", [object objectForKey:@"postCategory"]];
    
    if (self.imagesArray.count <= indexPath.item+1) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[object objectForKey:@"postImageURL"]]] placeholderImage:[UIImage imageNamed:@"sanFran.jpg"]];
    } else {
        cell.image = [self.imagesArray objectAtIndex:indexPath.row];
    }

    cell.delegate=self;
    _currentRow = indexPath.item;
    
    return cell;
}

//-(void)tapGestureStarted:(UIGestureRecognizer *)sender {
//    
//    [UIView animateWithDuration:0.00 animations:^{
//        //self.view.transform = CGAffineTransformMakeScale(0.988, 0.988);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.00 animations:^{
//            //self.view.transform = CGAffineTransformMakeScale(0.99, 0.99);
//        } completion:^(BOOL finished) {
//            [self goToNextStory];
//            [UIView animateWithDuration:0.08 animations:^{
//                self.view.transform = CGAffineTransformMakeScale(1.007, 1.007);
//                //self.view.alpha = 1.0;
//            } completion:^(BOOL finished) {
//                self.view.transform = CGAffineTransformMakeScale(1.00, 1.00);
//            }];
//
//        }];
//    }];
//}
//
//-(void)longPressGestureStarted:(UIGestureRecognizer *)sender {
// 
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"Started");
//        
//        
//        
//        [UIView animateWithDuration:0.18 animations:^{
//            self.view.transform = CGAffineTransformMakeScale(0.988, 0.988);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.07 animations:^{
//                //self.view.transform = CGAffineTransformMakeScale(0.99, 0.99);
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
//        
//    }
//    
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Finished");
//        [self goToNextStory];
//        //self.view.alpha = 0.2;
//        [UIView animateWithDuration:0.08 animations:^{
//            self.view.transform = CGAffineTransformMakeScale(1.015, 1.015);
//            //self.view.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            self.view.transform = CGAffineTransformMakeScale(1.00, 1.00);
//        }];
//    }
//}


- (void)cell:(MPParallaxCollectionViewCell *)cell changeParallaxValueTo:(CGFloat)value{
    
    UILabel *label=(UILabel *)[cell viewWithTag:3838];
    CGFloat val=1-(value<0 ? -value : value);
    [label setAlpha:val*val];
    
    UILabel *labelTwo=(UILabel *)[cell viewWithTag:5555];
    CGFloat valTwo=1-(value<0 ? -value : value);
    [labelTwo setAlpha:valTwo*valTwo/1.4];
    
    UIButton *swipeUp = (UIButton *)[cell viewWithTag:1060];
    [swipeUp setAlpha:valTwo*valTwo/3];
    
    if (_currentRow>1) {
        UIButton *swipeDown = (UIButton *)[cell viewWithTag:1070];
        [swipeDown setAlpha:valTwo*valTwo/2];
    }
    
    CGFloat newValue = value*100;
    //NSLog(@"value: %f", newValue);
    
    if (_currentRow > 0 && newValue < -99) {
        cell.storyCountLabel.hidden = YES;
        cell.homeButtonLabel.alpha = 0.74;
        cell.homeButton.alpha = 0.74;
        cell.swipeDownButton.alpha = 0.84;
        cell.title.alpha = 0.0;
        cell.titleTwo.alpha = 0.0;
        
        MPParallaxCollectionViewCell *previousCell = (MPParallaxCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentRow-1 inSection:0]];
        
        
        [previousCell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [previousCell.webview stopLoading];
        [previousCell.webview loadHTMLString:@"" baseURL:nil];
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > 0) {
        //Horizontal
        
        CGRect frame = self.countLabel.frame;
        frame.origin.x = scrollView.contentOffset.x+18;
        self.countLabel.frame = frame;
        [_collectionView bringSubviewToFront:self.countLabel];
        
        int scrollViewPosition = 0;
        
        if (_currentRow == 0) {
            scrollViewPosition = scrollView.contentOffset.x;
        }
        if (_currentRow > 0) {
            scrollViewPosition = scrollView.contentOffset.x/_currentRow;
        }
        if (scrollViewPosition == self.view.frame.size.width) {
            j = _currentRow+1;
        }
    }
    if (scrollView.contentOffset.y > 30) {
    }
}


-(void)queryForStories {
    
    //int limit = 100;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByAscending:@"createdAt"];
    //[query setLimit:limit];
    //[query setSkip:_pageCount * limit];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
        else {
            
            //pagination
            if ([objects count] > 0) {
                _pageCount++;
            }
            //[self.posts removeAllObjects];
            //[self.imagesArray removeAllObjects];
            
            if (_pageCount == 1) {
                    self.posts = [objects mutableCopy];
            }
            else {
            [self.posts addObjectsFromArray:objects];
            }
            
            [self downloadImages];
        }
    }];
}

-(void)downloadImages {
    
    for (PFObject *object in self.posts) {
        NSString *url = [object valueForKey:@"postImageURL"];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        }
            completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error) {
                    NSLog(@"Error: %@", error);
                }
                
                [self.imagesArray addObject:images];
                
                if (finished) {
                    [_collectionView reloadData];
                    
                    [UIView animateWithDuration:0.6 animations:^{
                        self.blackView.alpha = 0.0;
                        
                    } completion:^(BOOL finished) {
                    }];
                }
            }];
        }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    MPParallaxCollectionViewCell *cell = (MPParallaxCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0]];
    
    if (cell.scrollView.contentOffset.y > self.view.frame.size.height-10) {
        return false;
    }
    if ([gestureRecognizer isMemberOfClass: [UITapGestureRecognizer class]]) {
        return true;
    } else {
        return false;
    }
}


/////HYPOTHETICAL LINK SUBMISSION TEST
-(void)showAlert {
    
    [UIView animateWithDuration:0.28 animations:^{
        self.submitView.alpha = 0.84;
        [self.view bringSubviewToFront:self.submitView];
        
    } completion:^(BOOL finished) {
        
    }];
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Submit a link"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alert.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                   
                                                   PFObject *object = [PFObject objectWithClassName:@"UserSubmittedPosts"];
                                                   [object setObject:textField.text forKey:@"postLink"];
                                                   [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                       if (error) {
                                                           
                                                       }
                                                       else {
                                                           
                                                           UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.submitView.frame.size.width/2-40, self.view.frame.size.height/2-20, 80, 40)];
                                                           thanksLabel.text = @"Thanks!";
                                                           thanksLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:18.4];
                                                           thanksLabel.textColor = [UIColor whiteColor];
                                                           [self.submitView addSubview:thanksLabel];
                                                           [self.submitView bringSubviewToFront:thanksLabel];
                                                           
                                                           [UIView animateWithDuration:1.0 animations:^{
                                                               thanksLabel.alpha = 0.0;
                                                               
                                                               
                                                           } completion:^(BOOL finished) {
                                                               self.submitView.alpha = 0.0;
                                                               [self.view sendSubviewToBack:self.submitView];
                                                               
                                                           }];
                                                       }
                                                       
                                                   }];
                                                   
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       self.submitView.alpha = 0.0;
                                                       [self.view sendSubviewToBack:self.submitView];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"paste link here";
        textField.keyboardType = UIKeyboardTypeURL;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
