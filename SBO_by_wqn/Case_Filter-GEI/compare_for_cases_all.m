%2020-5-11
%���¶ԱȺ�������������
%��׼1�����ﵽ�趨������ֵ��ʱ��Ϊֹͣ�ڵ㣻
%��׼2�����ﵽ�̶��ĸ߾�����������Ϊֹͣ�ڵ㣻
%������ 5*6*10=300��
%���ܳ��ֵ����⣺1.����ֹͣʱ��Ȼδ�ﵽ��׼--���������㣻2.�������ƫ��--�������滻

clc;clear;
%% ��������
optimal = [-6.020740;-6.020740;-6.020740;-3.8627;0;-3.0425];
dim = [1;1;1;3;5;6];

terminal_error = abs(optimal)*0.01;
terminal_error(5) = 0.1;
terminal_error(6) = terminal_error(6)*1;
terminal_optimal = optimal + terminal_error;

terminal_hf = dim*6;

tem = linspace(1,1,5);
temp = [tem*1,tem*2,tem*3,tem*4,tem*5,tem*6];
temp2 = [tem*1,tem*1,tem*1,tem*3,tem*5,tem*6];

%% ��ַ����
path_result = 'E:\dataset_20200524\';%��Ž���ĵ�ַ
%path_result = 'E:\dataset_20190829\';%��Ž���ĵ�ַ
path_index = 'D:\Users\ASUS\Desktop\filename.txt';%��ȡĿ¼�ĵ�ַ
%path_index = 'D:\Users\ASUS\Desktop\use_filename3.dat';%��ȡĿ¼�ĵ�ַ
path_output = 'D:\Users\ASUS\Desktop\';%�������ĵ�ַ

%% ��������
index = importdata(path_index);%������������Ŀ¼
filename = cell(30,3);
for ii = 1:30%��ԭ�ļ���
filename{ii,1} = [index.textdata{ii,1},'%',index.textdata{ii,2},'%',...
    index.textdata{ii,3},'%',index.textdata{ii,4},'%',num2str(index.data(ii,1))];
filename{ii,2} = index.data(ii,2);%�ļ�����
filename{ii,3} = index.data(ii,3);%�������
end

%% 
for ii =1:30
    %�ҳ����б��Ϊii���ļ�
    file_index = find(cell2mat(filename(:,3))==ii);
    %��¼�����ļ�������
    name_record = {index.textdata{file_index(1),2},index.textdata{file_index(1),4}};
    %��¼ÿ���ļ��Ľ��%�ĸ�ֵ
    result_record = [];
    result_record_undo = [];
    
    result_record_name = [];
    result_record_undo_name = [];
    
    times_all = 0;
    for jj = 1:length(file_index)
        filename_select = filename{file_index(jj),1}; %�ҳ���ѡ�ļ�
        
        sta = Statistics(filename_select);%��ȡ�ļ�
        sta.times =  filename{file_index(jj),2};%�����ļ�����
        times_all = times_all+sta.times;
        sta.load();
        
        sta.node_optimal=terminal_optimal(temp(ii));
        sta.node_hf =terminal_hf(temp(ii));
        
        sta.node_value();
        %sta.node_point();
        
        sta.get_av();
        sta.get_av_node();
        %sta.out('result');
        
        [y1,y2] = sta.result_record();
        [y3,y4]  = sta.result_record_undo();
        
        result_record = [result_record;y1];
        result_record_undo = [result_record_undo;y3];
        
        result_record_name = [result_record_name;y2];
        result_record_undo_name = [result_record_undo_name;y4];
        
        
        
        disp('done');
    end

    sample_dim = temp2(ii);
    select_samples(name_record,result_record,result_record_name,...
    result_record_undo,result_record_undo_name,sample_dim,ii);

    

end


function select_samples(name_record,result_record,result_record_name,...
    result_record_undo,result_record_undo_name,sample_dim,ii)
   %result_record = [result_record;result_record_undo];%%%!!!!

     sample_num = size(result_record,1);
    sample_num_initial = sample_num+size(result_record_undo,1) ; 
    sample_invalid = [];
    
    result_record = [result_record,zeros(sample_num,1)];
    for kk = 1:sample_num
        if result_record(kk,1)>= sample_dim*30||result_record(kk,3)>= sample_dim*25
            sample_invalid = [kk,sample_invalid];
        end
    end 
    result_record(sample_invalid,:)=[];%ȥ���Ƿ�����%�������������
    result_record_name(sample_invalid,:)=[];
    
    sample_num = size(result_record,1);
    sample_invalid = [];
    
    for kk = 1:sample_num
        if strcmp(name_record{1,2},'EI')==1
            %EI�мӵ�����Ӧ�����������һ��
            if result_record(kk,1)*2+sample_dim*9-result_record(kk,3)-result_record(kk,4)~=0
                sample_invalid = [kk,sample_invalid];
            end
        elseif strcmp(name_record{1,2},'VF_EI')==1||strcmp(name_record{1,2},'augmented_EI')==1
            if result_record(kk,1)+sample_dim*9-result_record(kk,3)-result_record(kk,4)~=0
                sample_invalid = [kk,sample_invalid];
            end
        end
    end 
    result_record(sample_invalid,:)=[];%ȥ���Ƿ�����%�ӵ��������ɲ����������
     result_record_name(sample_invalid,:)=[];
    %ѡ��20������
    sample_num = size(result_record,1);
    if sample_num<20&&sample_num>0
        disp('������������');
        result_record = [result_record(1:sample_num,1:4);result_record_undo(1:20-sample_num,1:4)];
        
        result_record_undo = result_record_undo(1:20-sample_num,1:4);
        
        result_record_name = [result_record_name(1:sample_num,:);result_record_undo_name(1:20-sample_num,:)];
        result_record_undo_name = result_record_undo_name(1:20-sample_num,:);
        val = sample_num;
    elseif sample_num==0
        disp('������������');
        result_record = [0,0,0,0];
        val = sample_num;
    else
        result_record_undo_name = [];
        result_record_undo = [];
    end
    %��ƽ��ֵ
    result_av = [mean(result_record(:,1:4),1)];
     result_std = std(result_record(:,1:4),0,1);
    %������
    for kk = [1,3,4]
    result_av(kk) = round(result_av(kk));
    end
    result_av(3) = roundn(result_av(3),-4);
     result_std = roundn(result_std,-4);
     
     temp3 = cell(20,1);
     temp3(:,:) = {num2str(ii)};
     result_record_name = [result_record_name ,temp3];
     
     if isempty(result_record_undo_name)==0
     result_record_undo_name = [result_record_undo_name,mat2cell(result_record_undo(:,1),linspace(1,1,size(result_record_undo(:,1),1)),1)];
     end
      wdat(result_record_name,['D:\Users\ASUS\Desktop\','valid.txt'],'at');
      wdat(result_record_undo_name,['D:\Users\ASUS\Desktop\','invalid.txt'],'at');
    
    %��ȡĿǰ���ļ�����
    boxx = xlsread(['D:\Users\ASUS\Desktop\result.xlsx'],1);
    ll = size(boxx,1)+1;
    %д���µĽ��
    
%     box = cell(1,4);
%     for kk=1:4
%     temp = [num2str(result_av(kk)),'pm',num2str(result_std(kk))];
%     box{1,kk} = temp;
%     end
    
    box = [result_av,result_std];
    box = mat2cell(box,linspace(1,1,size(box,1)),linspace(1,1,size(box,2)));
     box = [name_record{1,1},name_record{1,2},box,{sample_num_initial},{20}];
   % box = [name_record{1,1},name_record{1,2},box];
    xlswrite(['D:\Users\ASUS\Desktop\result.xlsx'],box,1,['A',num2str(ll)]);
end



