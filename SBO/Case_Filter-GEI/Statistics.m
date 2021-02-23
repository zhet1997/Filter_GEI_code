%2019-8-30
%一个小工具，统计计算后的结果
%clc;clear;
%直接改成一个类，以一组多个的算例为整体对象
%包含统计，绘图，输出等功能
classdef Statistics<handle
    properties
        filename %统计的对象对应的参数文件名
        times = 10; %统计对象的个体数目
        times_valid = 0;%有效文件个数
        
        %index
    end
    properties
        node_optimal
        node_hf
        
        dus_file = cell(0,0)
        error_file = cell(0,0)
    end
    properties
        av_par%平均数
        std_par%方差
        
        av_par_node%平均数
        std_par_node%方差
        
        jump_par
    end
    properties%(Access=private)
        %path_index = 'E:\dataset_20190829\option_bag6\';%参数文件路径
        %path_result = 'E:\dataset_20190829\';%结果文件路径
        path_result = 'D:\Users\ASUS\Desktop\英语论文\dataset_final\';%结果文件路径
        path_putout = 'D:\Users\ASUS\Desktop\';%输出文件路径
        path_dus = 'D:\Users\ASUS\Desktop\';%问题文件路径
        
        all_opt
        all_par
        all_iter
        all_node%停止节点数据
        all_node_undo%停止节点数据
    end
    
    methods
         function obj = Statistics(filename)
            obj.filename = filename;
            %obj.index = load([obj.path_index,filename,'.mat'],'option');
         end
         
         function load(obj)%加载中间状态
            obj.all_opt = cell(obj.times,1);
            obj.all_par = cell(obj.times,1);
            obj.all_iter = cell(obj.times,1);
            for ii = 1:obj.times
                try
                    obj.all_opt{ii,1} = load ([obj.path_result,obj.filename,'%',num2str(ii),'.mat'],'opt');%导入需要统计的所有文件
                    obj.all_opt{ii,1} = obj.all_opt{ii,1}.opt;
                    %转化参数
                    if isempty(obj.all_opt{ii,1}.add_record)== 1||...
                        size(obj.all_opt{ii,1}.add_record,1)<size(obj.all_opt{ii,1}.cost_record,2)
                    dim = obj.all_opt{ii,1}.Sample.dimension;%维度信息
                    record = obj.all_opt{ii,1}.cost_record;%加点信息
                    record2 = [dim*3.6,record(1:end-1)];
                    hf = floor(record-record2);
                    lf = mod(record-record2,1);
                    temp = [lf'*10,hf'];
                    obj.all_opt{ii,1}.add_record = [dim*6,dim*3;temp];
                    
                    
                    end
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
                    obj.all_iter{ii,2} = obj.all_opt{ii,1}.cost_record;%加点消耗为横坐标
                    %============================================================
                    obj.all_iter{ii,3} = obj.all_opt{ii,1}.value_min_record;%最小值
                    obj.all_iter{ii,4} = obj.all_opt{ii,1}.error_location_record;%与最优值点距离  
                    obj.all_iter{ii,5} = cumsum(obj.all_opt{ii,1}.add_record(:,2)');%加入的高精度样本总数
                    obj.all_iter{ii,6} = cumsum(obj.all_opt{ii,1}.add_record(:,1)');%加入的低精度样本总数
                catch
                    %disp([obj.filename,'%',num2str(ii),'没有对应的结果文件']);
                    obj.error_file = [obj.error_file;{obj.filename,num2str(ii)}];
                end              
            end         
         end
        
         function node_value(obj)%根据节点取中间值
             %当按最优值取节点
             obj.all_node = cell(obj.times,1);
             obj.all_node_undo = cell(obj.times,1);
             for ii = 1:obj.times
                 if  isempty(obj.all_opt{ii,1})
                     continue;
                 end
                 if obj.all_iter{ii,3}(end)<=obj.node_optimal%如果最小值满足要求
                     kk = 0;
                     while obj.all_iter{ii,3}(end-kk)<=obj.node_optimal && kk<length(obj.all_iter{ii,3})-1
                         kk=kk+1;
                         %disp(kk);
                     end%
                      %计算满足要求时的数据
                      if kk==0
                          obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk;%迭代次数
                      else
                     obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk+1;%迭代次数
                      end
                     obj.all_node{ii,2} = obj.all_iter{ii,3}(obj.all_node{ii,1});%最优值
                     obj.all_node{ii,3} = obj.all_iter{ii,5}(obj.all_node{ii,1}+1);%HF
                     obj.all_node{ii,4} = obj.all_iter{ii,6}(obj.all_node{ii,1}+1);%LF
                     
                     obj.times_valid = obj.times_valid + 1;
                 else
                     disp(['算例未达到最优值标准',num2str(obj.all_iter{ii,3}(end)),'  ',num2str(obj.node_optimal)]);
                     obj.dus_file = [obj.dus_file;{obj.filename,num2str(ii),length(obj.all_iter{ii,3})}];
                     dim = obj.all_opt{ii,1}.Sample.dimension;%维度信息
                     
                        
%                      obj.all_node_undo{ii,1} = length(obj.all_iter{ii,3});%迭代次数
%                      obj.all_node_undo{ii,2} = obj.all_iter{ii,3}(end);%最优值
%                      obj.all_node_undo{ii,3} = obj.all_iter{ii,5}(end);%HF
%                      obj.all_node_undo{ii,4} = obj.all_iter{ii,6}(end);%LF
                     if length(obj.all_iter{ii,3})>=dim*15
                     obj.all_node_undo{ii,1} = dim*15;%迭代次数
                     elseif length(obj.all_iter{ii,3})<=dim*15
                            obj.all_node_undo{ii,1} =  length(obj.all_iter{ii,3});
                     else
                         
                         obj.all_node_undo{ii,1} = dim*5;
                     end
                     obj.all_node_undo{ii,2} = obj.all_iter{ii,3}(obj.all_node_undo{ii,1});%最优值
                     obj.all_node_undo{ii,3} = obj.all_iter{ii,5}(obj.all_node_undo{ii,1}+1);%HF
                     obj.all_node_undo{ii,4} = obj.all_iter{ii,6}(obj.all_node_undo{ii,1}+1);%LF
                     
                 end
             end
             
             
             %当按高精度点个数取节点
         end
         
         function node_point(obj)%根据节点取中间值
                 
             %当按高精度点个数取节点
             obj.all_node = cell(obj.times,1);
             for ii = 1:obj.times
                  if  isempty(obj.all_opt{ii,1})
                     continue;
                 end
                 if obj.all_iter{ii,5}(end)>=obj.node_hf%如果HF加点数满足要求
                     kk = 0;
                     while obj.all_iter{ii,5}(end-kk)>=obj.node_hf
                         kk=kk+1;
                     end%
                      %计算满足要求时的数据
                     if kk==0
                          obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk;%迭代次数
                      else
                     obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk+1;%迭代次数
                      end
                     obj.all_node{ii,2} = obj.all_iter{ii,3}(obj.all_node{ii,1});%最优值
                     obj.all_node{ii,3} = obj.all_iter{ii,5}(obj.all_node{ii,1});%HF
                     obj.all_node{ii,4} = obj.all_iter{ii,6}(obj.all_node{ii,1});%LF
                 else
                     disp(['算例未达到加点个数标准',num2str(obj.all_iter{ii,5}(end)),'  ',num2str(obj.node_hf)]);
                     obj.dus_file = [obj.dus_file;{obj.filename,num2str(ii)}];
                 end
             end
             
         
         end
        
         function get_av(obj)%计算平均值
             obj.av_par = mean(cell2mat(obj.all_par(:,1:end-1)),1);
             obj.std_par = std(cell2mat(obj.all_par(:,1:end-1)),0,1);
         end
         
         function get_av_node(obj)%计算平均值
             obj.av_par_node = mean(cell2mat(obj.all_node(:,1:end)),1);
             obj.std_par_node = std(cell2mat(obj.all_node(:,1:end)),0,1);
             %             try
             %                 obj.jump_par = [0,0];
             %                 for ii = 1:size(obj.all_par,1)
             %                     if strcmp(obj.all_par(ii,end),'error')==1
             %                         obj.jump_par = obj.jump_par+[1,0];
             %                     else
             %                         obj.jump_par = obj.jump_par+[0,1];
             %                     end
             %
             %                 end
             %             catch
             %                 disp([obj.filename,'出错']);
             %             end
         end
        
        function draw(obj)           
            for ii = 1:obj.times
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'r-','LineWidth',2);hold on;
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'ro');hold on;
            end
        end      
        function out(obj,xlsname)%将结果输出到excel文件
            
%             %读取目前的文件行数
%             box = xlsread([obj.path_putout,xlsname,'.xlsx']);
%             ii = size(box,1)+1;           
%             %写入新的结果           
%             %box = [obj.av_par,obj.std_par,obj.jump_par];
%             box = obj.av_par_node;
%             box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
%             box = [obj.filename,box,num2str(obj.times_valid)];
%             xlswrite([obj.path_putout,xlsname,'.xlsx'],box,1,['A',num2str(ii)]);
            
            %写出问题文件结果   
            wdat(obj.dus_file,[obj.path_dus,'dus_1.txt'],'at');
            wdat(obj.error_file,[obj.path_dus,'error_1.txt'],'at');
        end
        
        function [y1,y2] = result_record(obj)%将具体的结果输出
            y1 = cell2mat(obj.all_node(:,1:end));
            y2 = cell(obj.times,2);
            list = [];
            for ii=1:obj.times
                if isempty(obj.all_node{ii,1})==1
                   list = [list;ii];
                else
                    y2{ii,1} = obj.filename;
                    y2{ii,2} = num2str(ii);
                end
            end
            y2(list,:)=[];
        end
        
        
        function [y1,y2] = result_record_undo(obj)%将具体的结果输出
        
        y1 =  cell2mat(obj.all_node_undo(:,1:end));
        y2 = cell(obj.times,2);
            list = [];
            for ii=1:obj.times
                if isempty(obj.all_node_undo{ii,1})==1
                   list = [list;ii];
                else
                    y2{ii,1} = obj.filename;
                    y2{ii,2} = num2str(ii);
                end
            end
            y2(list,:)=[];
        
        end
        
        
  
        
    end
    
end