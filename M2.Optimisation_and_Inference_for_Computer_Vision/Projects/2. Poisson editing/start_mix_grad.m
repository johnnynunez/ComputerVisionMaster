clearvars;
DST_NAME = 'cars.png';
SRC_NAME = 'karim.png';

dst = double(imread(DST_NAME));
src = double(imread(SRC_NAME)); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_dst=logical(imread(strcat('mask_dst_', DST_NAME)));
mask_src=logical(imread(strcat('mask_src_', SRC_NAME)));


%create the laplacian mask for the second derivative of the source image

for nC = 1: nChannels
    
    
    DiBwd_src = sol_DiBwd( src(:,:,nC), param.hi );
    DiFwd_src = sol_DiFwd( src(:,:,nC), param.hi );
    DjBwd_src = sol_DjBwd( src(:,:,nC), param.hj );
    DjFwd_src = sol_DjFwd( src(:,:,nC), param.hj );
    
    DiBwd_dst = sol_DiBwd( dst(:,:,nC), param.hi );
    DiFwd_dst = sol_DiFwd( dst(:,:,nC), param.hi );
    DjBwd_dst = sol_DjBwd( dst(:,:,nC), param.hj );
    DjFwd_dst = sol_DjFwd( dst(:,:,nC), param.hj );
    
    % Get the maxium gradient on each direction
    DiBwd_dst = get_max_grad(DiBwd_dst, DiBwd_src, mask_dst, mask_src);
    DiFwd_dst = get_max_grad(DiFwd_dst, DiFwd_src, mask_dst, mask_src);
    DjBwd_dst = get_max_grad(DjBwd_dst, DjBwd_src, mask_dst, mask_src);
    DjFwd_dst = get_max_grad(DjFwd_dst, DjFwd_src, mask_dst, mask_src);
    
    drivingGrad_i = DiBwd_dst-DiFwd_dst;
    drivingGrad_j = DjBwd_dst-DjFwd_dst;
    driving_on_dst = drivingGrad_i + drivingGrad_j;

    param.driving = driving_on_dst;

    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);
end

%Mouth
%masks to exchange: Mouth
mask_src = logical((imread('mask_src_mouth.png')));
mask_dst = logical((imread('mask_dst_mouth.png')));

%create the laplacian mask for the second derivative of the source image
% for nC = 1: nChannels
%     
%     DiBwd_src = sol_DiBwd( src(:,:,nC), param.hi );
%     DiFwd_src = sol_DiFwd( src(:,:,nC), param.hi );
%     DjBwd_src = sol_DjBwd( src(:,:,nC), param.hj );
%     DjFwd_src = sol_DjFwd( src(:,:,nC), param.hj );
%     
%     DiBwd_dst = sol_DiBwd( dst(:,:,nC), param.hi );
%     DiFwd_dst = sol_DiFwd( dst(:,:,nC), param.hi );
%     DjBwd_dst = sol_DjBwd( dst(:,:,nC), param.hj );
%     DjFwd_dst = sol_DjFwd( dst(:,:,nC), param.hj );
%     
%     % Get the maxium gradient on each direction
%     DiBwd_dst = get_max_grad(DiBwd_dst, DiBwd_src, mask_dst, mask_src);
%     DiFwd_dst = get_max_grad(DiFwd_dst, DiFwd_src, mask_dst, mask_src);
%     DjBwd_dst = get_max_grad(DjBwd_dst, DjBwd_src, mask_dst, mask_src);
%     DjFwd_dst = get_max_grad(DjFwd_dst, DjFwd_src, mask_dst, mask_src);
%     
%     drivingGrad_i = DiBwd_dst-DiFwd_dst;
%     drivingGrad_j = DjBwd_dst-DjFwd_dst;
%     driving_on_dst = drivingGrad_i + drivingGrad_j;
%     
%     param.driving = driving_on_dst;
%     
%     dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
% end



imwrite(dst1/256, strcat('img_mixing_',DST_NAME))
imshow(dst1/256)