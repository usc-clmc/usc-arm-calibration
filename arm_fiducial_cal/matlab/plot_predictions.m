clear all;
close all;
load('predictions.mat');

labels={'x [m]','y [m]','z [m]', 'wx [rad]', 'wy [rad]', 'wz [rad]'};

figSize = [8.0 6.0];
inset = 0.02;
figPos = [inset inset figSize(1)-inset*2 figSize(2)-inset*2];

num_dim = size(output, 2);
figure(1);
for i=1:num_dim
  subplot(num_dim,1,i)
  plot(abs(output(:,i)), 'r-*');
  hold on;
  plot(abs(output(:,i) - all_test_output(:,i)), 'g-+');
  ylabel(labels{i});
end

set(gcf,'PaperUnits','inches');
set(gcf,'PaperSize',figSize);
set(gcf,'PaperPosition', figPos);
print -painters -dpdf -r300 cable_stretch.pdf

figure(2);
for i=1:num_dim
  subplot(num_dim,1,i)
  plot(output(:,i), 'r-*');
  hold on;
  plot(all_test_output(:,i), 'g-+');
  ylabel(labels{i});
end

set(gcf,'PaperUnits','inches');
set(gcf,'PaperSize',figSize);
set(gcf,'PaperPosition', figPos);
print -painters -dpdf -r300 cable_stretch2.pdf

fprintf('rms of errors before correction\n');
sqrt(mean(output.*output))
fprintf('rms of errors after correction\n');
corrected_output = all_test_output - output;
sqrt(mean(corrected_output.*corrected_output))

