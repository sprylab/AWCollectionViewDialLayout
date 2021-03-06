//
//  ViewController.m
//  AWCollectionViewDialLayoutDemo
//
//  Created by Antoine Wette on 14.03.14.
//  Copyright (c) 2014 Antoine Wette. All rights reserved.
//

#import "ViewController.h"
#import "AWCollectionViewDialLayout.h"
#import "PageCollectionViewCell.h"

@interface ViewController ()

@end

static NSString *cellId = @"cellId";
static NSString *cellId2 = @"cellId2";
static NSString *cellId3 = @"cellId3";

@implementation ViewController{
    NSMutableDictionary *thumbnailCache;
    BOOL showingSettings;
    UIView *settingsView;
    
    UILabel *radiusLabel;
    UISlider *radiusSlider;
    UILabel *angularSpacingLabel;
    UISlider *angularSpacingSlider;
    UILabel *xOffsetLabel;
    UISlider *xOffsetSlider;
    UISegmentedControl *exampleSwitch;
    AWCollectionViewDialLayout *dialLayout;
    
    int type;
}

@synthesize collectionView, items, editBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    type = 0;
    showingSettings = NO;
    
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_image.png"]];
    
    [collectionView registerNib:[UINib nibWithNibName:@"dialCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    [collectionView registerNib:[UINib nibWithNibName:@"dialCell2" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId2];
    [collectionView registerNib:[UINib nibWithNibName:@"dialCell3" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId3];
    
    
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pages" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"jsonString:%@",jsonString);
    items = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-44)];
    [settingsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    [self.view addSubview:settingsView];
    [self buildSettings];
    
    
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    CGFloat cell_width = 364;
    CGFloat cell_height = 162;
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    
    
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset];
    [collectionView setCollectionViewLayout:dialLayout];
    collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradientnew.png"]];
    
    [editBtn setTarget:self];
    [editBtn setAction:@selector(toggleSettingsView)];
    
    [self switchExample];
    
}

-(void)buildSettings{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"iphone_settings_view" owner:self options:nil];
    UIView *innerView = [viewArr objectAtIndex:0];
    CGRect frame = innerView.frame;
    frame.origin.y = (self.view.frame.size.height/2 - frame.size.height/2)/2;
    innerView.frame = frame;
    [settingsView addSubview:innerView];
    
    radiusLabel = (UILabel*)[innerView viewWithTag:100];
    radiusSlider = (UISlider*)[innerView viewWithTag:200];
    [radiusSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    angularSpacingLabel = (UILabel*)[innerView viewWithTag:101];
    angularSpacingSlider = (UISlider*)[innerView viewWithTag:201];
    [angularSpacingSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    xOffsetLabel = (UILabel*)[innerView viewWithTag:102];
    xOffsetSlider = (UISlider*)[innerView viewWithTag:202];
    [xOffsetSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    exampleSwitch = (UISegmentedControl*)[innerView viewWithTag:203];
    [exampleSwitch addTarget:self action:@selector(switchExample) forControlEvents:UIControlEventValueChanged];
}

-(void)switchExample{
    type = (int)exampleSwitch.selectedSegmentIndex;
    CGFloat radius = 0 ,angularSpacing  = 0, xOffset = 0;
    
    if(type == 0){
        [dialLayout setCellSize:CGSizeMake(364, 162)];
        [dialLayout setWheelType:WHEELALIGNMENTLEFT];
        
        radius = 500;
        angularSpacing = 18;
        xOffset = 100;
    }/*else if(type == 1){
        [dialLayout setCellSize:CGSizeMake(260, 50)];
        [dialLayout setWheelType:WHEELALIGNMENTCENTER];
        
        radius = 320;
        angularSpacing = 5;
        xOffset = 124;
    }*/
    
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    radiusSlider.value = radius/1000;
    [dialLayout setDialRadius:radius];
    
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    angularSpacingSlider.value = angularSpacing / 90;
    [dialLayout setAngularSpacing:angularSpacing];
    
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    xOffsetSlider.value = xOffset/320;
    [dialLayout setXOffset:xOffset];
    
    
    [collectionView reloadData];

}

-(void)updateDialSettings{
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    
    [radiusLabel setText:[NSString stringWithFormat:@"Radius: %i", (int)radius]];
    [dialLayout setDialRadius:radius];
    
    [angularSpacingLabel setText:[NSString stringWithFormat:@"Angular spacing: %i", (int)angularSpacing]];
    [dialLayout setAngularSpacing:angularSpacing];
    
    [xOffsetLabel setText:[NSString stringWithFormat:@"X offset: %i", (int)xOffset]];
    [dialLayout setXOffset:xOffset];
    
    [dialLayout invalidateLayout];
    //[collectionView reloadData];
    NSLog(@"updateDialSettings");
}

-(void)toggleSettingsView{
    CGRect frame = settingsView.frame;
    if(showingSettings){
        editBtn.title = @"Edit";
        frame.origin.y = self.view.frame.size.height;
    }else{
        editBtn.title = @"Close";
        frame.origin.y = 44;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        settingsView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    showingSettings = !showingSettings;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(type == 0){
        //cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        cell = [cv dequeueReusableCellWithReuseIdentifier:cellId3 forIndexPath:indexPath];
    }else{
        cell = [cv dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
    }
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.item];
    
    NSString *subheadlineName = [item valueForKey:@"subheadline"];
    NSString *headlineName = [item valueForKey:@"headline"];
    NSString *descriptionText = [item valueForKey:@"description"];
    UILabel *subheadline = (UILabel*)[cell viewWithTag:101];
    UILabel *headline = (UILabel*)[cell viewWithTag:103];
    UILabel *description = (UILabel*)[cell viewWithTag:104];
    [subheadline setText:subheadlineName];
    subheadline.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    subheadline.textColor = [self colorFromHex:@"#ffffff"];
    
    [headline setText:headlineName];
    headline.font = [UIFont fontWithName:@"Roboto-Bold" size:22.0];
    headline.textColor = [self colorFromHex:@"#ffffff"];
    
    [description setText:descriptionText];
    description.font = [UIFont fontWithName:@"Roboto-Regular" size:18.0];
    description.textColor = [self colorFromHex:@"#cccccc"];
    
    // TODO: check content and resize label height and text container height
    // cast cell to PageCollectionViewCell
    

    NSString *imgURL = [item valueForKey:@"picture"];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    [imgView setImage:nil];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        imgView.image = imageProduct;
    }
    else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}


#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(364, 162);
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

-(UIColor*)colorFromHex:(NSString*)hexString{
    unsigned int hexint = [self intFromHexString:hexString];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];
    
    return color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
