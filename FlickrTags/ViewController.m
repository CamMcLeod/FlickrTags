//
//  ViewController.m
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"
#import "DetailViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSMutableArray *catPhotos;
@property (nonatomic) NSMutableArray *dogPhotos;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


-(NSMutableArray *)loadDataWithTag:(NSString *)tag andArray:(NSMutableArray *) loadingArray;

- (IBAction)segmentcontrolPushed:(UISegmentedControl *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.catPhotos = [[NSMutableArray alloc] init];
    self.dogPhotos = [[NSMutableArray alloc] init];
    CGSize itemSize =CGSizeMake(self.view.frame.size.width/2-40, self.view.frame.size.width/2-40);
    [self.flowLayout setItemSize:itemSize];
    NSLog(@"%@", [self.segmentedControl titleForSegmentAtIndex:0]);
    NSLog(@"%@", [self.segmentedControl titleForSegmentAtIndex:1]);
    [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.catPhotos = [self loadDataWithTag:[self.segmentedControl titleForSegmentAtIndex:0] andArray: self.catPhotos];
    self.dogPhotos = [self loadDataWithTag:[self.segmentedControl titleForSegmentAtIndex:1] andArray:self.dogPhotos];
    
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath: indexPath];
    Photo * photo = [[Photo alloc] init];
    // Configure the cell’s contents.
    if(indexPath.section == 0){
        photo = self.catPhotos[indexPath.row];
    } else {
        photo = self.dogPhotos[indexPath.row];
    }
    
    
    cell.label.text = photo.title;
    if (photo.image){
        cell.imageView.image = photo.image;
    } else {
    
        NSURL *url = [NSURL URLWithString:photo.url]; // 1
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) { // 1
                // Handle the error
                NSLog(@"error: %@", error.localizedDescription);
                return;
            }
            // If we reach this point, we have successfully retrieved the JSON from the API
            UIImage *image = [UIImage imageWithData:data];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if(indexPath.section == 0){
                    [self.catPhotos[indexPath.row] setImage: image];
                } else {
                    [self.dogPhotos[indexPath.row] setImage: image];
                }
                cell.imageView.image = image;
            }];
            
        }];
        
        [dataTask resume];
        
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section==0){
        return [self.catPhotos count];
    } else {
        return [self.dogPhotos count];
    }
    
}

-(NSMutableArray *)loadDataWithTag:(NSString *)tag andArray:(NSMutableArray *) loadingArray{
    
    loadingArray = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=1648e27ecf2333ddd82c92f031d7d91e&tags=%@", tag]]; // 1
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *queryResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        NSDictionary *photos = queryResult[@"photos"];
        NSArray *photoArray = photos[@"photo"];
        for (NSDictionary *photoImport in photoArray) { // 4
            
            Photo *photo = [[Photo alloc] initWithDict:photoImport];
            [loadingArray addObject: photo];
            NSLog(@"%@ IMPORTED TO %@", [[loadingArray lastObject] title], tag);
            
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
    [dataTask resume];
    return loadingArray;
}

- (IBAction)segmentcontrolPushed:(UISegmentedControl *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: sender.selectedSegmentIndex];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated: YES];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
               atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                       animated:(BOOL)animated {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PhotoCollectionViewCell *)cell{
    if([segue.identifier isEqualToString: @"detail"]){
        
        DetailViewController *dVC = [segue destinationViewController];
        Photo *photo = [[Photo alloc] init];
        photo.title = cell.label.text;
        photo.image = cell.imageView.image;
        
        dVC.photo = photo;

    }
    
}

@end
