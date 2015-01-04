% Format of .hdr image (m x n x 3 matrix):
%
%    - array of pixels
%       |------|------|------|------|------|
%       | px11 | px12 | px13 | px14 | px15 |...
%       |------|------|------|------|------|
%       |------|------|------|------|------|
%       | px21 | px22 | px23 | px24 | px25 |...
%       |------|------|------|------|------|
%       |------|------|------|------|------|
%       | px31 | px32 | px33 | px34 | px35 |...
%       |------|------|------|------|------|
%          .      .      .      .      .
%          .      .      .      .      .
%          .      .      .      .      .
%
%   - array inside of pixel (3D aspect)
%       px11:
%       |--------|--------|--------|
%       | R[0-1] | G[0-1] | B[0-1] |
%       |--------|--------|--------|
%
%       px12:
%       |--------|--------|--------|
%       | R[0-1] | G[0-1] | B[0-1] |
%       |--------|--------|--------|
%
%       etc.

function main(imgFileName)
    % Function Definitions
    io = hdr_io;         % for reading, writing and viewing HDR image
    convert = type_conversion; % for conversion of floating point to fixed
    
    % Variable(s) Initialization
    main_dir = 'C:\Users\Mika\Documents\Dropbox\ENEL 519.02\';
    img_dir = [main_dir, 'HDR Images\'];
    final_dir = [main_dir, 'HDR_Converter\'];
    
    hdr_file = [img_dir, imgFileName, '.hdr'];
    %-----------------------------------------------------------------------------------
    
    % READ HDR IMAGE IN FROM FILE
    %  - m x n x 3 MATRIX WILL BE CREATED
    %  - VALUES IN MATRIX ARE FLOATING POINT (0-1 RANGE) RGB VALUES
    fprintf('\nReading in original image...');
    hdr_float = io.read_HDR(hdr_file);
    fprintf(' done.\n');
    
    figure;
    io.view_HDR(hdr_float);
    title('Original');
    
    % GET IMAGE DIMENSIONS - w x h x 3
    img_dims = size(hdr_float);
    rows = img_dims(1);
    cols = img_dims(2);
    dpth = 3; % r,g,b
    
    % CONVERT FLOATING POINT VALUES TO FIXED POINT
    fprintf('\nConverting floating point to fixed point...');
    [hdr_fixed, max_val] = convert.float2fixed(hdr_float, rows, cols, dpth);
    fprintf(' done.\n');
    
    % VIEW HDR IMAGE IN VALID RGB FORMAT FOR SCREEN
    figure;
    io.view_HDR(hdr_fixed);
    title('Converted to Fixed');
    
    hdr_hex = convert.fixed2hex(hdr_fixed, rows, cols, dpth);
    
%     figure;
%     io.view_HDR(hdr_hex);
%     title('Converted to Hex');
    
    io.rgb_TxtOutput(hdr_fixed, final_dir);
    
    hdr_rgb = io.rgb_TxtInput(final_dir);
    
%     figure;
%     io.view_HDR(hdr_rgb);
%     title('Input from Text File');
    
    fprintf('\nGenerating new HDR image file...');
    io.write_HDR(hdr_fixed, [final_dir, imgFileName, '_fixed.hdr']);
    fprintf(' done.\n');
    
    error_calc(imgFileName, max_val);
end
