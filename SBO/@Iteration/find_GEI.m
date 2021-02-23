function [xx,yy]=find_GEI(obj,gmax)
x=zeros(gmax+1,obj.Sample.dimension);
y0=zeros(gmax+1,1);
gei = cell(gmax+1,1);
fgei = cell(gmax+1,1);
for ii=1:gmax+1
    gg=ii-1;
    gei{ii,1}= @(x)obj.GEI(x,gg);
    fgei{ii,1} = @()ga(gei{ii,1},obj.Sample.dimension,[],[],[],[],obj.border(:,1),obj.border(:,2));
end
clear('gg');
parfor ii=1:gmax+1
    [a{ii,1},b{ii,1}]= fgei{ii,1}();
end
a = cell2mat(a);
b = cell2mat(b);
c = obj.Model.predict(a);

if obj.Sample.dimension==1
 s=find(b==0);
 a(s,:)=[];
 c(s,:)=[];
end

obj.EI_max=-min(b);
xx = a;
yy = c;
end