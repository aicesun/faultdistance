clc
clear
close all
%% Computes various distance measures from a station to a fault

%% site information
site_lat_degrees = 33.2844;
site_lon_degrees = 131.2118;
siteinfo.lat = site_lat_degrees; 
siteinfo.lon = site_lon_degrees;

%% fault information
faultcord = [131.1216 32.9858;130.7071 32.6477;130.6382 32.7080;131.0527 33.0461];
FaultLat = 32.9858;
FaultLon = 131.1216;
h = 2.704;
FaultStrike = 226;
FaultDip = 65;
faultwidth = 56;
faultlength = 24;

refinfo.lat = FaultLat;
refinfo.lon = FaultLon;
refinfo.h = h;
faultinfo.stk = FaultStrike;
faultinfo.dip = FaultDip;
w1 = 0;
w2 = faultwidth;
s1 = 0;
s2 = faultlength;
h_min_c = 3; % Campbell depth to seismogenic region


%% computer distance
[D,D2Inf,AZ,REGinF] = dist_3df(siteinfo,refinfo,faultinfo,w1, w2, s1, s2,h_min_c);

disp(['Closest Distance to fault surface = ' num2str(D.cd2f)])
disp(['Joyner & Boore Distance = ' num2str(D.jb)])
disp(['Campbell Distance = ' num2str(D.c)])

figure
plot(faultcord(:,1),faultcord(:,2),'ko')
hold on
for i = 1:3
    line([faultcord(i,1),faultcord(i+1,1)],[faultcord(i,2),faultcord(i+1,2)])
end
line([faultcord(i+1,1),faultcord(1,1)],[faultcord(i+1,2),faultcord(1,2)])
plot(FaultLon,FaultLat,'ro','MarkerFaceColor','r')
text(FaultLon-0.15,FaultLat-0.02,'upper edge of fault(upper-left)','color','r')
plot(site_lon_degrees,site_lat_degrees,'rp','MarkerFaceColor','r','markersize',8)
text(site_lon_degrees+0.01,site_lat_degrees,'site')
