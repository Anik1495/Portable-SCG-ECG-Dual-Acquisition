clc
clear 
close all

% a= arduino
 a = arduino('com3','uno','BaudRate',500000)

   
    imu = mpu9250(a)
    imu_mean = readAcceleration(imu)
    grid on;


acc_count = 0
acc_data =[] 
writeDigitalPin(a, 'D13', 0);
tic;
    
while acc_count<500
    acc_count = acc_count+1;
    
    %Home Base
writeDigitalPin(a, 'D13', 1);

ecg=readVoltage(a,'A3');
imu_mean = readAcceleration(imu);



%acceleration
acc_x_ms = imu_mean(:,1);
acc_y_ms = imu_mean(:,2);
acc_z_ms = imu_mean(:,3);

%Gyrometer
% acc_x_g = imu_mean(:,4);
% acc_y_g = imu_mean(:,5);
% acc_z_g = imu_mean(:,6);
 

%capture the data silently
acc_data = [acc_data; [acc_z_ms,ecg]];

%what i will see in command window
show_me_acceleration = [acc_z_ms,ecg];

disp(show_me_acceleration);


if acc_count==500
    disp('This is the end of the acceleration session')
    writeDigitalPin(a, 'D12', 1);
    
end
save('acc_ecg_data_1.mat', 'acc_data')
writeDigitalPin(a, 'D13', 0);
figure(1)
plot (acc_data)

% hold on
% plot(ecg)

end
tt=toc;
disp 'time: '
disp (tt)
