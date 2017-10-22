function[f11,f10,f01,f00]=accuracy(a,b);
TP=0.0;
FP=0.0;
FN=0.0;
TN=0.0;
len=length(a)*(length(a)-1)/2;
for i=1:length(a)
    for j=(i+1):length(a)
        if (a(i)==a(j))&&(b(i)==b(j))
            TP=TP+1;
        else
            if(a(i)==a(j))&&(b(i)~=b(j))
                FP=FP+1;
            else
                if(a(i)~=a(j))&&(b(i)==b(j))
                    TN=TN+1;
                else
                    if(a(i)~=a(j))&&(b(i)~=b(j))
                        FN=FN+1;
                    end
                end
            end
        end
    end
end
f11=TP/len;
f10=TN/len;
f01=FP/len;
f00=FN/len;
end
