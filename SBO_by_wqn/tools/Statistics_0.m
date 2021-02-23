%2019-8-30
%һ��С���ߣ�ͳ�Ƽ����Ľ��
%clc;clear;
%ֱ�Ӹĳ�һ���࣬��һ����������Ϊ�������
%����ͳ�ƣ���ͼ������ȹ���
classdef Statistics<handle
    
    properties
        filename %ͳ�ƵĶ����Ӧ�Ĳ����ļ���
        times = 10; %ͳ�ƶ���ĸ�����Ŀ
        index
    end
    properties
        av_par%ƽ����
        std_par%����
        jump_par
    end
    properties(Access=private)
        path_index = 'E:\dataset_20190829\option_bag6\';%�����ļ�·��
        path_result = 'E:\dataset_20190829\';%����ļ�·��
        path_putout = 'E:\dataset_20190829\option_bag\';%����ļ�·��
        
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
                    obj.all_opt{ii,1} = load ([obj.path_result,obj.filename,'%',num2str(ii),'.mat'],'opt');%������Ҫͳ�Ƶ������ļ�
                    obj.all_opt{ii,1} = obj.all_opt{ii,1}.opt;
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
                    obj.all_iter{ii,2} = obj.all_opt{ii,1}.cost_record;%�ӵ���Ϊ������
                    %============================================================
                    obj.all_iter{ii,3} = obj.all_opt{ii,1}.value_min_record;%��Сֵ
                    obj.all_iter{ii,4} = obj.all_opt{ii,1}.error_location_record;%������ֵ�����     
                catch
                    disp([obj.filename,num2str(ii),'û�ж�Ӧ�Ľ���ļ�']);
                end              
            end         
        end
        
        function get_av(obj)%����ƽ��ֵ   
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
                disp([obj.filename,'����']);
            end
        end
        
        function draw(obj)           
            for ii = 1:obj.times
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'r-','LineWidth',2);hold on;
                plot(obj.all_iter{ii,1},obj.all_iter{ii,3},'ro');hold on;
            end
        end
        
        function out(obj,xlsname)%����������excel�ļ�
            %��ȡĿǰ���ļ�����
            box = xlsread([obj.path_putout,xlsname,'.xlsx']);
            ii = size(box,1)+1;
            
            %д���µĽ��
            
            box = [obj.av_par,obj.std_par,obj.jump_par];
            box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
            box = [obj.filename,box];
            xlswrite([obj.path_putout,xlsname,'.xlsx'],box,1,['A',num2str(ii)]);
        end
        
    end
    
end