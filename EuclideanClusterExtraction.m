function flag = EuclideanClusterExtraction(Pts, bandWidth, numNeighbours, maxIterTimes)
% 实现欧式空间聚类算法，多种子点区域增长
% 输入:
%     二维或者三维点               Pts              n*m矩阵
%     聚类使用的邻域半径           bandWidth         
%     建立KDTREE使用的邻域点个数   numNeighbours    
%     最大迭代次数                maxIterTimes
% 输出：
%     输入点对应的类别号，维数为n*1，max(flag)代表聚类得到的类别数
PtsSz = length(Pts);
kdtreeobj = KDTreeSearcher(Pts,'distance','euclidean');
[n,dis] = knnsearch(kdtreeobj,Pts,'k',(numNeighbours+1));
n = n(:,2:numNeighbours+1);
dis = dis(:,2:numNeighbours+1);
radius_idx = dis < bandWidth;
n = n.*radius_idx;
clear radius_idx dis Pts;
% 生成与原始数据大小对应的标签数组
flag = zeros(PtsSz,1);
iter = 1;
while(1)
    % 生成随机种子点
    iterIdx = fix(PtsSz*rand(1));
    % 如果种子点等于0，则重新生成
    while(iterIdx<1)
        iterIdx = fix(PtsSz*rand(1));
    end
    if flag(iterIdx) > 0
        continue;
    end
    % 类别标记
    flag(iterIdx) = iter;
    % 找到该点的邻域点中满足聚类要求的点
    flag(n(iterIdx,n(iterIdx,:)>0)) = iter;
    % 去除已经被标记的点在原始数据中的位置
    loc = find(flag==iter);
    lastlocSz = length(loc);
    % 开始区域增长
    while(1)
        % 取出已经是建筑物点的邻域矩阵
        nn = n(loc,:);
        % 找到新矩阵中索引大于0的点
        flag(nn(nn>0)) = iter;
        loc = find(flag == iter);
        currentlocSz = length(loc);
        if currentlocSz - lastlocSz < 1
            break;
        end
        lastlocSz = currentlocSz;
    end
    % 迭代次数大于maxIterTimes，或者所有的点都已经有标签了则停止迭代
    flagbelow1 = find(flag<1);
    if (iter > maxIterTimes) || (length(flagbelow1) < 1 )
        break;
    end
    iter = iter + 1;
end