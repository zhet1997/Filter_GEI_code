%2019-3-14
%此函数的作用是描述低精度与高精度函数之间的误差项
function [y] = Errormodel(a,i)

switch i
    case 1%设计空间超平面
        alpha = [10,10,1,1,1,1];%系数向量
        beta = -10 ;
        n = length(a);
        y = 0;
        for i = 1:n
            y = y + alpha(i)*a(i);
        end
        y = y + beta;
       y =Testmodel(a,'branin') + y;
      % y=10;
       
        case 2%设计空间超平面
       
        y = Testmodel(a,'hartmann_3D')+Testmodel(a,'MA3')*7.6;
        
        case 3  %forrester1a
        alpha = [10,1,1,1,1,1];%系数向量
        beta = -10;
        n = length(a);
        y = 0;
        for i = 1:n
            y = y + alpha(i)*a(i);
        end
        y = y + beta;
        %===================================
       y = y +0.5* Testmodel(a,'forrester');
%        x1=(a-0.5)*2;
%        y=sin(x1*(3*pi)-0.5*pi)-2;
%        y=y.*(x1.^2+1)*0.5+2.2;
    case 4  %forrester 1b
       
        y = Testmodel(a,'forrester')-5;
      
    case 5 %forrester 1c
        x=a+0.2;
        y = Testmodel(x,'forrester');
    case 10
         alpha = [0.5, 0.5, 2.0, 4.0]';
            A = [10, 3, 17, 3.5, 1.7, 8;
                0.05, 10, 17, 0.1, 8, 14;
                3, 3.5, 1.7, 10, 17, 8;
                17, 8, 0.05, 10, 0.1, 14];
            P = 10^(-4) * [1312, 1696, 5569, 124, 8283, 5886;
                2329, 4135, 8307, 3736, 1004, 9991;
                2348, 1451, 3522, 2883, 3047, 6650;
                4047, 8828, 8732, 5743, 1091, 381];
            
            outer = 0;
            for ii = 1:4
                inner = 0;
                for jj = 1:6
                    xj = a(jj);
                    Aij = A(ii, jj);
                    Pij = P(ii, jj);
                    inner = inner + Aij*(xj-Pij)^2;
                end
                new = alpha(ii) * exp(-inner);
                outer = outer + new;
            end
            
            y = -(2.58 + outer) / 1.94;
            
    case 6
        
        y = Testmodel(a,'ackley')+Testmodel(a,'MA5')*0.74;
end
end

