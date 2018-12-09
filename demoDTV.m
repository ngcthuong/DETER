

function demo
close all;  clear all; % clc;
path(path,genpath(pwd));
set(0,'RecursionLimit', 1200)
%% General setting
N               = 512;
sparsity        = [0.1];
testIm          = [1 ];
rec_mode        = {'TV', 'TVNL1', 'TVNL2', 'TVNL3', 'DTV'} ;
weight_mode     = {'No', 'HENOW'};
post_mode       = {'No', 'BM3D', 'MH', 'NLM'};

rec_mode_id     = 5;
weight_mode_id  = 2;
post_mode_id    = 1;
quant_mode_id   = 1;
isShowPSNR      = 1;
nSNR            = 0;

[opts, note_str]= setup_parameter(rec_mode_id, weight_mode_id, post_mode_id, quant_mode_id, isShowPSNR);
note_str = [ note_str '_SNR' num2str(nSNR) ];
opts.nbrLoop    = 1;

for mmm = 1:1:length(testIm)
    [image, img_name] = testImage(N, testIm(mmm));
    
    save_folder_text    = ['Result_text' num2str(N) '\' ];
    if ~exist(save_folder_text, 'dir');
        mkdir(save_folder_text);
    end;
    file_name_save  	= [save_folder_text 'results_' img_name '_20150323_' note_str ];
    
    if(rec_mode_id == 5)
    write_info([file_name_save  '.txt'], [img_name '_Car_lam' num2str(opts.car.lambda) '_nuy' num2str(opts.car.nuy)...
                '_mu' num2str(opts.car.mu) '_nLoopInit' num2str(opts.car.nLoop_init) '_nLoop' num2str(opts.car.nLoop)...
                '_sigma' num2str(opts.car.sigma)]);
    write_info([file_name_save  '.txt'], [ '        _Tex_lam' num2str(opts.tex.lambda) '_nuy' num2str(opts.tex.nuy)...
                '_mu' num2str(opts.tex.mu) '_nLoopInit' num2str(opts.tex.nbrLoop_init) '_nLoop' num2str(opts.tex.nLoop)...
                '_sigma' num2str(opts.tex.sigma)]);         
    else
        write_info([file_name_save  '.txt'], [img_name note_str]);
    end;
    
   
        % build the sampling matrix, R
        t_org      = zeros(opts.nbrLoop, length(sparsity));      t_post = t_org;
        psnr_final = t_org;         ssim_final  = t_org;
        psnr_org   = t_org;         ssim_org    = t_org;
        rate       = t_org;         entr        = t_org;
        rec_psnr_post = cell(1);
        
        for kk = 1:1:length(sparsity)
            
            for trial = 1:opts.nbrLoop
                NoteBeg     = ['In' num2str(opts.nInner) '_Out' num2str(opts.nOuter)];
                display([NoteBeg '_' img_name '_Sub' num2str(sparsity(kk)) '_trial' num2str(trial) '/' num2str(opts.nbrLoop )])
                
                % -------------- Sensing matrix ------------------------
                [R, G]              = KCS_SensingMtx(N, sparsity(kk), trial);
                Y                   = R*image*G;
                if(nSNR ~=0)
                    noise = rand(size(Y)); %%gives a 10 by 10 matrix. 
                    scale = ( std(Y(:))/std(noise(:)) ) / nSNR; 
                    Y     = Y + scale * noise; 
                end;
                
                % --------------- Recover the image -----------------------
                t0 = cputime;
                [rec, ~, ~, ~] = recSep(opts.rec_mode, R, G, Y, opts, image, img_name); 
                t_org(trial, kk) = cputime - t0;
                rec_org = rec;
                
                % Post pocessing
                t0 = cputime;
                [rec, ~, ~, rec_psnr_post{trial}{kk}] = PostProcessing(opts.post_mode, R, G, Y, rec, opts, image, img_name);                
                t_post(trial, kk)  = cputime - t0;
                t_post(trial, kk)  = t_post(trial, kk) + t_org(trial,kk);
                rec_post           = rec;
                
                % --------------- Final Results  ------------------------
                psnr_org(trial, kk)   = psnr(rec_org, image);
                ssim_org(trial, kk)   = cal_ssim(rec_org, image, 0, 0);
                psnr_final(trial, kk) = psnr(rec_post, image);
                ssim_final(trial, kk) = cal_ssim(rec_post, image, 0, 0);            
                
            end; % end trial
            write_results_sepTV([file_name_save '.txt'], sparsity(kk), psnr_final(:, kk), ...
                ssim_final(:, kk), rate(:, kk), entr(:, kk), psnr_org(:, kk), ssim_org(:, kk), ...
                t_org(:, kk), t_post(:, kk), rec_psnr_post{trial}{kk} );
            
            %% ============ save image  ==================
            if(opts.post_mode ~= 1)
                save_image_result(rec_org, [Note '_Org'], img_name, sparsity(kk), mean(psnr_org(:, kk)), mean(ssim_org(:)),0);
            end;
            save_image_result(rec_post, [ Note ] , img_name, sparsity(kk), mean(psnr_final(:, kk)), mean(ssim_final(:)), 0);
        end; % end sparsity        
        % 	save all images
        patch3 = ['Results\' 'All_In' num2str(opts.nInner) Note];
        if ~exist(patch3, 'dir');
            mkdir(patch3);
        end;
        patch3 = [patch3 '\' img_name '_Sub' num2str(sparsity(kk)) '.mat'];
        save(patch3, 'psnr_final', 'ssim_final','psnr_org', 'ssim_org', 'rec_psnr_post' , 't_org', 't_post', 'opts', 'sparsity', 'rec') ;
        
end; % end test image
display('END SIMULATION!!!');

function y = psnr(im1,im2);
        [m,n] = size(im1);
        x1 = double(im1(:));
        x2 = double(im2(:));
        mse = norm(x1-x2);
        mse = (mse*mse)/(m*n);
        if mse >0
            y = 10*log10(255^2/mse);
        else
            disp('infinite psnr');
        end
end
end