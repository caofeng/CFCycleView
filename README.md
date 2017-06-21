# CFCycleView
一个非常好用的无限轮播控件

使用非常简单：

CFCycleView *cycleView = [[CFCycleView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
[self.view addSubview:cycleView];


设置本地图片

[cycleView setLocationImageArray:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"]];

设置网络图片

[cycleView setRemoteImageArray:@[
@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
@"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
] placeholderImage:@"banner_2_default"];


cycleView.selectedImageIndex = ^(NSInteger index) {

NSLog(@"====%ld",index);
};
