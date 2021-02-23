%在计算的时候总觉得这GEI有点问题，单独拿出来重新一遍
function yy=GEI(obj,x,gg)%这里gg代表了GEI中g的大小
[y,mse2] = obj.Model.predict(x);
s=sqrt(abs(mse2));
if mse2<=1e-10%这里可以调节
    yy=0;
else
    u=(obj.y_min-y)/s;
    T(1)=normcdf(u,0,1);%这里的T（1）代表公式中的T0，以下同理
    T(2)=-normpdf(u,0,1);
    for i=3:1:gg+1
        k=i-1;
        T(i)=-u^(k-1)*normpdf(u,0,1)+(k-1)*T(i-2);
    end
    sum=0;
    if(gg==0)
        yy=T(1);
    else
        for i=1:gg+1
            k=i-1;
            sum=sum+(-1)^(k)*nchoosek(gg,k)*u^(gg-k)*T(i);%2019-7-1做出改动，之前都错了
        end
        yy=(sum*s^gg)^(1/gg);
    end
    yy=-yy;
end
end

