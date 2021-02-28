function [x_l,x_h] = Filter_GEI(opt,option)
    [x,y]=opt.find_GEI(10);
        x0=x;
        x1=[];
        idx1 = cumsum(opt.add_record,1);
        idx2 = [0;idx1(1:end-1,2)]+1;
        idx2 = [idx2,idx1(:,2)];
        mm=[];
        for ii=1:opt.Sample.gen+1
            if idx2(ii,1)<=idx2(ii,2)
                mm = [mm;mean(opt.Sample.values_h(idx2(ii,1):idx2(ii,2)))];
            end
        end
        mm = mean(mm);
        ww=1/(sqrt(opt.Model.GP{2}.getProcessVariance()/opt.Model.GP{1}.getProcessVariance())+1);
        
        for i=1:size(y,1)
            if y(i) <= opt.y_min*ww + mm*(1-ww)
                x1=[x1;x(i,:)];
            end
        end
        
        if size(x1,1)>1
            x2=opt.cluster2(x1,option.cluster_h*sqrt(opt.Sample.dimension));
        else
            x2=x1;
        end
        
        s=[];
        for ii=1:size(x2,1)
            a = x-x2(ii);
            s  = [s;find(a(:,1)==0)];
        end
        x0(s,:)=[];
        
        x0=opt.cluster3(x0,option.cluster_l*sqrt(opt.Sample.dimension));
        
        x_h = x2;
        x_l = x0;
end