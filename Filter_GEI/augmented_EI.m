function [x_l,x_h] = augmented_EI(opt,option)
[x1,y1,z1,s1] = opt.select_EI('high');
[x2,y2,z2,s2] = opt.select_EI('low');

alpha_1 = 1/opt.cost;
alpha_2 = sqrt(s1)/(abs(y1-y2)+sqrt(s2));
z2 = z2*alpha_1*alpha_2;

if z1>z2
    x_h = x1;
    x_l = [];
else
    x_h = [];
    x_l = x2;
end
end