function  [D,D2Inf,AZ,REGinF] = dist_3df(siteinfo,refinfo,faultinfo,w1, w2, s1, s2,h_min_c)

    
% Computes various distance measures from a station to a fault.  
% The orientation of the fault is that used by Spudich et al., 
% Yucca Mt. project.The fault is assumed to be a rectangle whose 
% upper and lower edges are horizontal.

% Input:
%      alat_sta, along_sta:  latitude and longitude of station, in degrees,
%                            west longitude is negative
%      alat_ref, along_ref:  as above, for reference point used in defining
%                            fault orientation
%      h_ref:                depth to reference point
%      strike_f, dip_f:      azimuth and dip of fault, in degrees.  strike_f is
%                            measured positive clockwise from north; dip_f is
%                            measured from the horizontal.  When looking in 
%                            the direction strike_f, a positive dip is down to
%                            the right.
%      w1, w2, s1, s2:       distances from the reference point to the edges of
%                            the fault.  s1 and s2 are the distances along
%                            strike to the near and far edges;aa w1 and w2 are
%                            the distances along the dip direction to the upper
%                            and lower edges of the fault.
%      h_min_c:              minimum depth for computing Campbell's distance
%                            (usually 3.0 km)

% Output:
%      d_jb, d_cd2f, d_c:    Joyner & Boore, closest distance to fault surface,
%                            and Campbell distance, respectively.
%      az_jb, az_cd2f, az_c: as above, for azimuths (NOT YET IMPLEMENTED IN THIS
%                            SUBROUTINE)
%      d_sta_n, d_sta_e:     north and east components of station location
%                            relative to the reference point
%      irgn_cd2f, etc:       region in fault-plane coordinates used to 
%                            compute distances.  I could include a sketch here,
%                            but I will not take the time.  These output 
%                            variables were included mainly to help me check
%                            the subroutine.

alat_sta  = siteinfo.lat;
along_sta = siteinfo.lon;
alat_ref  = refinfo.lat;
along_ref = refinfo.lon;
h_ref     = refinfo.h; 
strike_f  = faultinfo.stk;
dip_f     = faultinfo.dip;


dtor    = pi/ 180;
% Convert angles to radians
fstrike =  dtor * strike_f;
fdip    = dtor * dip_f;

% Compute unit vectors:        ! 1, 2, 3 correspond to n, e, d
ix(1:3) = [cos(fstrike), sin(fstrike), 0];
iy(1:3) = [-sin(fstrike)*sin(fdip), cos(fstrike)*sin(fdip), -cos(fdip)];
iz(1:3) = [-sin(fstrike)*cos(fdip), cos(fstrike)*cos(fdip), sin(fdip)];

% Convert station lat, long into distance north and east:
[dist_sta(1), dist_sta(2)] = deg2km_f(alat_sta, along_sta, alat_ref, along_ref);
dist_sta(3) = -h_ref  ;
d_sta_n = dist_sta(1);
d_sta_e = dist_sta(2);

% Convert coordinates of reference-to-station vector from n,e,d coordinates
% into fault coordinates: 
[rx,ry,rz] = deal(0,0,0);
for i = 1:3
    rx = rx + dist_sta(i) * ix(i);
    ry = ry + dist_sta(i) * iy(i);
    rz = rz + dist_sta(i) * iz(i);
end

% Find region and closest distance to fault in the fault plane coordinates:
% cd2f = Closest Distance to Fault
[h_cd2f, irgn_cd2f] = find_h(rx, rz, w1, w2, s1, s2);

% Now do it for Campbell:
% Define w1 for Campbell (I assume that w2 does not need defining; in other
% words, not all of the fault plane is above the Campbell depth)
d2top_c = h_min_c;
d2top    = h_ref + w1 * iz(3);

if d2top < d2top_c && iz(3) ~= 0
    w1_c = (d2top_c - h_ref)/ iz(3);
else
    w1_c = w1;
end

% c = Campbell
[h_c, irgn_c] = find_h(rx, rz, w1_c, w2, s1, s2);

% Now do it for Joyner-Boore:
% Need to find rx, ry, rz, w1, w2, s1, s2 in terms of coordinates
% of the fault plane projected onto the surface:
s1_jb  = s1;
s2_jb  = s2;
w1_jb = w1 * cos(fdip);
w2_jb = w2 * cos(fdip);

rx_jb = rx;
rz_jb = -sin(fstrike) * dist_sta(1) + cos(fstrike) * dist_sta(2);

% Then find the region and distance in the plane to the fault surface
[h_jb,irgn_jb] = find_h(rx_jb, rz_jb,w1_jb, w2_jb, s1_jb, s2_jb);

% Now compute the distances:
D.cd2f = sqrt(h_cd2f^2 + ry^2);
D.c    = sqrt(h_c^2 + ry^2);
D.jb   = h_jb;

% (Work on azimuths later)
[AZ.cd2f,AZ.c,AZ.jb] = deal(999.9,999.9,999.9);
REGinF.irgn_c = irgn_c;
REGinF.irgn_jb = irgn_jb;
REGinF.irgn_cd2f = irgn_cd2f;
D2Inf.n = d_sta_n;
D2Inf.e = d_sta_e;
