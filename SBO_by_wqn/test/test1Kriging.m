clc;clear;

%data = load('D:\Users\ASUS\Desktop\AVAL.txt');
%data = load('D:\Users\ASUS\Desktop\AVFE.txt');
%data = load('D:\Users\ASUS\Desktop\AVHT.txt');
data = load('D:\Users\ASUS\Desktop\TEST.txt');
samp = load('D:\Users\ASUS\Desktop\sample_100000.txt');
  %sam = Sample('mult','hartmann_3D','MA3',0.38,18,9);
     %sam = Sample('high','ackley',50);
    %mod = oodacefit( sam.points, sam.values,struct());
    %mod = krigingfamily( sam.points, sam.values,'Kriging');
    %mod = krigingfamily( sam.points, sam.values,'HierarchicalKriging');
    mod = krigingfamily( data(:,1:4), data(:,5),'Kriging');
%    mod = krigingfamily( sam.points, sam.values,'Kriging');
%     opt = Iteration(sam,mod);
%     
%     mod.alpha
%     
%     mod.GP{1}.getHyperparameters()
%     mod.getHyperparameters()
%      %plotKrigingModel(mod)
%      
%      mod.sigma2
%      mod.GP{1}.sigma2
%[x0,y0]=opt.find_GEI(10);
%[x1,y1]=opt.select_GEI('high');

a = mod.predict(samp);
%  R = full(mod.C*mod.C');
%  rt = inv(R);
%  
  path1 = 'D:\Users\ASUS\Desktop\TEST_result.dat';
%  path2 = 'D:\Users\ASUS\Desktop\R^(-1).dat';
%  
  wdat(a,path1);
%  wdat(rt,path2);
 
 sam = Sample('high','E3',0);
sam.put_in('all_h',data);

mod = oodacefit( sam.points, sam.values, struct());
opt = Iteration(sam,mod);

    %======================================================
 %sam = Sample('mult','branin',30,20);
%  sam = Sample('high','branin',200);
%   mod = oodacefit( sam.points, sam.values, struct());
%   opt = Iteration(sam,mod);
  %=======================================================
  %ano = Cokriging_ANOVA(opt.Sample,opt.Model);
 ano = ANOVA_k(opt.Sample,opt.Model); 
 %  ano.get_miu([])
  
 xx=0:0.005:1;
 y=zeros(ano.dimension,size(xx,2));
 
 xc = ones(ano.dimension*2,size(xx,2));
 for ii = 1:ano.dimension
 xc(2*ii-1,:)=xc(2*ii-1,:)*ii;
 end
 for ii = 1:ano.dimension
 xc(2*ii,:)=xx;
 end
 xcc = mat2cell(xc,linspace(2,2,ano.dimension),linspace(1,1,size(xx,2)));
 
 ya =cellfun(@ano.get_miu,xcc);

yy = ya-ano.get_miu([]);
yy = yy.*yy;
s = sum(yy,2)/size(xx,2);
sqrt(sum(s)/4);