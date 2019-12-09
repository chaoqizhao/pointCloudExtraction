function flag = EuclideanClusterExtraction(Pts, bandWidth, numNeighbours, maxIterTimes)
% ʵ��ŷʽ�ռ�����㷨�������ӵ���������
% ����:
%     ��ά������ά��               Pts              n*m����
%     ����ʹ�õ�����뾶           bandWidth         
%     ����KDTREEʹ�õ���������   numNeighbours    
%     ����������                maxIterTimes
% �����
%     ������Ӧ�����ţ�ά��Ϊn*1��max(flag)�������õ��������
PtsSz = length(Pts);
kdtreeobj = KDTreeSearcher(Pts,'distance','euclidean');
[n,dis] = knnsearch(kdtreeobj,Pts,'k',(numNeighbours+1));
n = n(:,2:numNeighbours+1);
dis = dis(:,2:numNeighbours+1);
radius_idx = dis < bandWidth;
n = n.*radius_idx;
clear radius_idx dis Pts;
% ������ԭʼ���ݴ�С��Ӧ�ı�ǩ����
flag = zeros(PtsSz,1);
iter = 1;
while(1)
    % ����������ӵ�
    iterIdx = fix(PtsSz*rand(1));
    % ������ӵ����0������������
    while(iterIdx<1)
        iterIdx = fix(PtsSz*rand(1));
    end
    if flag(iterIdx) > 0
        continue;
    end
    % �����
    flag(iterIdx) = iter;
    % �ҵ��õ����������������Ҫ��ĵ�
    flag(n(iterIdx,n(iterIdx,:)>0)) = iter;
    % ȥ���Ѿ�����ǵĵ���ԭʼ�����е�λ��
    loc = find(flag==iter);
    lastlocSz = length(loc);
    % ��ʼ��������
    while(1)
        % ȡ���Ѿ��ǽ��������������
        nn = n(loc,:);
        % �ҵ��¾�������������0�ĵ�
        flag(nn(nn>0)) = iter;
        loc = find(flag == iter);
        currentlocSz = length(loc);
        if currentlocSz - lastlocSz < 1
            break;
        end
        lastlocSz = currentlocSz;
    end
    % ������������maxIterTimes���������еĵ㶼�Ѿ��б�ǩ����ֹͣ����
    flagbelow1 = find(flag<1);
    if (iter > maxIterTimes) || (length(flagbelow1) < 1 )
        break;
    end
    iter = iter + 1;
end