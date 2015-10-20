//
//  ViewController.m
//  WeChatGroupInfo
//
//  Created by hackxhj on 15/10/19.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import "ViewController.h"
#import "TopViewController.h"
#import "GroupInfoCell.h"

#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,TopViewControllerDelagate>

@end

@implementation ViewController
{
     UITableView *_showTable;
     TopViewController *_topview;
     UIButton *_sendBtn;
     NSMutableArray *_groupAll;
     NSMutableArray *_arrPer;
    BOOL isDel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initMyView];
    [self initCreateData];
}

-(void)initCreateData
{
    _groupAll=[NSMutableArray new];
    _arrPer=[NSMutableArray new];
    
    NSArray *arr1=@[@"群聊名称",@"群二维码"];
    NSArray *arr2=@[@"消息免打扰"];
    NSArray *arr4=@[@"共享我的邮件在本群"];
    NSArray *arr5=@[@"清空聊天记录"];
    [_groupAll addObject:arr1];
    [_groupAll addObject:arr2];
    [_groupAll addObject:arr4];
    [_groupAll addObject:arr5];
    
    PersonModel *pm1=[[PersonModel alloc]init];
    pm1.friendId=@"1";
    pm1.userName=@"张三";
    pm1.txicon=[UIImage imageNamed:@"qq1"];
    
    PersonModel *pm2=[[PersonModel alloc]init];
    pm2.friendId=@"2";
    pm2.userName=@"李四";
    pm2.txicon=[UIImage imageNamed:@"qq2"];
    
    PersonModel *pm3=[[PersonModel alloc]init];
    pm3.friendId=@"3";
    pm3.userName=@"王二";
    pm3.txicon=[UIImage imageNamed:@"qq3"];
    
    PersonModel *pm4=[[PersonModel alloc]init];
    pm4.friendId=@"4";
    pm4.userName=@"麻子";
    pm4.txicon=[UIImage imageNamed:@"qq4"];
    
    [_topview addOneTximg:pm1];
    [_topview addOneTximg:pm2];
    [_topview addOneTximg:pm3];
    [_topview addOneTximg:pm4];
    
    [_arrPer addObject:pm1];
    [_arrPer addObject:pm2];
    [_arrPer addObject:pm3];
    [_arrPer addObject:pm4];

    [self setTopViewFrame:_arrPer];
    
}

// 设置topview的高度变化
-(void)setTopViewFrame:(NSArray*)allP
{
    int lie=0;
    if([UIScreen mainScreen].bounds.size.width>320)
    {
        lie=5;
    }else
    {
        lie=4;
    }
    int Allcount=allP.count+2;
    int line=Allcount/lie;
    if(Allcount%lie>0)
        line++;
    _topview.view.frame=CGRectMake(0, 0, mainWidth, line*90);
    _showTable.tableHeaderView=_topview.view;
}


-(void)initMyView
{
    self.title=@"群资料";
    _showTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 66, mainWidth, mainHeight)];
    _showTable.delegate=self;
    _showTable.dataSource=self;
    _showTable.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    [self.view addSubview:_showTable];
    
    _topview=[[TopViewController alloc]initWithNibName:@"TopViewController" bundle:nil];
    _topview.delagate=self;
    _topview.view.frame=CGRectMake(0, 0, mainWidth, 90);
    _topview.isGroupM=YES;
    _showTable.tableHeaderView=_topview.view;
    

    
    UIView *txtfootview=[[UIView alloc]init];
    txtfootview.frame=CGRectMake(0, 0, mainWidth,100);
    txtfootview.backgroundColor=[UIColor clearColor];
    UIButton *btnRegis=[[UIButton alloc]initWithFrame:CGRectMake(10, 40,mainWidth-20, 44)];
    UIImage *buttonImageRegis=[UIImage imageNamed:@"deletebtn"];
    UIImage *stretchableRegister=[buttonImageRegis stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [btnRegis.layer setMasksToBounds:YES];
    [btnRegis.layer setCornerRadius:3];
    [btnRegis setBackgroundImage:stretchableRegister forState:UIControlStateNormal];
    btnRegis.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:19.0];
    [btnRegis setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [btnRegis setTitle:@"删除并退出" forState:0];
    [btnRegis setTitleColor:[UIColor whiteColor] forState:0];
    _sendBtn=btnRegis;
    [txtfootview addSubview:_sendBtn];
    _showTable.tableFooterView=txtfootview;
}


#pragma  mark topview delagate 邀请加群;
-(void)addBtnClick
{
    NSLog(@"add btn click!");
    PersonModel *pmqq=[[PersonModel alloc]init];
    int rx = arc4random() % 100;
    NSString *randomfid=[NSString stringWithFormat:@"%d",rx];
    pmqq.friendId=randomfid;
    pmqq.userName=@"默认";
    pmqq.txicon=[UIImage imageNamed:@"qq"];
    [_topview addOneTximg:pmqq];
    [_arrPer addObject:pmqq];
    [self setTopViewFrame:_arrPer];
    //添加的时候取消删除模式
    if(isDel==YES)
      [self subBtnClick];
}

#pragma  mark delagate 点击进入编辑模式
-(void)subBtnClick
{
    if(isDel==NO)
    {
        [_topview isInputDelMoudle:YES];
        isDel=YES;
    }else
    {
        [_topview isInputDelMoudle:NO];
        isDel=NO;
    }
}


#pragma  mark  delagate  踢出群
-(void)delDataWithStr:(PersonModel*)person
{
    
    NSLog(@"删除的用户--%@",person.friendId);
    [_topview delOneTximg:person];
    [_arrPer removeObject:person];
    [self setTopViewFrame:_arrPer];
 
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupAll[section]count] ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupAll.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *idfCell=@"grouptopcell";
    GroupInfoCell *topcell=(GroupInfoCell*)[tableView dequeueReusableCellWithIdentifier:idfCell];
    if(topcell==nil)
    {
        topcell=[[[NSBundle mainBundle]loadNibNamed:@"GroupInfoCell" owner:self options:nil] lastObject];
    }
    topcell.titleShow.text=_groupAll[indexPath.section][indexPath.row];
    
    
    if(indexPath.section==0&&indexPath.row==0)//名字标签的显示
    {
        topcell.nameShow.hidden=NO;
    }else
    {
        topcell.nameShow.hidden=YES;
    }
    if(indexPath.section==0||indexPath.section==2)//此行要显示点击
    {
        topcell.clickimg.hidden=NO;
    }else
    {
        topcell.clickimg.hidden=YES;
    }
    if(indexPath.section==1||indexPath.section==2)//要显示开关按钮
    {
        topcell.switchClickimg.hidden=NO;
    }
    else{
        topcell.switchClickimg.hidden=YES;
    }
    
    //以上控制显示和不显示的控件
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        topcell.nameShow.text=@"ios交流群";
    }
    
    
    return topcell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
