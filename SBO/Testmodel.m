%choose of test functions

%1forrester
%2branin   y_min=0.397887 at(-pi,12.275);(pi,2.275);(9.42478,2.475)
%3hartmann_3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at（4,4,4,4）
%6goldstein_price   y_min=3  at(0,-1);
%7hartmann_6D  y_min=-3.32237 at(0.20169,0.150011,0.476874,0.275332,0.311652,0.6573)
%8hartmann_4D
function [y] = Testmodel(a,i)

if size(a,1)>=2
    y = zeros(size(a,1),1);
    for num = 1:size(a,1)
        y(num,1)=Testmodel(a(num,:),i);
    end
else


switch i %the actual feasible region of test functions
    case {'forrester','forrester1a','forrester1b','forrester1c','forrester1d'}
        g=[0,1];
    case 'branin'
        g=[-5 10;0 15];
    case 'hartmann_3D'
        g=[0,1;0,1;0,1];
    case 'colville'
        g=[-10 10;-10 10;-10 10;-10 10];
    case 'shekel'
        g=[0,10;0,10;0,10;0,10];
    case 'goldstein_price'
        g=[-2,2;-2,2];
    case 'hartmann_4D'
        g=[0,1;0,1;0,1;0,1];
    case 'hartmann_6D'
        g=[0,1;0,1;0,1;0,1;0,1;0,1];
    case 'MA3'
        g=[0,1;0,1;0,1];
    case 'ackley'
        g=[-2,2;-2,2;-2,2;-2,2;-2,2];
    case 'MA5'
        g=[-2,2;-2,2;-2,2;-2,2;-2,2];
    case 'MA6'
        g=[0,1;0,1;0,1;0,1;0,1;0,1];
    case 'sphere'
        g = [-10,5.12;-5.12,7];
end

[m,~]=size(g);
for k=1:m
    a(k)=g(k,1)+ a(k)*(g(k,2)-g(k,1));
end

switch i
    case 'forrester'   %forrester
        
        if(length(a)==1)
            x=a;
            fact1 = (6*x - 2)^2;
            fact2 = sin(12*x - 4);
            
            y = fact1 * fact2;
            %y=sin(x*(3*pi)-0.5*pi)+2;
            %y=y.*(x.^2+1)*0.5-0.7;
            
        else
            
            disp('the input vector should be 1 order');
            y=0;
        end
        
    case  'branin'   %branin
        if(length(a)==2)
            
            x1 = a(1);
            x2 = a(2);
            
            t = 1 / (8*pi);
            s = 10;
            r = 6;
            c = 5/pi;
            b = 5.1 / (4*pi^2);
            a = 1;
            
            term1 = a * (x2 - b*x1^2 + c*x1 - r)^2;
            term2 = s*(1-t)*cos(x1);
            
            y = term1 + term2 + s ;
            
        else
            disp('the input vector should be 2 order');
            y=0;
        end
    case 'hartmann_3D' %hartmann-3D
        
        if(length(a)==3)
            alpha = [1.0, 1.2, 3.0, 3.2]';
            A = [3.0, 10, 30;
                0.1, 10, 35;
                3.0, 10, 30;
                0.1, 10, 35];
            P = 10^(-4) * [3689, 1170, 2673;
                4699, 4387, 7470;
                1091, 8732, 5547;
                381, 5743, 8828];
            
            outer = 0;
            for ii = 1:4
                inner = 0;
                for jj = 1:3
                    xj = a(jj);
                    Aij = A(ii, jj);
                    Pij = P(ii, jj);
                    inner = inner + Aij*(xj-Pij)^2;
                end
                new = alpha(ii) * exp(-inner);
                outer = outer + new;
            end
            
            y = -outer;
        else
            
            disp('the input vector should be 3 order');
            y=0;
        end
        
    case 'colville' %colville
        
        if(length(a)==4)
            
            x1 = a(1);
            x2 = a(2);
            x3 = a(3);
            x4 = a(4);
            
            term1 = 100 * (x1^2-x2)^2;
            term2 = (x1-1)^2;
            term3 = (x3-1)^2;
            term4 = 90 * (x3^2-x4)^2;
            term5 = 10.1 * ((x2-1)^2 + (x4-1)^2);
            term6 = 19.8*(x2-1)*(x4-1);
            
            y = term1 + term2 + term3 + term4 + term5 + term6;
        else
            
            disp('the input vector should be 4 order');
            y=0;
        end
    case 'shekel' %shekel
        
        if(length(a)==4)
            
            m = 10;
            b = 0.1 * [1, 2, 2, 4, 4, 6, 3, 7, 5, 5]';
            C = [4.0, 1.0, 8.0, 6.0, 3.0, 2.0, 5.0, 8.0, 6.0, 7.0;
                4.0, 1.0, 8.0, 6.0, 7.0, 9.0, 3.0, 1.0, 2.0, 3.6;
                4.0, 1.0, 8.0, 6.0, 3.0, 2.0, 5.0, 8.0, 6.0, 7.0;
                4.0, 1.0, 8.0, 6.0, 7.0, 9.0, 3.0, 1.0, 2.0, 3.6];
            
            outer = 0;
            for ii = 1:m
                bi = b(ii);
                inner = 0;
                for jj = 1:4
                    xj = a(jj);
                    Cji = C(jj, ii);
                    inner = inner + (xj-Cji)^2;
                end
                outer = outer + 1/(inner+bi);
            end
            
            y = -outer;
            % y=-1/y;%对原函数进行了处理
            
            
            
        else
            
            disp('the input vector should be 4 order');
            y=0;
        end
        
    case 'goldstein_price'   %goldstein-price
        if(length(a)==2)
            x1 = a(1);
            x2 = a(2);
            
            fact1a = (x1 + x2 + 1)^2;
            fact1b = 19 - 14*x1 + 3*x1^2 - 14*x2 + 6*x1*x2 + 3*x2^2;
            fact1 = 1 + fact1a*fact1b;
            
            fact2a = (2*x1 - 3*x2)^2;
            fact2b = 18 - 32*x1 + 12*x1^2 + 48*x2 - 36*x1*x2 + 27*x2^2;
            fact2 = 30 + fact2a*fact2b;
            
            y = fact1*fact2;
            %y=log(y);
            
            
            
        else
            
            disp('the input vector should be 2 order');
            y=0;
        end
    case 'hartmann_4D' %hartmann-4D
        
        if(length(a)==4)
            alpha = [1.0, 1.2, 3.0, 3.2]';
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
                for jj = 1:4
                    xj = a(jj);
                    Aij = A(ii, jj);
                    Pij = P(ii, jj);
                    inner = inner + Aij*(xj-Pij)^2;
                end
                new = alpha(ii) * exp(-inner);
                outer = outer + new;
            end
            
            y = (1.1 - outer) / 0.839;
            
            
            
        else
            
            disp('the input vector should be 4 order');
            y=0;
        end
        
    case 'hartmann_6D' %hartmann-6D
        
        if(length(a)==6)
            alpha = [1.0, 1.2, 3.0, 3.2]';
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
            
            
        else
            
            disp('the input vector should be 6 order');
            y=0;
        end
    case 'MA3'
        
        if(length(a)==3)
            x1 = a(1);
            x2 = a(2);
            x3 = a(3);
            
            y = 0.585-0.324*x1-0.379*x2-0.431*x3-0.208*x1*x2+0.326*x1*x3+...
                0.193*x2*x3+0.225*x1^2+0.263*x2^2+0.274*x3^2;
            
            
        else
            
            disp('the input vector should be 3 order');
            y=0;
        end
    case 'MA5'
        
        if(length(a)==5)
            x1 = a(1);
            x2 = a(2);
            x3 = a(3);
            x4 = a(4);
            x5 = a(5);
            
            y = 0.585-0.00127*x1-0.00113*x2-0.00663*x3-0.0129*x4-0.0611*x5+...
                0.00526*x1*x4+0.0106*x1*x5-0.000626*x2*x4-0.00310*x2*x5-...
                0.00724*x4*x5+0.00096*x3^2+0.0124*x4^2+0.0101*x5^2;
            
            
        else
            
            disp('the input vector should be 5 order');
            y=0;
        end
        
    case 'MA6'
        %2019-9-9拟合得到
        
        if(length(a)==6)
            %             x1 = a(1);
            %             x2 = a(2);
            %             x3 = a(3);
            %             x4 = a(4);
            %             x5 = a(5);
            %             x6 = a(6);
            x=a;
            aa=[0.544395000000000,0.159842000000000,0.188574000000000,0.0237120000000000,-0.0414370000000000,0.331308000000000,-0.118131000000000,-0.263503000000000,-0.176941000000000,-0.235282000000000,-0.0371940000000000,0.0309990000000000,-0.0504020000000000,-0.0310280000000000,0.193457000000000];
           %aa=[0.544395330955741,0.159842472494060,0.188574078391369,0.0237119935335088,-0.0414366586735240,0.331308360309777,-0.118131098883321,-0.263503204883623,-0.176940554414977,-0.235282044408247,-0.0371938282940458,0.0309986351091804,-0.0504015225405714,-0.0310276066019348,0.193457210452530];
            %aa=[0.547787561807233,0.295114178095967,-0.0745803387721098,-0.191574446757387,-0.123269736949158,0.0485441188483662,-0.193165118358262,-0.145591352708831,0.366733027478020,-0.328456380121639,-0.246584994407968,-0.0495819515268610,0.281727589271937,0.485870951008948,-0.127873999324365];
            form =[0,0,0,0,0,0;...%常数项
                1,0,0,0,0,0;...
                0,1,0,0,0,0;...
                0,0,1,0,0,0;...
                0,0,0,1,0,0;...
                0,0,0,0,1,0;...
                0,0,0,0,0,1;...%一order主项
                2,0,0,0,0,0;...
                0,2,0,0,0,0;...
                0,0,0,0,2,0;...%二order主项
                1,1,0,0,0,0;...
                0,1,1,0,0,0;...
                0,0,1,0,0,1;...
                0,0,0,1,1,0;...
                1,0,0,0,0,1];
            y = sum(prod(x.^form,2).*aa',1);
            
        else
            
            disp('the input vector should be 5 order');
            y=0;
        end
        
    case 'ackley'
        
        if length(a)==5
            xx = a;
            d = length(xx);
            
            c = 2*pi;
            b = 0.2;
            a0 = 20;
            
            
            sum1 = 0;
            sum2 = 0;
            for ii = 1:d
                xi = xx(ii);
                sum1 = sum1 + xi^2;
                sum2 = sum2 + cos(c*xi);
            end
            
            term1 = -a0 * exp(-b*sqrt(sum1/d));
            term2 = -exp(sum2/d);
            
            y = term1 + term2 + a0 + exp(1);
            
        else
            
            disp('the input vector should be 5 order');
            y=0;
        end
        
    case 'forrester1a'
        if length(a)==1
            y = 10*a-10;
            y = y - 0.5* Testmodel(a,'forrester');
            %由于在Errormodel_dynamic中还要加上，所以这里计算的是差值。
        else
            
            disp('the input vector should be 1 order');
            y=0;
        end
    case 'forrester1b'
        if length(a)==1
            y = -5;
        else
            
            disp('the input vector should be 1 order');
            y=0;
        end
    case 'forrester1c'
        if length(a)==1
            
            y =Testmodel(a-0.2,'forrester')-Testmodel(a,'forrester');
        else
            
            disp('the input vector should be 1 order');
            y=0;
        end
        
    case 'forrester1d'
        if length(a)==1
            
            y =6*a-(6*a-2)^2;
            %系数范围是0.5到1.5？
        else
            
            disp('the input vector should be 1 order');
            y=0;
        end
        
        
        
    case 'sphere'
        ss = 0;
        for ii = 1:2
            xi = a(ii);
            ss = ss + (xi^2)*(2^ii);
            ss = ss + 15*sin(xi);
        end
        
        y = (ss - 1745) / 899;
        

end
end
        
end










