% images2gray 


directory = './Lab5_testimages';
images = dir(fullfile(directory,'*.png'));
names = {images.name}';
O=cell(numel(names), 1);
G=cell(numel(names), 1);
N =cell(numel(names), 1);


for k=1: numel(names)

      O{k} = imread(fullfile(directory,names{k}));
      newimage = cell2mat(O(k));
      newimage = rgb2gray(newimage);
      G{k} = newimage;

      if k==1
        figure;
        subplot(3,2,1),imshow(newimage),title("Image " + k);
      else
        subplot(3,2,k),imshow(newimage),title("Image " + k);
      end
end

% Template
img1_red_car = O{1};
img1_red_car = rgb2gray(img1_red_car);
img1_red_car = img1_red_car(360:415, 688:772);
figure, imshow(img1_red_car), title('Window - Red car')



% Normalization

for k=1: numel(names)

      newimage = cell2mat(G(k));
      normimage = normxcorr2(img1_red_car, newimage);
      N{k} = normimage;

      if k==1
        figure;
        subplot(3,2,1),imshow(normimage),title("Image Norm " + k);
      else
        subplot(3,2,k),imshow(normimage),title("Image Norm " + k);
      end
      
end

for k=1: numel(names)

      c = cell2mat(N(k));
      [ypeak,xpeak] = find(c==max(c(:)));
      yoffSet = ypeak-size(img1_red_car,1);
      xoffSet = xpeak-size(img1_red_car,2);
   
      
      if k==1
        figure;
        subplot(3,2,1),imshow(newimage),title("Image Detected " + k);
        drawrectangle(gca,'Position',[xoffSet,yoffSet,size(img1_red_car,2),size(img1_red_car,1)], ...
    'FaceAlpha',0);
      else
        subplot(3,2,k),imshow(newimage),title("Image Detected " + k);
        drawrectangle(gca,'Position',[xoffSet,yoffSet,size(img1_red_car,2),size(img1_red_car,1)], ...
    'FaceAlpha',0);
      end
      
end





