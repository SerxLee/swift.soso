//
//  Corner_.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
// 
//  Created by Serx on 15/01/2016
//  Copyright © 2016 serx. All rights reserved.
// 

/*	
	copy from : http://www.jianshu.com/p/f970872fdc22

  	无论使用上面哪种方法，你都需要小心使用背景颜色。因为此时我们没有设置 masksToBounds
  	，因此超出圆角的部分依然会被显示。因此，你不应该再使用背景颜色，
  	可以在绘制圆角矩形时设置填充颜色来达到类似效果。

	在为 UIImageView 添加圆角时，请确保 image 属性不是 nil，否则这个设置将会无效。
*/

// 为 UIView 添加圆角
func kt_drawRectWithRoundedCorner(radius radius: CGFloat,
                                  borderWidth: CGFloat,
                                  backgroundColor: UIColor,
                                  borderColor: UIColor) -> UIImage {    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.mainScreen().scale)
    let context = UIGraphicsGetCurrentContext()

    CGContextMoveToPoint(context, 开始位置);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, x1, y1, x2, y2, radius);  // 这种类型的代码重复四次

    CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
    let output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output
}

extension UIView {
    func kt_addCorner(radius radius: CGFloat,
                      borderWidth: CGFloat,
                      backgroundColor: UIColor,
                      borderColor: UIColor) {
        let imageView = UIImageView(image: kt_drawRectWithRoundedCorner(radius: radius,
                                    borderWidth: borderWidth,
                                    backgroundColor: backgroundColor,
                                    borderColor: borderColor))
        self.insertSubview(imageView, atIndex: 0)
    }
}

// 为 UIImageView 添加圆角

extension UIImage {
    func kt_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())

        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return output
    }
}

extension UIImageView {
    /**
     / !!!只有当 imageView 不为nil 时，调用此方法才有效果

     :param: radius 圆角半径
     */
    override func kt_addCorner(radius radius: CGFloat) {
        self.image = self.image?.kt_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}

