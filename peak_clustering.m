function[clustcent,data2cluster]=peakclustering(xx,percent);
N=size(xx,1)*size(xx,1);%行数
col_max=size(xx,1);
dist= squareform(pdist(xx, 'euclidean'));
%-------------------计算密度-------------------
for i=1:col_max
    density(i)=0.0;
    temp_density(i)=0.0;
end
position=round(N*percent/100);
sort_dist=sort(dist);%对所距离排序（升）
radius=sort_dist(position);%高斯函数使用
% %高斯函数
for i=1:(col_max-1)
    for j=(i+1):col_max
        density(i)=density(i)+exp(-0.5*(dist(i,j)/radius)*(dist(i,j)/radius));
        %高斯核函数求密度
        density(j)=density(j)+exp(-0.5*(dist(i,j)/radius)*(dist(i,j)/radius));
    end
end
%%
dist_max=max(max(dist));%得到最大距离
[sort_density,sort_index]=sort(density,'descend');%将密度降序排列，并返回下标
%----------------------选出密度比点大的最小距离点-------------------
d_dist(sort_index(1))=-1.0;
d_dist_index(sort_index(1))=0;
for i=2:col_max
    d_dist(sort_index(i))=dist_max;
    for j=1:(i-1)
        if(dist(sort_index(i),sort_index(j))<d_dist(sort_index(i)))
            d_dist(sort_index(i))=dist(sort_index(i),sort_index(j));
            d_dist_index(sort_index(i))=sort_index(j);
        end
    end
end
d_dist(sort_index(1))=max(d_dist(:));
%---------------------手工选取阈值---------------------
disp('选择一个可以包住类中心的矩形')
scrsz=get(0,'Screensize');%0为句柄
figure('position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
subplot(2,1,1);
tt=plot(density(:),d_dist(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title('Decision Graph','FontSize',15.0)
xlabel('density')
ylabel('d_dist')
subplot(2,1,1);
rect=getrect(1);%getrect 从图中用鼠标截取一个矩形区域， rect 中存放的是
density_min=rect(1);
d_dist_min=rect(2);

%------------------------------聚类---------------------------
for i=1:col_max
    clust_label(i)=-1;
end
clust_num=0;
for i=1:col_max
     %------------人工方法
   if((density(i)>density_min)&&(d_dist(i)>d_dist_min))
        clust_num=clust_num+1;
        clust_label(i)=clust_num;
        i_clust_label(clust_num)=i;%逆映射，第clust_num 个 cluster 的中心为第 i 号数据点
    end
end
% % %%%%%%%%%%%%%%%%%%%%%%%
[select_dist,dist_index]=sort(d_dist,'descend');
dist_var=0.0;
max_numb=0.0;
%% --------------聚类
   
for i=1:col_max
    if(clust_label(sort_index(i))==-1)
        clust_label(sort_index(i))=clust_label(d_dist_index(sort_index(i)));
        %前提必须为倒序
    end
end
for i=1:clust_num
    clustcent(i)=i_clust_label(i);
end
data2cluster=clust_label;
%---------------------------离群点识别-----------------------
for i=1:col_max
    halo(i)=clust_label(i);
end
if(clust_num>1)
    for i=1:clust_num
        border_density(i)=0;%边界点初始化为0
    end
    for i=1:(col_max-1)
        for j=(i+1):col_max
            if((clust_label(i)~=clust_label(j))&&(dist(i,j)<=radius))
                density_aver=(density(i)+density(j))/2;%取平均值
                if(density_aver>border_density(clust_label(i)))
                    border_density(clust_label(i))=density_aver;
                end
                if(density_aver>border_density(clust_label(j)))
                    boder_density(clust_label(j))=density_aver;
                end
            end
        end
    end
    for i=1:col_max
        if(density(i)<border_density(clust_label(i)))
            halo(i)=0;
        end
    end
end
for i=1:clust_num
    nc=0; % 用于累计当前 cluster 中数据点的个数  
    nh=0; % 用于累计当前 cluster 中核心数据点的个数  (去除离群点)
    for j=1:col_max
        if(clust_label(j)==i)
            nc=nc+1;
        end
        if(halo(j)==i)
            nh=nh+1;
        end
    end
    fprintf('类: %i 中心点: %i 元素数为: %i 去离群点数为: %i outlier为: %i \n',i,i_clust_label(i),nc,nh,nc-nh);
end
end