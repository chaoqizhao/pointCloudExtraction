%内点
mu=[0 0 0];  %均值
S=[2 0 4;0 4 0;4 0 8];  %协方差
data1=mvnrnd(mu,S,300);   %产生300个高斯分布数据
%外点
mu=[2 2 2];
S=[8 0 0;0 8 0;0 0 8];  %协方差
data2=mvnrnd(mu,S,100);     %产生100个噪声数据
%合并数据
data=[data1',data2'];
iter = 1000; %设置迭代次数
%%% 绘制数据点
 subplot(1,2,1);plot3(data(1,:),data(2,:),data(3,:),'o');hold on; % 显示数据点
 number = size(data,2); % 总点数
 sigma = 1;%距离阈值
 pretotal=0;     %符合拟合模型的数据的个数

for i=1:iter
 %%% 随机选择三个点
     idx = randperm(number,3); 
     sample = data(:,idx); 

     %%%拟合直线方程 z=ax+by+c
     x = sample(1,:);
     y = sample(2,:);
     z = sample(3,:);

     a = ((z(1)-z(2))*(y(1)-y(3)) - (z(1)-z(3))*(y(1)-y(2)))/((x(1)-x(2))*(y(1)-y(3)) - (x(1)-x(3))*(y(1)-y(2)));
     b = ((z(1) - z(3)) - a * (x(1) - x(3)))/(y(1)-y(3));
     c = z(1) - a * x(1) - b * y(1);
     plane = [a b -1 c]

     distant=abs(plane*[data; ones(1,size(data,2))]);    %求每个数据到拟合平面的距离
     total=sum(distant<sigma);              %计算数据距离平面小于一定阈值的数据的个数

     if total>pretotal            %找到符合拟合平面数据最多的拟合平面
         pretotal=total;
         bestplane=plane;          %找到最好的拟合平面
    end  
 end
 %显示符合最佳拟合的数据
mark=abs(bestplane*[data; ones(1,size(data,2))])<sigma;%用于判断是否是内点
hold on;
k = 1;
for i=1:length(mark)
    if mark(i)
        inliers(1,k) = data(1,i);
        inliers(2,k) = data(2,i);
        plot3(data(1,i),data(2,i),data(3,i),'r+');
        k = k+1;
    end
end

 %%% 绘制最佳匹配平面
 bestParameter1 = bestplane(1);
 bestParameter2 = bestplane(2);
 bestParameter3 = bestplane(4);
 xAxis = min(inliers(1,:)):max(inliers(1,:));
 yAxis = min(inliers(2,:)):max(inliers(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
 z = bestParameter1 * x + bestParameter2 * y + bestParameter3;
 surf(x, y, z);
 title(['z =  ',num2str(bestParameter1),'x + ',num2str(bestParameter2),'y + ',num2str(bestParameter3)]);
 alpha(0.8);
 box on;
 xlim([-5 10])
 ylim([-5 10])
 zlim([-10 12])
 xlabel('x','FontSize',10)
 ylabel('y','FontSize',10)
 zlabel('z','FontSize',10)
 
 %%无噪声Ransac拟合效果
 subplot(1,2,2)
 data2=data1';
 iter = 1000; %设置迭代次数
 %%% 绘制数据点
 plot3(data2(1,:),data2(2,:),data2(3,:),'o');hold on; % 显示数据点
 number2 = size(data2,2); % 总点数
 sigma = 1;%距离阈值
 pretotal=0;     %符合拟合模型的数据的个数

for i=1:iter
 %%% 随机选择三个点
     idx = randperm(number2,3); 
     sample = data2(:,idx); 

     %%%拟合直线方程 z=ax+by+c
     x = sample(1,:);
     y = sample(2,:);
     z = sample(3,:);

     a = ((z(1)-z(2))*(y(1)-y(3)) - (z(1)-z(3))*(y(1)-y(2)))/((x(1)-x(2))*(y(1)-y(3)) - (x(1)-x(3))*(y(1)-y(2)));
     b = ((z(1) - z(3)) - a * (x(1) - x(3)))/(y(1)-y(3));
     c = z(1) - a * x(1) - b * y(1);
     plane2 = [a b -1 c]

     distant=abs(plane2*[data2; ones(1,size(data2,2))]);    %求每个数据到拟合平面的距离
     total=sum(distant<sigma);              %计算数据距离平面小于一定阈值的数据的个数

     if total>pretotal            %找到符合拟合平面数据最多的拟合平面
         pretotal=total;
         bestplane2=plane2;          %找到最好的拟合平面
    end  
 end
 %显示符合最佳拟合的数据
mark2=abs(bestplane2*[data2; ones(1,size(data2,2))])<sigma;%用于判断是否是内点
hold on;
k = 1;
for i=1:length(mark2)
    if mark2(i)
        inliers2(1,k) = data2(1,i);
        inliers2(2,k) = data2(2,i);
        plot3(data2(1,i),data2(2,i),data2(3,i),'r+');
        k = k+1;
    end
end

 %%% 绘制最佳匹配平面
 bestParameter12 = bestplane2(1);
 bestParameter22 = bestplane2(2);
 bestParameter32 = bestplane2(4);
 xAxis2 = min(inliers2(1,:)):max(inliers2(1,:));
 yAxis2 = min(inliers2(2,:)):max(inliers2(2,:));
 [x2,y2] = meshgrid(xAxis, yAxis);
 z2 = bestParameter12 * x2 + bestParameter22 * y2 + bestParameter32;
 surf(x2, y2, z2);
 title(['z =  ',num2str(bestParameter12),'x + ',num2str(bestParameter22),'y + ',num2str(bestParameter32)]);
 alpha(0.8);
 box on;
 xlim([-5 10])
 ylim([-5 10])
 zlim([-10 12])
 xlabel('x','FontSize',10)
 ylabel('y','FontSize',10)
 zlabel('z','FontSize',10)