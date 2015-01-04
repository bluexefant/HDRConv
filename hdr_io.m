% MAIN FUNCTION
function myhdr_io = hdr_io
    myhdr_io.read_HDR=@read_HDR;
    myhdr_io.write_HDR=@write_HDR;
    myhdr_io.view_HDR=@view_HDR;
    myhdr_io.rgb_TxtOutput=@rgb_TxtOutput;
    myhdr_io.rgb_TxtInput=@rgb_TxtInput;
end

% FUNCTION: read_HDR_in ***********************************
%
% Read specified HDR image into a 3-D matrix
% *********************************************************
function hdr_in = read_HDR(hdr_filename)
    hdr_in = hdrread(hdr_filename);
end

% FUNCTION: write_HDR_in **********************************
%
% Writes 3-D matrix into an HDR image called 'hdr_filename'
% *********************************************************
function write_HDR(hdr_out, hdr_filename)
    hdrwrite(hdr_out, hdr_filename);
end

% FUNCTION: view_HDR_img **********************************
%
% View image created by 3-D matrix hdr_img
% *********************************************************
function view_HDR(hdr_img)
    rgb = tonemap(hdr_img);
    imshow(rgb);
end

% FUNCTION: rgb_TxtOutput ********************************
%
% Output the RGB values of image to files
% *********************************************************
function rgb_TxtOutput(hdr_fixed, final_dir)
    img_dims = size(hdr_fixed);
    
    r_OutFile = fopen([final_dir, 'r.txt'], 'w+');
    g_OutFile = fopen([final_dir, 'g.txt'], 'w+');
    b_OutFile = fopen([final_dir, 'b.txt'], 'w+');
    
    for i = 1:img_dims(1)
        rcell = cellstr(dec2hex(hdr_fixed(i,:,1)));
        gcell = cellstr(dec2hex(hdr_fixed(i,:,2)));
        bcell = cellstr(dec2hex(hdr_fixed(i,:,3)));
        
        fprintf(r_OutFile, '%05s ', rcell{:});
        fprintf(r_OutFile, '\n');
        
        fprintf(g_OutFile, '%05s ', gcell{:});
        fprintf(g_OutFile, '\n');
        
        fprintf(b_OutFile, '%05s ', bcell{:});
        fprintf(b_OutFile, '\n');  
    end
    
    fclose(r_OutFile);
    fclose(g_OutFile);
    fclose(b_OutFile);
end

% FUNCTION: rgb_TxtInput ********************************
%
% Output the RGB values of image to files
% *********************************************************
function hdr_rgb = rgb_TxtInput(final_dir)
    r_InFile = fopen([final_dir, 'r.txt'], 'r+');
    g_InFile = fopen([final_dir, 'g.txt'], 'r+');
    b_InFile = fopen([final_dir, 'b.txt'], 'r+');
    
    rline = fgets(r_InFile);
    
    char_num = size(rline, 2);
    cols = (char_num - 1) / 6;    %number of forced hex chars + right-side space
    
    %hdr_rgb = zeros(rows, cols, 3);
    
    i = 1;
    r = 1;
    'Read in started'
    while ~feof(r_InFile)
        gline = fgets(g_InFile);
        bline = fgets(b_InFile);

        for c = 1:cols
            if i < char_num
                hdr_rgb(r, c, 1) = hex2dec(rline(i:(i+4)));

                hdr_rgb(r, c, 2) = hex2dec(gline(i:(i+4)));

                hdr_rgb(r, c, 3) = hex2dec(bline(i:(i+4)));

                i = i + 6;
            end
        end
        
        rline = fgets(r_InFile);
        
        i = 1;
        r = r + 1;
    end
    'Read in ended'
end










