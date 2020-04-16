function call_plot(completeState)
%#codegen
% Define the extrinsic functions

coder.extrinsic('pause')

if ~ishandle(1) %Initialize Figure
     figure(1);
end

set(gcf,'Visible','on');
for i = 1:length(completeState)
     clf
     PlotS2A(completeState(i,:));
     pause(1/2000)
end

end

function PlotS2A(q)
r = 0.22; % Wheel radius
q1 = q(1);
q2 = -q(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1 = q1*r;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l1 = 2;
p0 = [q1;0;0]; % Base
Rotz_q2 = RotZ(q2);
p2 = Rotz_q2*[0;1;0] * l1 + p0; % Tip of the Arm / Head
AngleWheel = q1/r;
RotWheel = RotZ(AngleWheel);

%% Arm
line([0.2+p0(1);0.2+p2(1)],[p0(2);p2(2)],  'LineWidth',10,   'Color',[1 0.4 0.1]);
hold on 

%% Cart

rectangle('Position',[p0(1)-r,p0(2)-0.2,2*r,2*r],...
    'Curvature',[1 1],'FaceColor',[0.4 0.5 0.7])
% Wheel
p_WheelCenter = p0+[0;r-0.2;0];
p1_Wheel = p_WheelCenter + RotWheel*[0;r*0.95;0];
p2_Wheel = p_WheelCenter + RotWheel*RotZ(120*pi/180)*[0;r*0.95;0];
p3_Wheel = p_WheelCenter + RotWheel*RotZ(-120*pi/180)*[0;r*0.95;0];

plot(p_WheelCenter(1),p_WheelCenter(2),'o','LineWidth',7,'Color',[0.4 0.5 0.7]*0.8)
line([p_WheelCenter(1);p1_Wheel(1)],[p_WheelCenter(2);p1_Wheel(2)],...
    'LineWidth',5,   'Color',[0.4 0.5 0.7]*0.8);
line([p_WheelCenter(1);p2_Wheel(1)],[p_WheelCenter(2);p2_Wheel(2)],...
    'LineWidth',5,   'Color',[0.4 0.5 0.7]*0.8);
line([p_WheelCenter(1);p3_Wheel(1)],[p_WheelCenter(2);p3_Wheel(2)],...
    'LineWidth',5,   'Color',[0.4 0.5 0.7]*0.8);
%% Head
p_head_left = p2-Rotz_q2*[0.2;0;0];
p_head_right = p2+Rotz_q2*[0.2;0;0];
plot(p_head_right(1),p_head_right(2),'*','LineWidth',1,   'Color',[1 0.2 0.1])
line([p_head_left(1);p_head_right(1)],[p_head_left(2);p_head_right(2)],...
    'LineWidth',10,   'Color',[0.4 0.4 0.5]);
hold on

%% Ground
rectangle('Position',[q1-4.5,-0.2-0.1,9,0.1],'FaceColor',[0.6 0.6 0.7])
%% Axis
% grid on
axis([q1-4 q1+4 -3 3])
xlabel('X')
ylabel('Y')


end

function R = RotZ(qz)
    R = [cos(qz)  -sin(qz) 0;sin(qz) cos(qz) 0; 0 0 1];
end