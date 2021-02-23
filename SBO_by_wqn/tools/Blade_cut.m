%2019-6-26
classdef Blade_cut
    %Ҷդ������Ϣ
    
    
    properties%����18������%�������Ϣ
        leading_rad%ǰԵ�뾶
        trailing_rad%βԵ�뾶
        zchord%�����ҳ�
        rad_dist_angle%Բ�����ӽ�
        flow_input_angle%���ڼ��ν�
        up_input_angle%������Ш��
        down_input_angle%������Ш��
        leading_correct%ǰԵ����
        flow_output_angle%��Ч������
        output_deflect_angle%����ƫת��
        relate%����ϵ��
        output_angle%����Ш��
        sle1
        sle2
        ste1
        ste2
        pe1
        pe2
        
        
        
        
        t=44.5;%�ھ�
        
        
    end
    
    properties(Dependent)%��õ���Ϣ
        %����λ��
        p1=[0,0];%βԵԲԲ��
        p2%ǰԵԲԲ��
        p3%��ԲԲ��
        
        c1%��Բ�е�1
        c2%��Բ�е�2
        c3%βԵԲ�е�
        c4%��Բ�е�3
        
        k1%�������м���Ƶ㣬��ؼ��ĵ�
        
        g1%������
        
        
        %��Ҫ����
        r_b%��Բ�뾶
        
        %��Ҫ�Ƕ�%ֱ���Ի����Ʊ���
        an1%�����߽Ƕ�
        an2%βԵ���������߽�
        an_k%�ؼ��е�Ƕ�
        
    end
    
    properties(Dependent)%7����Ҫ���Ƶ�
        %ǰԵԲ������
        l1
        l2
        %��ԵԲ������
        t1
        t2
        %��������3��
        pr1%������ѹ����Ū���ˡ�������
        pr2
        pr3
        %ѹ������1��
        s1
    end
    
    properties(Dependent)%6���������м���Ƶ�
        %����������4��
        sb1
        sb2
        sb3
        sb4
        %ѹ��������2��
        pb1
        pb2
        
    end
    methods
        function obj = Blade_cut(para)
            para = [para;zeros(18-size(para,1),1)];
            
            obj.leading_rad = para(1);%ǰԵ�뾶
            obj.trailing_rad = para(2);%βԵ�뾶
            obj.zchord = para(3)-para(1)- para(2);%�����ҳ�
            obj.rad_dist_angle = para(4);%Բ�����ӽ�
            obj.flow_input_angle = para(5);%���ڼ��ν�
            obj.up_input_angle = para(6);%������Ш��
            obj.down_input_angle = para(7);%������Ш��
            obj.leading_correct = para(8);%ǰԵ����
            obj.flow_output_angle = para(9);%��Ч������
            obj.output_deflect_angle = para(10);%����ƫת��
            obj.relate = para(11);%����ϵ��
            obj.output_angle = para(12);%����Ш��
            obj.sle1 = para(13);
            obj.sle2 = para(14);
            obj.ste1 = para(15);
            obj.ste2 = para(16);
            obj.pe1 = para(17);
            obj.pe2 = para(18);
            
        end
        
        function p2 = get.p2(obj)
            p2 = [-obj.zchord,obj.zchord*tan(obj.rad_dist_angle/180*pi)];
        end
        
        function p3 = get.p3(obj)
            p3 = [0,obj.t];
        end
        
        function c1 = get.c1(obj)
            c1 = [-obj.t*sin(obj.flow_output_angle/180*pi)*cos(obj.flow_output_angle/180*pi),obj.t - obj.t*sin(obj.flow_output_angle/180*pi)*sin(obj.flow_output_angle/180*pi)];
        end
        
        function c2 = get.c2(obj)
            c2 = [-cos(obj.an1)*obj.r_b,obj.t-sin(obj.an1)*obj.r_b];
        end
        
        function c3 = get.c3(obj)
            c3 = [cos(obj.an1)*obj.trailing_rad,sin(obj.an1)*obj.trailing_rad];
        end
        
        function c4 = get.c4(obj)
            an6 = asin((-obj.p3(1)+obj.g1(1))/(obj.p3(2)-obj.g1(2)));
            an7 = acos(obj.r_b/sqrt((obj.p3(1)-obj.g1(1))^2+(obj.p3(2)-obj.g1(2))^2));
            an8 =an7 - an6;
            c4 = [-sin(an8)*obj.r_b,-cos(an8)*obj.r_b+obj.t];
        end
        
        function k1 = get.k1(obj)
            an3 = obj.an1-obj.output_deflect_angle*pi/180;
            tt1 = obj.trailing_rad/sin(an3);
            R_p = obj.trailing_rad*(obj.t-tt1)/tt1;
            an4 = asin(R_p/obj.r_b);
            an5 = an4-an3;
            k1 = [-sin(an5)*obj.r_b,obj.t-cos(an5)*obj.r_b];
        end
        
        function g1 = get.g1(obj)
            g1 =obj.k1*(1-obj.relate)+obj.c3*obj.relate;
        end
        
        function r_b = get.r_b(obj)
            r_b = obj.t*sin(obj.flow_output_angle/180*pi);
        end
        
        function an1 = get.an1(obj)
            an1 = asin((obj.trailing_rad+obj.r_b)/obj.t);%ֱ���Ի����Ʊ���
        end
        
        function an2 = get.an2(obj)
            an2 = 0.5*pi-asin((obj.trailing_rad+obj.r_b)/obj.t)+ obj.output_deflect_angle*pi/180;%ֱ���Ի����Ʊ���
        end
        
        function an_k = get.an_k(obj)
            an_k = atan((obj.c4(2)-obj.g1(2))/(obj.g1(1)-obj.c4(1)));%ֱ���Ի����Ʊ���
        end
        %==================================================================================================
        function l1 = get.l1(obj)
            l1 = obj.p2 + [-sin(obj.up_input_angle/180*pi),cos(obj.up_input_angle/180*pi)]*obj.leading_rad ;
        end
        
        function l2 = get.l2(obj)
            l2 = obj.p2 + [-sin(obj.down_input_angle/180*pi),-cos(obj.down_input_angle/180*pi)]*obj.leading_rad ;
        end
        %========================
        function t1 = get.t1(obj)
            t1 = obj.c3 ;
        end
        
        function t2 = get.t2(obj)
            an9 = 0.5*pi-obj.an1-obj.output_angle/180*pi;%βԵ�����߰뾶��y�н�
            t2 =  [-sin(an9),-cos(an9)]*obj.trailing_rad ;
        end
        %=========================
        function pr1 = get.pr1(obj)
            pr1 = obj.newp(obj.l1,obj.up_input_angle/180*pi,obj.pr2,pi-obj.an_k) ;
        end
        
        function pr2 = get.pr2(obj)
            pr2 = obj.c4 ;
        end
        
        function pr3 = get.pr3(obj)
            pr3 = obj.g1 ;
        end
        %=========================
        function s1 = get.s1(obj)
            s1 = obj.newp(obj.l2,-obj.down_input_angle/180*pi,obj.t2,pi-obj.an2+obj.output_angle/180*pi) ;
        end
        
        %===================================================================================================
        function sb1 = get.sb1(obj)
            sb1 = obj.sle1*obj.pr1+(1-obj.sle1)*obj.l1;
        end
        
        function sb2 = get.sb2(obj)
            sb2 = obj.sle2*obj.pr1+(1-obj.sle2)*obj.pr2;
        end
        
        function sb3 = get.sb3(obj)
            sb3 = obj.ste1*obj.pr3+(1-obj.ste1)*obj.pr2;
        end
        
        function sb4 = get.sb4(obj)
            sb4 = obj.ste2*obj.pr3+(1-obj.ste2)*obj.t1;
        end
        %=================================================
        function pb1 = get.pb1(obj)
            pb1 = obj.pe1*obj.s1+(1-obj.pe1)*obj.l2;
        end
        
        function pb2 = get.pb2(obj)
            pb2 = obj.pe2*obj.s1+(1-obj.pe2)*obj.t2;
        end
        
        %=====================================================================================================
        function  [y] = newp(~,p1,an1,p2,an2) %�����߽���ĺ�����pΪ�����꣬anΪ��x��+�����ĽǶ�
            aa = [tan(an1),tan(an2);1,1];
            xx =  aa\[p2(2)-p1(2);p2(1)-p1(1)];
            y = p1+xx(1)*[1,tan(an1)];
        end
        
        function [x,y] = bezier( ~,vertices )
            %����Bezier����
            NumPoint=size(vertices,2)-1;%��ĸ���
            tt=0:0.001:1;
            
            
            x=(1-tt).^(NumPoint)*vertices(1,1);
            y=(1-tt).^(NumPoint)*vertices(2,1);
            for j=1:NumPoint
                w=factorial(NumPoint)/(factorial(j)*factorial(NumPoint-j))*(1-tt).^(NumPoint-j).*tt.^(j);
                x=x+w*vertices(1,j+1);y=y+w*vertices(2,j+1);
            end
            %plot(vertices(1,:),vertices(2,:),'b');
            
           %plot(x,y,'b');hold on
           
            %ȡ��ĺ���
            %                tt=0:0.1:1;
            %
            %                 x=(1-tt).^(NumPoint)*vertices(1,1);
            %                 y=(1-tt).^(NumPoint)*vertices(2,1);
            %                 for j=1:NumPoint
            %                     w=factorial(NumPoint)/(factorial(j)*factorial(NumPoint-j))*(1-tt).^(NumPoint-j).*tt.^(j);
            %                     x=x+w*vertices(1,j+1);y=y+w*vertices(2,j+1);
            %                 end
            %                 plot(x,y,'ko','Markersize',3)
            
        end
        
        
        
        function  draw1(obj)%����������
           % axis([-70 20 -10 80]);
            %��βԵԲ��
            viscircles([0,0],obj.trailing_rad,'EdgeColor','b','LineWidth',1);
            viscircles(obj.p3,obj.trailing_rad,'EdgeColor','b','linestyle','-');
            %��ǰԵԲ��
            viscircles(obj.p2, obj.leading_rad,'EdgeColor','b','LineWidth',1);
            hold on;
            %��������
            plot([0,obj.p2(1)],[0,obj.p2(2)],'b-');
            %��������
            plot([0,obj.c1(1)],[0,obj.c1(2)],'b-');
            %��������
            plot([0,obj.c1(1)],[obj.t,obj.c1(2)],'b-');
            viscircles(obj.p3,obj.r_b,'EdgeColor','b','linestyle','-','LineWidth',1);
            
            %��������
            
            plot([obj.c2(1),obj.c3(1)],[obj.c2(2),obj.c3(2)],'r--');
            
            %��βԵ����������
            plot([obj.c3(1) , obj.c3(1)-cos(obj.an2)*30],[obj.c3(2)  , obj.c3(2)+sin(obj.an2)*30],'k--');
%             plot(obj.k1(1),obj.k1(2),'r*');
%             plot(obj.g1(1),obj.g1(2),'r*');
            
            plot([obj.c4(1),obj.g1(1)],[obj.c4(2),obj.g1(2)],'k--');
            
            %��ǰԵ������
            plot([obj.p2(1),obj.p2(1)-30*sin(obj.flow_input_angle/180*pi)],[obj.p2(2),obj.p2(2)-30*cos(obj.flow_input_angle/180*pi)],'b--');
            plot([obj.l1(1),obj.pr1(1)],[obj.l1(2),obj.pr1(2)],'k--');
            plot([obj.l2(1),obj.s1(1)],[obj.l2(2),obj.s1(2)],'k--');
            
            
             plot([obj.t2(1),obj.s1(1)],[obj.t2(2),obj.s1(2)],'k--');
            %�����
             plot(obj.l1(1),obj.l1(2),'m.','markersize',20); hold on
            plot(obj.l2(1),obj.l2(2),'m.','markersize',20);
            plot(obj.t1(1),obj.t1(2),'m.','markersize',20);
            plot(obj.t2(1),obj.t2(2),'m.','markersize',20);
            plot(obj.pr2(1),obj.pr2(2),'m.','markersize',20);
          
        end
        
        function draw2(obj)
            %axis([-70 20 -10 80]);
             plot([0,obj.c1(1)],[obj.t,obj.c1(2)],'b-');
            viscircles(obj.p3,obj.r_b,'EdgeColor','b','linestyle','--','LineWidth',1);
            
            
            
            %��βԵԲ��
            viscircles([0,0],obj.trailing_rad,'EdgeColor','k','LineWidth',1);hold on
            %��ǰԵԲ��
            viscircles(obj.p2, obj.leading_rad,'EdgeColor','k','LineWidth',1);
            %=======================================================
            plot(obj.l1(1),obj.l1(2),'k+'); hold on
            plot(obj.l2(1),obj.l2(2),'k+');
            plot(obj.t1(1),obj.t1(2),'k.');
            plot(obj.t2(1),obj.t2(2),'k.');
            plot(obj.pr1(1),obj.pr1(2),'b.');
            plot(obj.pr2(1),obj.pr2(2),'b.');
            plot(obj.pr3(1),obj.pr3(2),'b.');
            plot(obj.s1(1),obj.s1(2),'b.');
            
            %====================================
            plot([obj.l1(1),obj.pr1(1)],[obj.l1(2),obj.pr1(2)],'k-');
            
            plot([obj.pr2(1),obj.pr1(1)],[obj.pr2(2),obj.pr1(2)],'k-');
            plot([obj.pr2(1),obj.pr3(1)],[obj.pr2(2),obj.pr3(2)],'k-');
            plot([obj.t1(1),obj.pr3(1)],[obj.t1(2),obj.pr3(2)],'k-');
            
            
            plot([obj.l2(1),obj.s1(1)],[obj.l2(2),obj.s1(2)],'k-');
            plot([obj.t2(1),obj.s1(1)],[obj.t2(2),obj.s1(2)],'k-');
            
            %===============================================
            plot([obj.sb1(1),obj.sb2(1)],[obj.sb1(2),obj.sb2(2)],'m-');
            plot([obj.sb3(1),obj.sb4(1)],[obj.sb3(2),obj.sb4(2)],'m-');
            
            plot([obj.pb1(1),obj.pb2(1)],[obj.pb1(2),obj.pb2(2)],'m-');
            
            
            v1=[obj.l1',obj.sb1' ,obj.sb2' ,obj.pr2'  ];
            [x1,y1] = obj.bezier( v1 );
            
             plot([obj.c2(1),obj.c3(1)],[obj.c2(2),obj.c3(2)],'r-','LineWidth',1);
        end
        
         function draw4(obj)
            %axis([-70 20 -10 80]);
             plot([0,obj.c1(1)],[obj.t,obj.c1(2)],'k-');
            viscircles(obj.p3,obj.r_b,'EdgeColor','k','linestyle','--','LineWidth',1);
            hold on
            
            
            
            %=======================================================
%             plot(obj.l1(1),obj.l1(2),'k.'); hold on
%             plot(obj.l2(1),obj.l2(2),'k.');
%             plot(obj.t1(1),obj.t1(2),'k.');
%             plot(obj.t2(1),obj.t2(2),'k.');
%             plot(obj.pr1(1),obj.pr1(2),'b.');
%             plot(obj.pr2(1),obj.pr2(2),'b.');
%             plot(obj.pr3(1),obj.pr3(2),'b.');
%             plot(obj.s1(1),obj.s1(2),'b.');
            
            %====================================
            plot([obj.l1(1),obj.pr1(1)],[obj.l1(2),obj.pr1(2)],'k--');
            
            plot([obj.pr2(1),obj.pr1(1)],[obj.pr2(2),obj.pr1(2)],'k--');
            plot([obj.pr2(1),obj.pr3(1)],[obj.pr2(2),obj.pr3(2)],'k--');
            plot([obj.t1(1),obj.pr3(1)],[obj.t1(2),obj.pr3(2)],'k--');
            
            
            plot([obj.l2(1),obj.s1(1)],[obj.l2(2),obj.s1(2)],'k--');
            plot([obj.t2(1),obj.s1(1)],[obj.t2(2),obj.s1(2)],'k--');
            
            %===============================================
            plot([obj.l1(1),obj.sb1(1)],[obj.l1(2),obj.sb1(2)],'r-','LineWidth',1.5);
            plot([obj.sb1(1),obj.sb2(1)],[obj.sb1(2),obj.sb2(2)],'r-','LineWidth',1.5);
             plot([obj.pr2(1),obj.sb2(1)],[obj.pr2(2),obj.sb2(2)],'r-','LineWidth',1.5);
            
               plot([obj.pr2(1),obj.sb3(1)],[obj.pr2(2),obj.sb3(2)],'b-','LineWidth',1.5);
            plot([obj.sb3(1),obj.sb4(1)],[obj.sb3(2),obj.sb4(2)],'b-','LineWidth',1.5);
             plot([obj.t1(1),obj.sb4(1)],[obj.t1(2),obj.sb4(2)],'b-','LineWidth',1.5);
             
             plot([obj.l2(1),obj.pb1(1)],[obj.l2(2),obj.pb1(2)],'g-','LineWidth',1.5);
            plot([obj.pb1(1),obj.pb2(1)],[obj.pb1(2),obj.pb2(2)],'g-','LineWidth',1.5);
            plot([obj.t2(1),obj.pb2(1)],[obj.t2(2),obj.pb2(2)],'g-','LineWidth',1.5);
            
            v1=[obj.l1',obj.sb1' ,obj.sb2' ,obj.pr2'  ];
            [x1,y1] = obj.bezier( v1 );
            
             plot([obj.c2(1),obj.c3(1)],[obj.c2(2),obj.c3(2)],'k-','LineWidth',1);
             
             %��βԵԲ��
            viscircles([0,0],obj.trailing_rad,'EdgeColor','k','LineWidth',1);
            %��ǰԵԲ��
            viscircles(obj.p2, obj.leading_rad,'EdgeColor','k','LineWidth',1);
        end
        
        
        function databox= draw3(obj)
            %axis([-70 20 -10 80]);
            %��βԵԲ��
            %viscircles([0,0],obj.trailing_rad,'EdgeColor','b','LineWidth',1);hold on
            %��ǰԵԲ��
            %viscircles(obj.p2, obj.leading_rad,'EdgeColor','b','LineWidth',1);
            v1=[obj.l1',obj.sb1' ,obj.sb2' ,obj.pr2'  ];
            [x1,y1] = obj.bezier( v1 );
            hold on
            v2=[obj.t1',obj.sb4' ,obj.sb3' ,obj.pr2'  ];
            [x2,y2] = obj.bezier( v2 );
            v3=[obj.l2',obj.pb1' ,obj.pb2' ,obj.t2'  ];
            [x3,y3] = obj.bezier( v3);
            
            databox1 = {[0,0],obj.p2;obj.trailing_rad,obj.leading_rad};
            databox2 = {x1,x2,x3;y1,y2,y3};
            databox3 = {[obj.l1(1),obj.pr2(1),obj.t1(1)];[obj.l2(1),obj.t2(1)]};
            databox = [databox1,databox2,databox3];
        end
        
       
    end
end

