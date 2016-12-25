function kf_params = kf_update(kf_params)
    % 以下为卡尔曼滤波的五个方程（步骤）
    x_ = kf_params.A * kf_params.x + kf_params.B * kf_params.u;
    P_ = kf_params.A * kf_params.P * kf_params.A' + kf_params.Q;
    kf_params.K = P_ * kf_params.H' * (kf_params.H * P_ * kf_params.H' + kf_params.R)^-1;
    kf_params.x = x_ + kf_params.K * (kf_params.z - kf_params.H * x_);
    kf_params.P = P_ - kf_params.K * kf_params.H * P_;
end

