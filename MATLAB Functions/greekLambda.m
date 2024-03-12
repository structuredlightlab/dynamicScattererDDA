function [mu] = greekLambda()

% fontSize = get(0,'DefaultAxesFontSize');
fontSize = get(gca,'FontSize');
% fontSize = font_size;
mu = ['\fontname{arial}\fontsize{' num2str(fontSize*0.95) '}' ...
     char(955) ...
     '\fontname{' get(gca,'FontName') '}\fontsize{' num2str(fontSize*1.1) '}'];
end

