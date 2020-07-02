//
//  ViewController.m
//  PhotoManager
//
//  Created by PrinceSmall on 2020/7/1.
//  Copyright © 2020 PrincessSmall. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "PhotoCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<UIImage *> *photoCollectionsArray;
//@property (nonatomic, strong) NSArray *photoResultArray;
//@property (nonatomic, strong) NSMutableArray *mutableResultsArray;
@property (nonatomic, strong) NSMutableArray *mutablePhoneCollectionsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn addTarget:self action:@selector(getOriginalImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.collectionView];
    
    
//    self.photoResultArray = [self.mutableResultsArray copy];
    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
//    imageView.tag = 10001;
//    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
    
}

- (void)getOriginalImage{
    //获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> * assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历所有的自定义的相簿
    
    for(PHAssetCollection * assetCollection in assetCollections){
        
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
        
    }
    //获得相机胶卷
    PHAssetCollection * cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    //遍历相机胶卷，获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

/**
 * 遍历相簿中的所有图片
 * @param assetCollection 相簿
 * @param original 是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    NSLog(@"拍摄时间:%@", assetCollection.startDate);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    self.mutablePhoneCollectionsArray = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [self.mutablePhoneCollectionsArray addObject:result];
                NSLog(@"result = %@, info = %@",result,info);
            }
            
        }];
    }
    [self.collectionView reloadData];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mutablePhoneCollectionsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.photoImageView.image = self.mutablePhoneCollectionsArray[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = (self.view.bounds.size.width-30)/4.0;
    return CGSizeMake(itemWidth, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        
    }
    return _collectionView;
}


@end
