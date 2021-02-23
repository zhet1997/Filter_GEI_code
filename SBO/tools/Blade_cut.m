%2019-6-26
classdef Blade_cut
    %叶栅截面信息
    
    
    properties%共有18个参数%输入的信息
        leading_rad%前缘半径
        trailing_rad%尾缘半径
        zchord%轴向弦长
        rad_dist_angle%圆心连接角
        flow_input_angle%进口几何角
        up_input_angle%进口上楔角
        down_input_angle%进口下楔角
        leading_correct%前缘修正
        flow_output_angle%有效出气角
        output_deflect_angle%出口偏转角
        relate%关联系数
        output_angle%出口楔角
        sle1
        sle2
        ste1
        ste2
        pe1
        pe2
        
        
        
        
        t=44.5;%节距
        
        
    end
    
    properties(Dependent)%求得的信息
        %坐标位置
        p1=[0,0];%尾缘圆圆心
        p2%前缘圆圆心
        p3%大圆圆心
        
        c1%大圆切点1
        c2%大圆切点2
        c3%尾缘圆切点
        c4%大圆切点3
        
        k1%吸力面中间控制点，最关键的点
        
        g1%关联点
        
        
        %重要长度
        r_b%大圆半径
        
        %重要角度%直接以弧度制保存
        an1%公切线角度
        an2%尾缘吸力面切线角
        an_k%关键切点角度
        
    end
    
    properties(Dependent)%7个重要控制点
        %前缘圆上两个
        l1
        l2
        %后缘圆上两个
        t1
        t2
        %吸力面上3个
        pr1%吸力面压力面弄反了。。。。
        pr2
        pr3
        %压力面上1个
        s1
    end
    
    properties(Dependent)%6个贝塞尔中间控制点
        %吸力面上有4个
        sb1
        sb2
        sb3
        sb4
        %压力面上有2个
        pb1
        pb2
        
    end
    methods
        function obj = Blade_cut(para)
            para = [para;zeros(18-size(para,1),1)];
            
            obj.leading_rad = para(1);%前缘半径
            obj.trailing_rad = para(2);%尾缘半径
            obj.zchord = para(3)-para(1)- para(2);%轴向弦长
            obj.rad_dist_angle = para(4);%圆心连接角
            obj.flow_input_angle = para(5);%进口几何角
            obj.up_input_angle = para(6);%进口上楔角
            obj.down_input_angle = para(7);%进口下楔角
            obj.leading_correct = para(8);%前缘修正
            obj.flow_output_angle = para(9);%有效出气角
            obj.output_deflect_angle = para(10);%出口偏转角
            obj.relate = para(11);%关联系数
            obj.output_angle = para(12);%出口楔角
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
            an1 = asin((obj.trailing_rad+obj.r_b)/obj.t);%直接以弧度制保存
        end
        
        function an2 = get.an2(obj)
            an2 = 0.5*pi-asin((obj.trailing_rad+obj.r_b)/obj.t)+ obj.output_deflect_angle*pi/180;%直接以弧度制保存
        end
        
        function an_k = get.an_k(obj)
            an_k = atan((obj.c4(2)-obj.g1(2))/(obj.g1(1)-obj.c4(1)));%直接以弧度制保存
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
            an9 = 0.5*pi-obj.an1-obj.output_angle/180*pi;%尾缘下切线半径与y夹角
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
        function  [y] = newp(~,p1,an1,p2,an2) %求两线交点的函数，p为点坐标，an为从x轴+出发的角度
            aa = [tan(an1),tan(an2);1,1];
            xx =  aa\[p2(2)-p1(2);p2(1)-p1(1)];
            y = p1+xx(1)*[1,tan(an1)];
        end
        
        function [x,y] = bezier( ~,vertices )
            %绘制Bezier曲线
            NumPoint=size(vertices,2)-1;%点的个数
            tt=0:0.001:1;
            
            
            x=(1-tt).^(NumPoint)*vertices(1,1);
            y=(1-tt).^(NumPoint)*vertices(2,1);
            for j=1:NumPoint
                w=factorial(NumPoint)/(factorial(j)*factorial(NumPoint-j))*(1-tt).^(NumPoint-j).*tt.^(j);
                x=x+w*vertices(1,j+1);y=y+w*vertices(2,j+1);
            end
            %plot(vertices(1,:),vertices(2,:),'b');
            
           %plot(x,y,'b');hold on
           
            %取点的函数
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
        
        
        
        function  draw1(obj)%画出辅助线
           % axis([-70 20 -10 80]);
            %画尾缘圆形
            viscircles([0,0],obj.trailing_rad,'EdgeColor','b','LineWidth',1);
            viscircles(obj.p3,obj.trailing_rad,'EdgeColor','b','linestyle','-');
            %画前缘圆形
            viscircles(obj.p2, obj.leading_rad,'EdgeColor','b','LineWidth',1);
            hold on;
            %画辅助线
            plot([0,obj.p2(1)],[0,obj.p2(2)],'b-');
            %画辅助线
            plot([0,obj.c1(1)],[0,obj.c1(2)],'b-');
            %画辅助线
            plot([0,obj.c1(1)],[obj.t,obj.c1(2)],'b-');
            viscircles(obj.p3,obj.r_b,'EdgeColor','b','linestyle','-','LineWidth',1);
            
            %画公切线
            
            plot([obj.c2(1),obj.c3(1)],[obj.c2(2),obj.c3(2)],'r--');
            
            %画尾缘吸力面切线
            plot([obj.c3(1) , obj.c3(1)-cos(obj.an2)*30],[obj.c3(2)  , obj.c3(2)+sin(obj.an2)*30],'k--');
%             plot(obj.k1(1),obj.k1(2),'r*');
%             plot(obj.g1(1),obj.g1(2),'r*');
            
            plot([obj.c4(1),obj.g1(1)],[obj.c4(2),obj.g1(2)],'k--');
            
            %画前缘辅助线
            plot([obj.p2(1),obj.p2(1)-30*sin(obj.flow_input_angle/180*pi)],[obj.p2(2),obj.p2(2)-30*cos(obj.flow_input_angle/180*pi)],'b--');
            plot([obj.l1(1),obj.pr1(1)],[obj.l1(2),obj.pr1(2)],'k--');
            plot([obj.l2(1),obj.s1(1)],[obj.l2(2),obj.s1(2)],'k--');
            
            
             plot([obj.t2(1),obj.s1(1)],[obj.t2(2),obj.s1(2)],'k--');
            %结果点
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
            
            
            
            %画尾缘圆形
            viscircles([0,0],obj.trailing_rad,'EdgeColor','k','LineWidth',1);hold on
            %画前缘圆形
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
             
             %画尾缘圆形
            viscircles([0,0],obj.trailing_rad,'EdgeColor','k','LineWidth',1);
            %画前缘圆形
            viscircles(obj.p2, obj.leading_rad,'EdgeColor','k','LineWidth',1);
        end
        
        
        function databox= draw3(obj)
            %axis([-70 20 -10 80]);
            %画尾缘圆形
            %viscircles([0,0],obj.trailing_rad,'EdgeColor','b','LineWidth',1);hold on
            %画前缘圆形
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

