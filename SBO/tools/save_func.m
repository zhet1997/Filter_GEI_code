clc;clear;
%2018-12-20
%这个函数的作用是储存与选择不同的测试函数
%1forrester 
%2branin   y_min=0.397887 at(-pi,12.275);(pi,2.275);(9.42478,2.475)
%3hartmann-3D  y_min=-3.86278 at(0.114614,0.555649,0.852547)
%4colville    y_min=0 at(1,1,1,1)
%5shekel    m=5 y_min=-10.1532 at（4,4,4,4）
%6goldstein-price   y_min=3  at(0,-1);
%7hartmann-6D   


 k='forrester';
% switch k %确定各个函数的可行域
%     case 'forrester'
%         g=[0,1];
%     case 'branin'
%         g=[-5 10;0 15];
%     case 'hartmann_3D'
%         g=[0,1;0,1;0,1];
%     case 'colville'
%         g=[-10 10;-10 10;-10 10;-10 10];
%     case 'shekel'
%         g=[0,10;0,10;0,10;0,10];
%     case 'goldstein_price'
%         g=[-2,2;-2,2];
%     case 'hartmann_6D'
%         g=[0,1;0,1;0,1;0,1;0,1;0,1];
% end
% 
% 
% load(['E:\ooDACE\Append_by_wqn\data\',k,'.mat']);
%  eval(['a=',k,'.best_location']); 
%   eval(['b=',k,'.dimension']); 
% 
% for i= 1:1
%     for j = 1:b
%     
%     a(i,j) = (a(i,j)-g(j,1))/(g(j,2)-g(j,1))     ;  
%     end
% end
% eval([k,'.best_location_nor=[];']);
% eval([k,'.best_location_nor=a;']);
% save(['E:\ooDACE\Append_by_wqn\data1\',k,'.mat'],k);
forrester.dimension = 1;
forrester.best_value = -6.020740;
forrester.best_location = 0.75725;
forrester.best_location_nor = 0.75725;
% hartmann_6D.dimension = 6;
% hartmann_6D.best_value = -3.32237;
% hartmann_6D.best_location = [0.20169,0.150011,0.476874,0.275332,0.311652,0.6573];
% hartmann_6D.best_location_nor = [0.20169,0.150011,0.476874,0.275332,0.311652,0.6573];
% k='hartmann_6D';
 save(['E:\ooDACE\Append_by_wqn\data_about_testfunc\',k,'.mat'],k);


% clc;clear;
% density=20;
% dimension=5;
% for i=1:dimension
%     eval(['x',num2str(i),'=linspace( 0, 1, density );'])
%   
% end
%     gridx = makeEvalGrid( {x1 x2 x3 x4 x5} );
%  
% for i=1:density^dimension
% [gridy2(i)] = Testmodel( gridx(i,:),'ackley' );
% 
% end
% mean=sum(gridy2)/(density^dimension);
% 
% mse=sqrt(sum((gridy2-mean).^2)/(density^dimension));

