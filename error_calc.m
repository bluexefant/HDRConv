function error_calc(imgFileName, max_val)
    io = hdr_io; 
    
    % Variable(s) Initialization
    main_dir = 'C:\Users\Mika\Documents\Dropbox\ENEL 519.02\';
    img_dir = [main_dir, 'HDR Images\'];
    final_dir = [main_dir, 'HDR_Converter\'];
    
    hdr_ref_str = [img_dir, imgFileName, '.hdr'];
    hdr_gen_str = [final_dir, imgFileName, '_fixed.hdr'];
    
    hdr_ref = io.read_HDR(hdr_ref_str);
    hdr_gen = io.read_HDR(hdr_gen_str);
    
    fprintf('\nCalculating Mean Square Error...');
    mse_err = mse_hdr(hdr_ref, hdr_gen, max_val);
    fprintf('done.\n');
    
    fprintf('\nCalculating PSNR Error...');
    psnr_hdr(mse_err);
    fprintf('done.\n');
    
end

function mse_err = mse_hdr(hdr_ref, hdr_gen, max_val)
    rows = size(hdr_ref, 1);
    cols = size(hdr_ref, 2);

    scale = 1048575; % = FFFFF
    
    sum = 0;
    for r = 1:rows
        for c = 1:cols
            sum = sum + (((hdr_gen(r, c, 1) / scale) - (hdr_ref(r, c, 1) / max_val)) ^ 2);
            sum = sum + (((hdr_gen(r, c, 1) / scale) - (hdr_ref(r, c, 2) / max_val)) ^ 2);
            sum = sum + (((hdr_gen(r, c, 1) / scale) - (hdr_ref(r, c, 3) / max_val)) ^ 2);
        end
    end
    
    mse_err = sum / (rows * cols * 3);
    
    fprintf('\n The MSE error value is %0.9f\n', mse_err);
end

function psnr_hdr(mse_err)
    peaksnr = 10 * log10((255 ^ 2) / mse_err);
    
    fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
end



