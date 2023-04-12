%Parameters
blockSize = 32;
h = 512;
w = 768;
blockCount = 32;

% points
pointVDH = zeros(1,2);

% Sequence type
ph = haltonset(2);
VDH = net(ph,blockCount*blockCount*2);

for m=1:(blockCount*blockCount)
    pointVDH(m,1)= fix(VDH(m,1)* (h));
    pointVDH(m,2)= fix(VDH(m,2)* (w));

    if((pointVDH(m, 1) + blockSize) > h)
        pointVDH(m, 1) = h - (blockSize);
    end
    
    if((pointVDH(m, 2) + blockSize) > w)
        pointVDH(m, 2) = w - (blockSize);
    end

end


% Read images
nomearqOri = strcat('bikes.bmp');
nomearqDist = strcat('img203.bmp');

% Converto to gray scale
img1=rgb2gray(imread(nomearqOri));
img2=rgb2gray(imread(nomearqDist));

%Images to fill
imgOrgVDH = zeros(1,1);
imgDistVDH = zeros(1,1);

% Get blocks of pixels from images
in = 1;
for m=0:1:blockCount-1
    for n=0:1:0
    in = in + 1;
        for p = 0 : 1 :blockSize-1
            for q = 0 : 1 :blockSize-1                                
                imgOrgVDH(((m) * blockSize)+ p +1, ((n) * blockSize )+ q +1) = img1(((pointVDH(in,1)-1))+p+1, ((pointVDH(in,2)-1))+q+1);
                imgDistVDH(((m) * blockSize)+ p +1, ((n) * blockSize )+ q +1) = img2(((pointVDH(in,1)-1))+p+1, ((pointVDH(in,2)-1))+q+1);
            
            end
        end
    end
end


window = fspecial('gaussian',7, 1.5);
windowOrig = fspecial('gaussian', 11, 1.5);

% SSIM full image
[mssim, ssim_map] = ssim(img1,img2,[0.01 0.03],windowOrig,true);

% SSIM sampled image
[mssimSampled, ssim_mapSampled] = ssim(imgOrgVDH,imgDistVDH,[0.01 0.03],window,true);

disp(mssim);
disp(mssimSampled);

%Result
% 0.9750
% 0.9738

%imshow(uint8(imgOrgVDH));

