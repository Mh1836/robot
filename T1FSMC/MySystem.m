clear
clc
warning off

load Myfis fis

Tall=20;
Ts=0.01;
Nt=(1/Ts)*Tall;

l1=0.3;
l2=1.3;
l3=1.2;
m1=0.46;
m2=0.34;
m3=0.34;
j1=0.04624;
j2=0.02545;
j3=0.03616;
g=9.81;

x=zeros(6,Nt);
xs=zeros(6,Nt);
e=zeros(3,Nt);
de=zeros(3,Nt);
u=zeros(3,Nt);
ur=zeros(3,Nt);
ueq=zeros(3,Nt);
S=zeros(3,Nt);
r=zeros(3,Nt);
t=0:Ts:Tall-Ts;
r(1,:)=sin(t/2);
r(2,:)=0.2+0.05*cos(t/1.5);
r(3,:)=0.1+0.1*sin(t/3);

% dr(1,:)=1*cos(t);
% dr(2,:)=-1*sin(t);
% dr(3,:)=1*cos(t);
dr=diff(r')'/Ts;
% ddr(1,:)=-1*sin(t);
% ddr(2,:)=-1*cos(t);
% ddr(3,:)=-1*sin(t);
ddr=diff(dr')'/Ts;

Kp=10*eye(3);
Ki=40*eye(3);
Kd=1*eye(3);
xs(:,3)=[0,0,0,0,0,0]';
for k=3:Nt-2
    %% controller
    m1=0.46;
    m2=0.34;
    m3=0.34;
    e(:,k)=r(:,k)-xs(1:3,k);
    de(:,k)=(e(:,k)-e(:,k-1))/Ts;
%     S(:,k)=Kp*e(:,k)+Ki*((e(:,k)+e(:,k-1))/Ts)+Kd*((e(:,k)-e(:,k-1))/Ts);
    S(:,k)=S(:,k-1)+Kp*(e(:,k)-e(:,k-1))+Ki*e(:,k)*Ts+Kd*(e(:,k)-2*e(:,k-1)+e(:,k-2))/Ts;
    M=[j1+j2+j3+(m2+4*m3)*xs(2,k)^2 0 0;0 m2+4*m3 0;0 0 m3];
    C=[(m2+4*m3)*xs(2,k)*xs(5,k) (m2+4*m3)*xs(2,k)*xs(4,k) 0;-(m2+4*m3)*xs(2,k)*xs(4,k) 0 0;0 0 0];
    G=[0 0 -m3*g]';
    % u=inv(Kp*Co*B)*[Kp*e+Kp*Co*B*G-Kp*Co*A*x+Kp*dr];
    ueq(:,k)=((Kd*M^-1)^-1)*(Kp*(dr(:,k)-xs(4:6,k))+Ki*e(:,k)+Kd*(ddr(:,k)+(M^-1)*C*xs(4:6,k)+(M^-1)*G));
    
    Kr=evalfis(fis,[e(:,k) de(:,k)]);
    ur(:,k)=diag([Kr(1) Kr(2) Kr(3)])*1*tanh(S(:,k));
    u(:,k)=ueq(:,k)+ur(:,k);
    for i=1:3
        if u(i,k) <-10
            u(i,k)=-10;
        elseif u(i,k) >10
            u(i,k)=10;
        end
    end
    %% plant
    m1=0.46;
    m2=0.34;
    m3=0.34;
%     if k > 2/Ts && k < 5/Ts
%         m3=m3+0.1*m3*sin(k/100);
%     end
    m2=m2*0.05*sin(k/100)+m2;
    m3=m3*0.05*sin(k/120)+m3;
    
    j1=j1*0.05*sin(k/110)+j1;
    j1=j2*0.05*sin(k/200)+j2;
    j1=j3*0.05*sin(k/150)+j3;
    
    M=[j1+j2+j3+(m2+4*m3)*x(2,k)^2 0 0;0 m2+4*m3 0;0 0 m3];
    C=[(m2+4*m3)*x(2,k)*x(5,k) (m2+4*m3)*x(2,k)*x(4,k) 0;-(m2+4*m3)*x(2,k)*x(4,k) 0 0;0 0 0];
    G=[0 0 -m3*g]';
   
    A=[zeros(3) eye(3);zeros(3) -(M^-1)*C];
    B=[zeros(3);M^-1];
    x(:,k+1)=(Ts*A+eye(6))*x(:,k)+Ts*B*(u(:,k)-G);
    for i=1:3
        xs(i,k+1)=x(i,k+1)+0.00*rand(1);
    end
    for i=4:6
        xs(i,k+1)=x(i,k+1)+0.00*rand(1);
    end
%     xs(:,k+1)=x(:,k+1);
end

%% result
sum((x(1,1:Nt)-r(1,1:Nt)).^2)
time=0:Ts:Tall-Ts;
subplot(2,3,1)
plot(time,xs(1,1:Nt),'LineWidth',1.5)
hold on
plot(time,r(1,:),'LineWidth',1.5)
% axes('position',[0.4, 0.7, 0.21, 0.18]);
% plot(time,xs(1,:),'LineWidth',1.5);
% hold on
% plot(time,r(1,:),'LineWidth',1.5)
% xlim([2 4]);
% ylim([0.95 1.05]);

subplot(2,3,2)
plot(time,xs(2,:),'LineWidth',1.5)
hold on
plot(time,r(2,:),'LineWidth',1.5)

subplot(2,3,3)
plot(time,xs(3,:),'LineWidth',1.5)
hold on
plot(time,r(3,:),'LineWidth',1.5)

subplot(2,3,4)
plot(time,u(1,:),'LineWidth',1.5)
hold on
subplot(2,3,5)
plot(time,u(2,:),'LineWidth',1.5)
hold on
subplot(2,3,6)
plot(time,u(3,:))
hold on

save('DataT1FSMC')


