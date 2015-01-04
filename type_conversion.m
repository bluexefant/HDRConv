% MAIN FUNCTION
function my_fltofx = type_conversion()
    my_fltofx.float2fixed=@float2fixed;
    my_fltofx.fixed2hex=@fixed2hex;
end

% FUNCTION: float_to_fixed ***********************************
%
% This is conversion from floating point (0-1 range)
%       to
% fixed point (0-((2^20)-1) range), with rounding to nearest int
% ************************************************************
function [hdr_fixed, max_val] = float2fixed(hdr_float, rows, cols, dpth)
    % var init
    red = zeros(rows, cols);
    r_float_norm = zeros(rows, cols);
    
    green = zeros(rows, cols);
    g_float_norm = zeros(rows, cols);
    
    blue = zeros(rows, cols);
    b_float_norm = zeros(rows, cols);
    
    scale = 1048575;  % = FFFFF - scale to 20 bits
    
    %find the max value through the entire hdr image
    [r_max_vec, i] = max(hdr_float(:,:,1));
    [g_max_vec, i] = max(hdr_float(:,:,2));
    [b_max_vec, i] = max(hdr_float(:,:,3));
    max_val = max(r_max_vec);
    if max_val < max(g_max_vec)
        max_val = max(g_max_vec);
    end
    if max_val < max(b_max_vec)
        max_val = max(b_max_vec);
    end
    
    %normalize all values
    for r = 1:rows
        r_float_norm(r,:) = hdr_float(r,:,1) / max_val;
        g_float_norm(r,:) = hdr_float(r,:,2) / max_val;
        b_float_norm(r,:) = hdr_float(r,:,3) / max_val;
    end
    
    %convert all values to fixed
    for r = 1:rows
        for c = 1:cols
            red(r, c)   = round(r_float_norm(r, c) * scale);
            green(r, c) = round(g_float_norm(r, c) * scale);
            blue(r, c)  = round(b_float_norm(r, c) * scale);
        end
    end
    
    %put the red, green and blue 2D matrices together into a 3D matrix
    hdr_fixed = cat(3, red, green, blue);
end

% FUNCTION: fixed2hex ***********************************
%
% This is conversion from fixed point to hex
% ************************************************************
function hdr_hex = fixed2hex(hdr_fixed, rows, cols, dpth)
    red = cell(rows, cols);
    green = cell(rows, cols);
    blue = cell(rows, cols);

    %size(red(1,:))
    %size(hdr_fixed(1,:,1))
    for r = 1:rows
        red(r,:) = calcs_toHex(hdr_fixed(r,:,1));
        green(r,:) = calcs_toHex(hdr_fixed(r,:,2));
        blue(r,:) = calcs_toHex(hdr_fixed(r,:,3));
    end
    
    hdr_hex = cat(3, red, green, blue);
    
end

% FUNCTION: calcs_toFixed *************************************
%
% An additional function for calculations, just in case
% ************************************************************
function fixed_num = prelim_float2fixed(num)
%     Calculate the weight of the fraction part of the number and
%     update accordingly
    
    maxBits = 16; %to 16 bits
    absoluteNum = abs(num); %get absolute version of number
    
    decPos = 0;
    for i = 0:maxBits-1
        decWeight = 2^i;
        if(absoluteNum > decWeight)
            decPos = decPos + 1;
        end
    end
    
    decWeight = 2 ^ (maxBits - decPos);
	fixed_num = floor(num * decWeight);
end

% FUNCTION: calcs_toHex *************************************
%
% An additional function for calculations, just in case
% ************************************************************
function hex_arr = calcs_toHex(fixed_vector)
%     Calculate the weight of the fraction part of the number and
%     update accordingly
    n = size(fixed_vector);

    for i = 1:n(2)
        hex_arr(i) = {dec2hex(fixed_vector(1,i))};
    end
end
