%�ڼ����ʱ���ܾ�����GEI�е����⣬�����ó�������һ��
function yy=GEI(obj,x,gg)%����gg������GEI��g�Ĵ�С
[y,mse2] = obj.Model.predict(x);
s=sqrt(abs(mse2));
if mse2<=1e-10%������Ե���
    yy=0;
else
    u=(obj.y_min-y)/s;
    T(1)=normcdf(u,0,1);%�����T��1������ʽ�е�T0������ͬ��
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
            sum=sum+(-1)^(k)*nchoosek(gg,k)*u^(gg-k)*T(i);%2019-7-1�����Ķ���֮ǰ������
        end
        yy=(sum*s^gg)^(1/gg);
    end
    yy=-yy;
end
end

