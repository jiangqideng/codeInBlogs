
博客地址：http://www.cnblogs.com/rubbninja/p/6118430.html

+ main.m：主程序，在仿真环境中，得到离线指纹库，以及在线阶段的测试数据，用于以后的定位测试。
+ get_rss_by_ray_tracing.m：简化场景下（空旷房间）的射线跟踪。
+ generate_radio_map.m：生成“RSS仿真环境数据集”。
+ get_random_trace.m：生成一条随机轨迹。
+ get_offline_data.m：模拟数据采集，生成位置指纹库。
+ get_online_data.m：模拟在线阶段，生成测试数据。
+ radio_map_20_15.mat：生成的“RSS仿真环境数据集”，1999*1499*6的数组，比如fingerprint(1000, 1000, 2)代表的是仿真环境中位置（100，100）上接收到的第2个AP的RSS。
+ offline_data_fp.mat：生成的离线指纹库，199*149*6的数组，比如fp(100, 100, 3)代表指纹库中位置（100，100）上接收到的第3个AP的RSS。
+ online_data_trace.mat：生成测试数据的运动轨迹，10000*2的数组，比如trace(10, :)代表的是第10个时刻目标的位置x和y。
+ online_data_rss.mat：生成测试数据中与运行轨迹对应的RSS，10000*6的数组，比如trace(10, :)代表的是第10个时刻时目标测得的各个RSS。