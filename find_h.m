function [h, iregion] = find_h(rx, rz, w1, w2, s1, s2)

%  See where the station lies with respect to the fault

if rx <= s1 && rz <=  w1
    iregion = 1;
    h = sqrt( (s1-rx)^2 + (w1-rz)^2 );   
elseif rz  <=  w1 && rx  >=  s1 && rx  <=  s2
    iregion = 2;
    h = w1 - rz;
elseif  rx  >=  s2 && rz  <=  w1
    iregion = 3;
    h = sqrt( (rx-s2)^2 + (w1-rz)^2 );    
elseif  rx  >=  s2 && rz  >=  w1 && rz  <=  w2
    iregion = 4;
    h = rx - s2;
elseif rx  >=  s2 && rz  >=  w2
    iregion = 5;
    h = sqrt( (rx-s2)^2 + (rz-w2)^2 );
    
elseif rz  >=  w2 && rx  >=  s1 && rx  <=  s2
    iregion = 6;
    h = rz - w2;
    
elseif rz  >=  w2 && rx  <=  s1
    iregion = 7;
    h = sqrt( (s1-rx)^2 + (rz-w2)^2 );
    
elseif rx  <=  s1 && rz  >=  w1 && rz  <=  w2
    iregion = 8;
    h = s1 - rx;    
elseif  rx  >=  s1 && rx  <=  s2 && rz  >=  w1 && rz  <=  w2
    iregion = 9;
    h = 0.0;
else
    return
end
