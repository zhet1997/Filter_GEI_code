clc;clear;
%Ωª≤Ê—È÷§

valueList1 = [];
valueList2 = [];
data = importdata('D:\others\PHY\EngineeringTestCases\Data\Case4.mat');
for jj= 5
pointList1 = data.PointsHigh{jj,1};
pointList2 = data.PointsLow{jj,1};
list = zeros(21,1);
for ii = 1:21
    list(ii) = find(pointList2(:,1)==pointList1(ii,1));
end


valueList1 = [valueList1; data.ValuesHigh{jj,1}];
temp = data.ValuesLow{jj,1};
valueList2 = [valueList2; temp(list,:)];


pointList3 = data.PointsLow{jj,1};
pointList3(list,:)= [];

valueList3 = data.ValuesLow{jj,1};
valueList3(list,:) = [];
end
a = corr(valueList1, valueList2,'type' , 'Spearman');%,);

