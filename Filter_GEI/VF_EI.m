function  [x_l,x_h] = VF_EI(opt,option)
        [x,~,~,~,l] = opt.select_VF_EI();
        if l==2
            x_h = x;
            x_l =[];
        elseif l==1
            x_h = [];
            x_l =x;
        end
end

