%Harris corner detector

tmp=imread('./i235.png','png');
I=double(tmp);
figure,imagesc(I),colormap gray, title('Original Image')

%compute x and y derivative of the image
dx=[1 0 -1; 2 0 -2; 1 0 -1];
dy=[1 2 1; 0  0  0; -1 -2 -1];
Ix=conv2(I,dx,'same');
Iy=conv2(I,dy,'same');
figure,imagesc(Ix),colormap gray,title('Ix')
figure,imagesc(Iy),colormap gray,title('Iy')

%compute products of derivatives at every pixel
Ix2=Ix.*Ix; Iy2=Iy.*Iy; Ixy=Ix.*Iy;

%compute the sum of products of  derivatives at each pixel
g = fspecial('gaussian', 9, 1.2);
%figure,imagesc(g),colormap gray,title('Gaussian')
Sx2=conv2(Ix2,g,'same'); Sy2=conv2(Iy2,g,'same'); Sxy=conv2(Ixy,g,'same');

%features detection
[rr,cc]=size(Sx2);
edge_reg=zeros(rr,cc); corner_reg=zeros(rr,cc); flat_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.05;

for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;
        %threshod on value of R
        if R< 0.3* max(R_map)
            edge_reg(ii,jj)=1;
        elseif R> 0.3 * max(R_map)
            corner_reg(ii,jj)=1;       
        else
            flat_reg(ii,jj)=1;
        end
    end
end

%figure,imagesc(edge_reg.*I),colormap gray,title('edge regions')
%figure,imagesc(corner_reg.*I),colormap gray,title('corner regions')
%figure,imagesc(flat_reg.*I),colormap gray,title('flat regions')
figure,imagesc(R_map),colormap jet,title('R map')


bw_corner = imbinarize(corner_reg);
CC = bwconncomp(bw_corner);
S = regionprops(CC,'Centroid', 'BoundingBox', 'Area');
corn = cat(1, S.Centroid);
figure,imagesc(I),colormap gray,title('Detected corners')
hold on;
plot(corn(:,1),corn(:,2),'r*'),title('Corner Points');

