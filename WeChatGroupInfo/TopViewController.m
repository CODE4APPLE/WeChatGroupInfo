//
//  TopViewController.m
//  BM
//
//  Created by hackxhj on 15/9/7.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//


#import "TopViewController.h"
#import  "CollectionViewCell.h"
 static NSString *kcellIdentifier = @"collectionCellID";
@interface TopViewController ()<CollectionViewCellDelagate>

@end


@implementation TopViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
    self.collectionView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];

    _dataArr=[NSMutableArray new];
    _arrayTemp=[NSMutableArray new];
}


-(void)isInputDelMoudle:(BOOL)isDel
{
    _isdelM=isDel;
    [self.collectionView reloadData];
}

//-(void)delGroupOneTximg:(PersonModel*)person
//{
//    _arrayTemp = _dataArr;
//    NSArray * array = [NSArray arrayWithArray: _arrayTemp];
//    for (PersonModel *pp in array) {
//        if([pp.friendId isEqualToString:person.friendId])
//        {
//            [_arrayTemp removeObject:pp];
//        }
//    }
//    
//    _dataArr=[_arrayTemp mutableCopy];
//    [self.collectionView reloadData];
//}


-(void)delOneTximg:(PersonModel*)person
{
    _arrayTemp = _dataArr;
    NSArray * array = [NSArray arrayWithArray: _arrayTemp];
    for (PersonModel *pp in array) {
        if([pp.friendId isEqualToString:person.friendId])
        {
            [_arrayTemp removeObject:pp];
        }
    }
    
    _dataArr=[_arrayTemp mutableCopy];
    [self.collectionView reloadData];
}

-(void)addOneTximg:(PersonModel*)person
 {
   [_dataArr insertObject:person atIndex:0];
   [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
 
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
      return _dataArr.count+2;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    cell.delagate=self;
    if(indexPath.row==_dataArr.count)
    {
        cell.delbtn.hidden=YES;
        cell.mem.text=@"";
        cell.tx.image=[UIImage imageNamed:@"adduser"];
    }else if(indexPath.row==_dataArr.count+1)
    {
      cell.delbtn.hidden=YES;
      cell.mem.text=@"";
      cell.tx.image=[UIImage imageNamed:@"subuser"];
    }else
    {
      if(_isdelM==YES)
           cell.delbtn.hidden=NO;
      else
         cell.delbtn.hidden=YES;
        
        PersonModel *pm=_dataArr[indexPath.row];
        cell.mem.text=pm.userName;
        cell.tx.image=pm.txicon;

    }
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 75);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);//分别为上、左、下、右
}

#pragma  mark  cell delagate
-(void)clickImg:(UITapGestureRecognizer *)recognizer:(BOOL)isDel;
{
    id sender=recognizer.view;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(CollectionViewCell *)[[sender superview] superview]];

   if(isDel==YES)//删除模式下
    {
        PersonModel *pp=_dataArr[indexPath.row];
        [self.delagate delDataWithStr:pp];
            
    }else
    {
        if(indexPath.row==_dataArr.count)  //添加
        {
            [self.delagate addBtnClick];
 
        }else if(indexPath.row==_dataArr.count+1)
        {
            [self.delagate subBtnClick];
        }
        
    }
    
    
    NSLog(@"%d",indexPath.row);
}

-(void)delclick:(id)sender;
{
    // id sender=recognizer.view;
     
     NSIndexPath *indexPath = [self.collectionView indexPathForCell:(CollectionViewCell *)[[sender superview] superview]];
     PersonModel *pp=_dataArr[indexPath.row];
    [self.delagate delDataWithStr:pp];//删除需要给通知数据源删除
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
