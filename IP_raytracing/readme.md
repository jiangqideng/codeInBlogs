
博客地址：http://www.cnblogs.com/rubbninja/p/6118430.html

+ main_raytracing.m：主程序，在仿真环境中，得到离线指纹库，以及在线阶段的测试数据，用于以后的定位测试。
+ get_rss_by_ray_tracing.m：简化场景下（空旷房间）的射线跟踪。
+ generate_radio_map.m：生成“RSS仿真环境数据集”。
+ get_random_trace.m：生成一条随机轨迹。
+ get_offline_data_random.m：模拟随机数据采集，生成位置指纹库。
+ get_offline_data_uniform.m：模拟均匀数据采集，生成位置指纹库。
+ get_online_data.m：模拟在线阶段，生成测试数据。
+ radio_map_20_15.mat：生成的“RSS仿真环境数据集”，(1999, 1499, 6)的数组，比如fingerprint(1000, 1000, 2)代表的是仿真环境中位置（100，100）上接收到的第2个AP的RSS。
+ offline_data_rss.mat：离线数据RSS，每行为一个RSS向量
+ offline_data_location.mat：离线数据位置点，每行为一个位置点x，y
+ online_data_trace.mat：生成测试数据的运动轨迹，10000*2的数组，比如trace(10, :)代表的是第10个时刻目标的位置x和y。
+ online_data_rss.mat：生成测试数据中与运行轨迹对应的RSS，10000*6的数组，比如trace(10, :)代表的是第10个时刻时目标测得的各个RSS。