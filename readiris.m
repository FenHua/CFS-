function[returnMat,classLabelvector]=readiris(filename);
data=load(filename);
[row,col]=size(data);
returnMat=zeros(row,4);
classLabelvector=[data(:,5)];
returnMat=data(:,1:4);
end
