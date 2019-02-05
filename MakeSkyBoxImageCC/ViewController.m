//
//  ViewController.m
//  MakeSkyBoxImageCC
//
//  Created by cyw on 2018/2/5.
//  Copyright © 2018年 cyw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建一个宽100，长100*6的图片view(天空盒子图片大小:100 * 100 ,6张)
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 88, 100, 100 * 6)];
    self.imageView.center = self.view.center;
    //2.设置图片
    UIImage *cImage = [UIImage imageNamed:@"skybox2.png"];
    
    //3.加载图片
    [self.imageView setImage:cImage];
    
    //4
    [self.view addSubview:self.imageView];
    
    //处理图片
    //1.获取图片的长度
    long length = cImage.size.width/4;
    
    //2.图片顶点索引
    long indices[] = {
        length * 2, length, // 右
        0, length, // 左
        length, 0, // 上 top
        length, length * 2, // 底bottom
        length, length ,// 顶front
        length * 3, length, // 背面
    };
    
    //3.指定图片个数
    //为什么除以2？因为包含了x，y
    long faceCount = sizeof(indices)/sizeof(indices[0])/2;
    
    //4.获取图片大小 单个图片大小：length * length， 组合起来:length,length * faceCount
    CGSize imageSize = {length, length * faceCount};
    
    //5. 创建基于位图的图形上下文并使其成为当前上下文。
    UIGraphicsBeginImageContext(imageSize);
    
    for (int i = 0; i + 2 <= faceCount * 2; i += 2) {
        
        //创建图片，从CImage。CGImage，获取位置rect上的图片
        CGImageRef cgImage = CGImageCreateWithImageInRect(cImage.CGImage, CGRectMake(indices[i], indices[i + 1], length, length));
        
        //将CGImage转换为UIImage
        UIImage *tmp = [UIImage imageWithCGImage:cgImage];
        
        //绘制图片
        [tmp drawInRect:CGRectMake(0, length * i / 2, length, length)];
    }
    
    //6.获取处理好的图片
   //UIGraphicsGetImageFromCurrentImageContext 基于当前位图基于图形上下文的内容返回图像。只有在基于位图的图形上下文是当前图形上下文时，才应该调用此函数。如果目前的情况下是零或没有通过UIGraphicsBeginImageContext创建，这个函数返回nil。
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    [self.imageView setImage:finalImg];
    
    UIGraphicsEndImageContext();
    
    //打印图片信息
    NSLog(@"final:%@", [finalImg description]);
    
    //7.保存图片到沙河
    //指定图片路径
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"box.png"];
    
    //打印路径
    NSLog(@"image path:%@", path);
    
    //获取图片数据-png格式的图片数据
    //UIImagePNGRepresentation(imgData)以PNG格式返回指定图像的数据
    NSData *cImageData = UIImagePNGRepresentation(finalImg);
    
    //写入文件
    BOOL writeStatus = [cImageData writeToFile:path atomically:YES];
    
    if (writeStatus) {
        
        NSLog(@"处理天空盒子图片成功～～");
    }else {
        
        NSLog(@"处理图片失败！");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
