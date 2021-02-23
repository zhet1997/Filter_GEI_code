%2019-8-30
%一个小工具，统计计算后的结果
%clc;clear;
%直接改成一个类，以一组多个的算例为整体对象
%包含统计，绘图，输出等功能
classdef Statistics<handle
    
    properties
        filename %统计的对象对应的参数文件名
        times = 10; %统计对象的个体数目
        index
    end
    properties
        av_par%平均数
        std_par%方差
        jump_par
    end
    properties(Access=private)
        path_index = 'E:\dataset_20190829\option_bag6\';%参数文件路径
        path_result = 'E:\dataset_20190829\';%结果文件路径
        path_putout = 'E:\dataset_20190829\option_bag\';%输出文件路径
        
        all_opt
        all_par
        all_iter
    end
    
    methods
         function obj = Statistics(filename)
            obj.filename = filename;
            obj.index = load([obj.path_index,filename,'.mat'],'option');
         end
         
        function load(obj)
            obj.all_opt = cell(obj.times,1);
            obj.all_par = cell(obj.times,1);
            obj.all_iter = cell(obj.times,1);
            for ii = 1:obj.times
                try
                    obj.all_opt{ii,1} = load ([obj.path_result,obj.filename,'%',num2str(ii),'.mat'],'opt');%导入需要统计的所有文件
                    obj.all_opt{ii,1} = obj.all_opt{ii,1}.opt;
                    %提取需要的参数
                    obj.all_par{ii,1} = obj.all_opt{ii,1}.Sample.gen;%迭代次数
                    obj.all_par{ii,2} = obj.all_opt{ii,1}.Sample.number_h;%高精度总数
                    obj.all_par{ii,3} = obj.all_opt{ii,1}.Sample.number_l;%低精度总数
                    obj.all_par{ii,4} = obj.all_opt{ii,1}.best_value;%最优取值
                    obj.all_par{ii,5} = obj.all_opt{ii,1}.cost_record(end);%折算样本数
                     obj.all_par{ii,6} = obj.all_par{ii,2}/obj.all_par{ii,3};%折算样本数
                    obj.all_par{ii,7} = obj.all_opt{ii,1}.jump_out;%结束迭代方法     
                    %提取画图所需点
                    obj.all_iter{ii,1} = 1:obj.all_opt{ii,1}.Sample.gen;%迭代次数为横坐标
                    obj.all_iter{ii,2} = obj.all_opt{ii,1}.cost_record;%加点数为横坐标
                    %============================================================
                    obj.all_iter{ii,3} = obj.all_opt{ii,1}.value_min_record;%最小值
                    obj.all_iter{ii,4} = obj.all_opt{ii,1}.error_location_record;%与最优值点距离     
                catch
                    disp([obj.filename,num2str(ii),'没有对应的结果文件']);
                end              
            end         
        end
        
        function get_av(obj)%计算平均值   
            obj.av_par = mean(cell2mat(obj.all_par(:,1:end-1)),1);
            obj.std_par = std(cell2mat(obj.all_par(:,1:end-1)),0,1);
            try
                obj.jump_par = [0,0]; 
                for ii = 1:size(obj.all_par,1)
                    if strcmp(obj.all_par(ii,end),'error')==1
                        obj.jump_par = obj.jump_par+[1,0];
                    else
                        obj.jump_par = obj.jump_par+[0,1];
                    end
                    
                end
            catch
                disp([obj.filename,'出错']);
            end
        end
        
        function draw(obj)           
            for ii = 1:obj.times
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'r-','LineWidth',2);hold on;
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'ro');hold on;
            end
        end
        
        function out(obj,xlsname)%将结果输出到excel文件
            %读取目前的文件行数
            box = xlsread([obj.path_putout,xlsname,'.xlsx']);
            ii = size(box,1)+1;
            
            %写入新的结果
            
            box = [obj.av_par,obj.std_par,obj.jump_par];
            box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
            box = [obj.filename,box];
            xlswrite([obj.path_putout,xlsname,'.xlsx'],box,1,['A',num2str(ii)]);
        end
        
    end
    
end