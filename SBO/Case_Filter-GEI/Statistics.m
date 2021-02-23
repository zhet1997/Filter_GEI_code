%2019-8-30
%һ��С���ߣ�ͳ�Ƽ����Ľ��
%clc;clear;
%ֱ�Ӹĳ�һ���࣬��һ����������Ϊ�������
%����ͳ�ƣ���ͼ������ȹ���
classdef Statistics<handle
    properties
        filename %ͳ�ƵĶ����Ӧ�Ĳ����ļ���
        times = 10; %ͳ�ƶ���ĸ�����Ŀ
        times_valid = 0;%��Ч�ļ�����
        
        %index
    end
    properties
        node_optimal
        node_hf
        
        dus_file = cell(0,0)
        error_file = cell(0,0)
    end
    properties
        av_par%ƽ����
        std_par%����
        
        av_par_node%ƽ����
        std_par_node%����
        
        jump_par
    end
    properties%(Access=private)
        %path_index = 'E:\dataset_20190829\option_bag6\';%�����ļ�·��
        %path_result = 'E:\dataset_20190829\';%����ļ�·��
        path_result = 'D:\Users\ASUS\Desktop\Ӣ������\dataset_final\';%����ļ�·��
        path_putout = 'D:\Users\ASUS\Desktop\';%����ļ�·��
        path_dus = 'D:\Users\ASUS\Desktop\';%�����ļ�·��
        
        all_opt
        all_par
        all_iter
        all_node%ֹͣ�ڵ�����
        all_node_undo%ֹͣ�ڵ�����
    end
    
    methods
         function obj = Statistics(filename)
            obj.filename = filename;
            %obj.index = load([obj.path_index,filename,'.mat'],'option');
         end
         
         function load(obj)%�����м�״̬
            obj.all_opt = cell(obj.times,1);
            obj.all_par = cell(obj.times,1);
            obj.all_iter = cell(obj.times,1);
            for ii = 1:obj.times
                try
                    obj.all_opt{ii,1} = load ([obj.path_result,obj.filename,'%',num2str(ii),'.mat'],'opt');%������Ҫͳ�Ƶ������ļ�
                    obj.all_opt{ii,1} = obj.all_opt{ii,1}.opt;
                    %ת������
                    if isempty(obj.all_opt{ii,1}.add_record)== 1||...
                        size(obj.all_opt{ii,1}.add_record,1)<size(obj.all_opt{ii,1}.cost_record,2)
                    dim = obj.all_opt{ii,1}.Sample.dimension;%ά����Ϣ
                    record = obj.all_opt{ii,1}.cost_record;%�ӵ���Ϣ
                    record2 = [dim*3.6,record(1:end-1)];
                    hf = floor(record-record2);
                    lf = mod(record-record2,1);
                    temp = [lf'*10,hf'];
                    obj.all_opt{ii,1}.add_record = [dim*6,dim*3;temp];
                    
                    
                    end
                    %��ȡ��Ҫ�Ĳ���
                    obj.all_par{ii,1} = obj.all_opt{ii,1}.Sample.gen;%��������
                    obj.all_par{ii,2} = obj.all_opt{ii,1}.Sample.number_h;%�߾�������
                    obj.all_par{ii,3} = obj.all_opt{ii,1}.Sample.number_l;%�;�������
                    obj.all_par{ii,4} = obj.all_opt{ii,1}.best_value;%����ȡֵ
                    obj.all_par{ii,5} = obj.all_opt{ii,1}.cost_record(end);%����������
                     obj.all_par{ii,6} = obj.all_par{ii,2}/obj.all_par{ii,3};%����������
                    obj.all_par{ii,7} = obj.all_opt{ii,1}.jump_out;%������������     
                    %��ȡ��ͼ�����
                    obj.all_iter{ii,1} = 1:obj.all_opt{ii,1}.Sample.gen;%��������Ϊ������
                    obj.all_iter{ii,2} = obj.all_opt{ii,1}.cost_record;%�ӵ�����Ϊ������
                    %============================================================
                    obj.all_iter{ii,3} = obj.all_opt{ii,1}.value_min_record;%��Сֵ
                    obj.all_iter{ii,4} = obj.all_opt{ii,1}.error_location_record;%������ֵ�����  
                    obj.all_iter{ii,5} = cumsum(obj.all_opt{ii,1}.add_record(:,2)');%����ĸ߾�����������
                    obj.all_iter{ii,6} = cumsum(obj.all_opt{ii,1}.add_record(:,1)');%����ĵ;�����������
                catch
                    %disp([obj.filename,'%',num2str(ii),'û�ж�Ӧ�Ľ���ļ�']);
                    obj.error_file = [obj.error_file;{obj.filename,num2str(ii)}];
                end              
            end         
         end
        
         function node_value(obj)%���ݽڵ�ȡ�м�ֵ
             %��������ֵȡ�ڵ�
             obj.all_node = cell(obj.times,1);
             obj.all_node_undo = cell(obj.times,1);
             for ii = 1:obj.times
                 if  isempty(obj.all_opt{ii,1})
                     continue;
                 end
                 if obj.all_iter{ii,3}(end)<=obj.node_optimal%�����Сֵ����Ҫ��
                     kk = 0;
                     while obj.all_iter{ii,3}(end-kk)<=obj.node_optimal && kk<length(obj.all_iter{ii,3})-1
                         kk=kk+1;
                         %disp(kk);
                     end%
                      %��������Ҫ��ʱ������
                      if kk==0
                          obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk;%��������
                      else
                     obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk+1;%��������
                      end
                     obj.all_node{ii,2} = obj.all_iter{ii,3}(obj.all_node{ii,1});%����ֵ
                     obj.all_node{ii,3} = obj.all_iter{ii,5}(obj.all_node{ii,1}+1);%HF
                     obj.all_node{ii,4} = obj.all_iter{ii,6}(obj.all_node{ii,1}+1);%LF
                     
                     obj.times_valid = obj.times_valid + 1;
                 else
                     disp(['����δ�ﵽ����ֵ��׼',num2str(obj.all_iter{ii,3}(end)),'  ',num2str(obj.node_optimal)]);
                     obj.dus_file = [obj.dus_file;{obj.filename,num2str(ii),length(obj.all_iter{ii,3})}];
                     dim = obj.all_opt{ii,1}.Sample.dimension;%ά����Ϣ
                     
                        
%                      obj.all_node_undo{ii,1} = length(obj.all_iter{ii,3});%��������
%                      obj.all_node_undo{ii,2} = obj.all_iter{ii,3}(end);%����ֵ
%                      obj.all_node_undo{ii,3} = obj.all_iter{ii,5}(end);%HF
%                      obj.all_node_undo{ii,4} = obj.all_iter{ii,6}(end);%LF
                     if length(obj.all_iter{ii,3})>=dim*15
                     obj.all_node_undo{ii,1} = dim*15;%��������
                     elseif length(obj.all_iter{ii,3})<=dim*15
                            obj.all_node_undo{ii,1} =  length(obj.all_iter{ii,3});
                     else
                         
                         obj.all_node_undo{ii,1} = dim*5;
                     end
                     obj.all_node_undo{ii,2} = obj.all_iter{ii,3}(obj.all_node_undo{ii,1});%����ֵ
                     obj.all_node_undo{ii,3} = obj.all_iter{ii,5}(obj.all_node_undo{ii,1}+1);%HF
                     obj.all_node_undo{ii,4} = obj.all_iter{ii,6}(obj.all_node_undo{ii,1}+1);%LF
                     
                 end
             end
             
             
             %�����߾��ȵ����ȡ�ڵ�
         end
         
         function node_point(obj)%���ݽڵ�ȡ�м�ֵ
                 
             %�����߾��ȵ����ȡ�ڵ�
             obj.all_node = cell(obj.times,1);
             for ii = 1:obj.times
                  if  isempty(obj.all_opt{ii,1})
                     continue;
                 end
                 if obj.all_iter{ii,5}(end)>=obj.node_hf%���HF�ӵ�������Ҫ��
                     kk = 0;
                     while obj.all_iter{ii,5}(end-kk)>=obj.node_hf
                         kk=kk+1;
                     end%
                      %��������Ҫ��ʱ������
                     if kk==0
                          obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk;%��������
                      else
                     obj.all_node{ii,1} = length(obj.all_iter{ii,3})-kk+1;%��������
                      end
                     obj.all_node{ii,2} = obj.all_iter{ii,3}(obj.all_node{ii,1});%����ֵ
                     obj.all_node{ii,3} = obj.all_iter{ii,5}(obj.all_node{ii,1});%HF
                     obj.all_node{ii,4} = obj.all_iter{ii,6}(obj.all_node{ii,1});%LF
                 else
                     disp(['����δ�ﵽ�ӵ������׼',num2str(obj.all_iter{ii,5}(end)),'  ',num2str(obj.node_hf)]);
                     obj.dus_file = [obj.dus_file;{obj.filename,num2str(ii)}];
                 end
             end
             
         
         end
        
         function get_av(obj)%����ƽ��ֵ
             obj.av_par = mean(cell2mat(obj.all_par(:,1:end-1)),1);
             obj.std_par = std(cell2mat(obj.all_par(:,1:end-1)),0,1);
         end
         
         function get_av_node(obj)%����ƽ��ֵ
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
             %                 disp([obj.filename,'����']);
             %             end
         end
        
        function draw(obj)           
            for ii = 1:obj.times
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'r-','LineWidth',2);hold on;
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'ro');hold on;
            end
        end      
        function out(obj,xlsname)%����������excel�ļ�
            
%             %��ȡĿǰ���ļ�����
%             box = xlsread([obj.path_putout,xlsname,'.xlsx']);
%             ii = size(box,1)+1;           
%             %д���µĽ��           
%             %box = [obj.av_par,obj.std_par,obj.jump_par];
%             box = obj.av_par_node;
%             box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
%             box = [obj.filename,box,num2str(obj.times_valid)];
%             xlswrite([obj.path_putout,xlsname,'.xlsx'],box,1,['A',num2str(ii)]);
            
            %д�������ļ����   
            wdat(obj.dus_file,[obj.path_dus,'dus_1.txt'],'at');
            wdat(obj.error_file,[obj.path_dus,'error_1.txt'],'at');
        end
        
        function [y1,y2] = result_record(obj)%������Ľ�����
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
        
        
        function [y1,y2] = result_record_undo(obj)%������Ľ�����
        
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