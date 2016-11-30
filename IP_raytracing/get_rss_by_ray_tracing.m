function Power_all = get_rss_by_ray_tracing(room_x, room_y, room_z, source_x, source_y, source_z, grid_size, f)
% 射线跟踪： 输入房间大小，信号源的坐标，设置网格大小和信号频率，输出每个网格点上接收到的信号强度
% 输入参数分别为：房间尺寸x， y， z，信号源（天线）坐标（x， y， z），网格大小（输出数据的密度），单位（m）；信号的发射频率，单位（MHz）

    if nargin == 0 %无输入参数时的默认设置
        room_x = 20;
        room_y = 15;
        room_z = 4;
        source_x = 10;
        source_y = 7.5;
        source_z = 1;
        grid_size = 0.1;
        f = 2400;
    end

    room_x = 1000 * room_x;
    room_y = 1000 * room_y;
    room_z = 1000 * room_z;
    source_x = 1000 * source_x;
    source_y = 1000 * source_y;
    source_z = 1000 * source_z;
    grid_size = 1000 * grid_size;
    
    %介电常数和导电系数，参考射线跟踪相关的论文
    epsilon_c=10-1.2j;
    epsilon_w=6.1-1.2j;
    % epsilon_c=7.9-0.89j;
    % epsilon_w=6.2-0.69j;

    if room_x * room_y / grid_size^2 > 100000000
        disp('提示：程序使用大矩阵同时计算所有位置点上的信号强度，位置点设置的过多可能导致内存不足，matlab可能会卡死。');
        input('继续请回车；退出请ctrl+c');
    end

    T = 1 / (f * 10^6);
    c = 3.0e8;
    lambda=c / (f * 10^6);

    %得到空间中所有的网格点位置坐标,把z固定，和信号源一个高度
    [X, Y] = meshgrid(grid_size:grid_size:(room_x-grid_size), grid_size:grid_size:(room_y-grid_size));
    L = [X(:), Y(:)];
    L = [L, zeros(size(X(:))) + source_z];
    
    %% 直射路径
    %将反射引起的相位变化加入电场E的计算里面。后面注释所说的相位只是由于距离引起的相位。
    d_direct = sqrt((L(:,1) - source_x).^2 + (L(:,2)-source_y).^2 + (L(:,3) - source_z).^2);%每个网格点距发射源的欧式距离
    t_direct_0 = d_direct./1000./c;%直射时延
    p_direct = mod(t_direct_0*2*pi/T,2*pi);%直射相位
    E_direct = (lambda./(4.*pi.*d_direct./1000));%这里和下面的E不一定正好是场强大小，但和场强成正比
    E0=E_direct.* exp(1i.*(-p_direct));

    %%
    %上面计算的L为所有网格点的坐标。每行为一组坐标。
    %下面的Li相应的为所有网格点所对应的镜像点
    %下面对六组反射路径分别计算

    %% 前平面反射路径（前后左右上下的意思是：人站才这个长方体中，面朝y轴，这时的六个面分别称为前后左右上下）
    Li=[L(:,1) , 2.*room_y-L(:,2) , L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_1 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_1*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,2)-source_y)./(Li(:,1)-source_x)));%入射角
    reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));%反射系数也是矩阵
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E1=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。

    %% 后平面反射路径
    Li=[L(:,1) , -L(:,2) , L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_2 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_2*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,2)-source_y)./(Li(:,1)-source_x)));%入射角
    reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E2=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。

    %% 左平面反射路径
    Li=[-L(:,1) , L(:,2) , L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_3 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_3*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,1)-source_x)./(Li(:,2)-source_y)));%入射角
    reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E3=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。

    %% 右平面反射路径
    Li=[2*room_x-L(:,1) , L(:,2) , L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_4 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_4*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,1)-source_x)./(Li(:,2)-source_y)));%入射角
    reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E4=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。

    %% 上平面反射路径
    %%%2014.12.5：上下平面的反射路径进行修改，垂直极化波斜向上射的时候啊，由于方向图变小了一些，然后在分解为垂直方向的电场又要变小。
    Li=[L(:,1) , L(:,2) , 2*room_z-L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_5 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_5*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,3)-source_z)./sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2)));%入射角
    reflect_coefficient = (-sin(thet).*epsilon_c+sqrt(epsilon_c-(cos(thet)).^2))./(epsilon_c.*sin(thet)+sqrt(epsilon_c-(cos(thet)).^2));%现在的反射系数也是矩阵了
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E5=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
    E5=E5  .*   cos(pi*sin(thet)/2)./(cos(thet)+0.00001)  .*  cos(thet); %上下平面的电场由于方向图以及垂直分解需要加上这个
    %% 下平面反射路径
    Li=[L(:,1) , L(:,2) , -L(:,3)]; %计算镜像点
    d_reflect = sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2+(Li(:,3)-source_z).^2);%反射路径总长度
    t_reflect_6 = d_reflect./1000./c;%时延
    p_reflect = mod(t_reflect_6*2*pi/T,2*pi);%相位
    thet = abs(atan((Li(:,3)-source_z)./sqrt((Li(:,1)-source_x).^2+(Li(:,2)-source_y).^2)));%入射角
    reflect_coefficient = (-sin(thet).*epsilon_c+sqrt(epsilon_c-(cos(thet)).^2))./(epsilon_c.*sin(thet)+sqrt(epsilon_c-(cos(thet)).^2));
    E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
    E6=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
    E6=E6  .*   cos(pi*sin(thet)/2)./(cos(thet)+0.00001)  .*  cos(thet); %上下平面的电场由于方向图以及垂直分解需要加上这个

    E = E0 + E1 + E2 + E3 + E4 + E5 + E6;%这里所有的电场强度代表的是随路径和反射的损耗倍数
    Power_all = 20 * log10(abs(E)) + 2 * 2.15;%合成的功率。实际上是一个衰减系数，顺便在加上两个天线增益，假设为2.15dbi
    
    Power_all = reshape(Power_all, room_y / grid_size - 1, room_x / grid_size - 1)';
end
