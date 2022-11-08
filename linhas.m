## function [excentricidade,boundary] = linhas (k, B, stats1)
function [excentricidade,boundary] = linhas (k, B, stats1)
fprintf('\ntraçando linhas\n'); fflush(stdout);

area = stats1(k).Area;
boundary = B{k};
excentricidade = (stats1(k).MinorAxisLength)/(stats1(k).MajorAxisLength);
center_x = stats1(k).Centroid(1); ###    acquire X position of the center
center_y = stats1(k).Centroid(2); ###    acquire Y position of the center
radius = 20;
a = stats1(k).MajorAxisLength/2;
b = stats1(k).MinorAxisLength/2;
alpha = stats1(k).Orientation;

### plotando bordas
plot(boundary(:,2), boundary(:,1), 'color', 'black', 'LineWidth', 2);

### plotando circulo do centro do objeto
plot(center_x, center_y, 'k', 'MarkerSize', radius * 4/3);
plot(center_x, center_y, 'm', 'MarkerSize', radius);

### plotando elípse
theta = alpha*pi/180;

R = [ cos(theta)   sin(theta)
     -sin(theta)   cos(theta)];

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

xy = [a*cosphi; b*sinphi];
xy = (R*xy);

x = xy(1,:) + center_x;
y = xy(2,:) + center_y;

plot(x,y,'k','LineWidth',2);
        
### plotando eixos maiores e menores
xMajor = center_x  +  [ -1 +1 ] * a * sind(alpha-90);
yMajor = center_y  +  [ -1 +1 ] * a * cosd(alpha-90);
xMinor = center_x  +  [ -1 +1 ] * b * sind(alpha);
yMinor = center_y  +  [ -1 +1 ] * b * cosd(alpha);

line(xMajor,yMajor, 'LineWidth', 2, 'color', 'red');
line(xMinor,yMinor, 'LineWidth', 2, 'color', 'green');

### escrevendo valores na imagem
text(center_x + radius + 5, center_y, ...
              sprintf('area: %.0f exc: %.2f', area, excentricidade), ...
              'Color', 'black',...
              'FontSize', 12,...
              'FontWeight', 'bold',...
              'BackgroundColor', 'black');

endfunction
