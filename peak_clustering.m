function[clustcent,data2cluster]=peakclustering(xx,percent);
N=size(xx,1)*size(xx,1);%����
col_max=size(xx,1);
dist= squareform(pdist(xx, 'euclidean'));
%-------------------�����ܶ�-------------------
for i=1:col_max
    density(i)=0.0;
    temp_density(i)=0.0;
end
position=round(N*percent/100);
sort_dist=sort(dist);%����������������
radius=sort_dist(position);%��˹����ʹ��
% %��˹����
for i=1:(col_max-1)
    for j=(i+1):col_max
        density(i)=density(i)+exp(-0.5*(dist(i,j)/radius)*(dist(i,j)/radius));
        %��˹�˺������ܶ�
        density(j)=density(j)+exp(-0.5*(dist(i,j)/radius)*(dist(i,j)/radius));
    end
end
%%
dist_max=max(max(dist));%�õ�������
[sort_density,sort_index]=sort(density,'descend');%���ܶȽ������У��������±�
%----------------------ѡ���ܶȱȵ�����С�����-------------------
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
%---------------------�ֹ�ѡȡ��ֵ---------------------
disp('ѡ��һ�����԰�ס�����ĵľ���')
scrsz=get(0,'Screensize');%0Ϊ���
figure('position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
subplot(2,1,1);
tt=plot(density(:),d_dist(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title('Decision Graph','FontSize',15.0)
xlabel('density')
ylabel('d_dist')
subplot(2,1,1);
rect=getrect(1);%getrect ��ͼ��������ȡһ���������� rect �д�ŵ���
density_min=rect(1);
d_dist_min=rect(2);

%------------------------------����---------------------------
for i=1:col_max
    clust_label(i)=-1;
end
clust_num=0;
for i=1:col_max
     %------------�˹�����
   if((density(i)>density_min)&&(d_dist(i)>d_dist_min))
        clust_num=clust_num+1;
        clust_label(i)=clust_num;
        i_clust_label(clust_num)=i;%��ӳ�䣬��clust_num �� cluster ������Ϊ�� i �����ݵ�
    end
end
% % %%%%%%%%%%%%%%%%%%%%%%%
[select_dist,dist_index]=sort(d_dist,'descend');
dist_var=0.0;
max_numb=0.0;
%% --------------����
   
for i=1:col_max
    if(clust_label(sort_index(i))==-1)
        clust_label(sort_index(i))=clust_label(d_dist_index(sort_index(i)));
        %ǰ�����Ϊ����
    end
end
for i=1:clust_num
    clustcent(i)=i_clust_label(i);
end
data2cluster=clust_label;
%---------------------------��Ⱥ��ʶ��-----------------------
for i=1:col_max
    halo(i)=clust_label(i);
end
if(clust_num>1)
    for i=1:clust_num
        border_density(i)=0;%�߽���ʼ��Ϊ0
    end
    for i=1:(col_max-1)
        for j=(i+1):col_max
            if((clust_label(i)~=clust_label(j))&&(dist(i,j)<=radius))
                density_aver=(density(i)+density(j))/2;%ȡƽ��ֵ
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
    nc=0; % �����ۼƵ�ǰ cluster �����ݵ�ĸ���  
    nh=0; % �����ۼƵ�ǰ cluster �к������ݵ�ĸ���  (ȥ����Ⱥ��)
    for j=1:col_max
        if(clust_label(j)==i)
            nc=nc+1;
        end
        if(halo(j)==i)
            nh=nh+1;
        end
    end
    fprintf('��: %i ���ĵ�: %i Ԫ����Ϊ: %i ȥ��Ⱥ����Ϊ: %i outlierΪ: %i \n',i,i_clust_label(i),nc,nh,nc-nh);
end
end