clear
profile on 
tic %计时
%% -------------------peakclustering
[data,classLabelvector]=readiris('iris.csv');
[clustcent,data2cluster]=peak_clustering(data,4.5);
[n,m]=size(clustcent);
%% ------------------------画图
figure,clf,hold on
cVec = 'bgrcmykbgrcmykbgrcmykbgrcmyk';
for k = 1:min(m,length(cVec))
    hh=data(find(data2cluster==k),:);
    plot(hh(:,1),hh(:,2),[cVec(k) '.'])
end
title(['Fast adaptive clusting, numClust:' int2str(m)])
% end
% FM-index
fprintf('The accuracy is [f11,f10,f01,f00]\n');
[TP,TN,FP,FN]=accuracy(data2cluster,classLabelvector);
fprintf('%f,%f,%f,%f',TP,TN,FP,FN); 
fprintf('\n')
jaccard=TP/(TP+TN+FP);
fprintf('the jaccard is %f \n',jaccard)
FM=sqrt((TP/(TP+TN))*(TP/(TP+FP))); 
fprintf('the FMindex is %f\n',FM);

