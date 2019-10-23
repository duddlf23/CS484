% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'descriptor_window_image_width', in pixels.
%   This is the local feature descriptor width. It might be useful in this function to 
%   (a) suppress boundary interest points (where a feature wouldn't fit entirely in the image, anyway), or
%   (b) scale the image filters being used. 
% Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, descriptor_window_image_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points
%x = ceil(rand(500,1) * size(image,2));
%y = ceil(rand(500,1) * size(image,1));

[r, c] = size(image);

alpha = 0.05;
thr = 1000;
image = imfilter(image, fspecial('gaussian', 3, 1));
grad_x =  imfilter(image, fspecial('sobel')', 'replicate');
grad_y =  imfilter(image, fspecial('sobel'), 'replicate');

grad_xx = grad_x.^2;
grad_yy = grad_y.^2;
grad_xy = grad_x.*grad_y;

grad_xx_accum = zeros(r,c);
grad_yy_accum = zeros(r,c);
grad_xy_accum = zeros(r,c);
grad_xx_accum(1,1) = grad_xx(1,1);
grad_yy_accum(1,1) = grad_yy(1,1);
grad_xy_accum(1,1) = grad_xy(1,1);
for j=2:c
    grad_xx_accum(1,j) = grad_xx_accum(1,j-1) + grad_xx(1,j);
    grad_yy_accum(1,j) = grad_yy_accum(1,j-1) + grad_yy(1,j);
    grad_xy_accum(1,j) = grad_xy_accum(1,j-1) + grad_xy(1,j);
end
for i=2:r
    grad_xx_accum(i,1) = grad_xx_accum(i-1,1) + grad_xx(i,1);
    grad_yy_accum(i,1) = grad_yy_accum(i-1,1) + grad_yy(i,1);
    grad_xy_accum(i,1) = grad_xy_accum(i-1,1) + grad_xy(i,1);
end
for i=2:r
    for j=2:c
        grad_xx_accum(i,j) = grad_xx_accum(i,j-1) + grad_xx_accum(i-1,j) - grad_xx_accum(i-1,j-1) + grad_xx(i,j);
        grad_yy_accum(i,j) = grad_yy_accum(i,j-1) + grad_yy_accum(i-1,j) - grad_yy_accum(i-1,j-1) + grad_yy(i,j);
        grad_xy_accum(i,j) = grad_xy_accum(i,j-1) + grad_xy_accum(i-1,j) - grad_xy_accum(i-1,j-1) + grad_xy(i,j);
    end
end
%disp(grad_xx(1:5,1:5));
%disp(grad_xx_accum(1:5,1:5));
n = 0;
x=[];
y=[];
C_arr=[];
w = descriptor_window_image_width/2;
%disp(w);
for i=descriptor_window_image_width:r-descriptor_window_image_width
    for j=descriptor_window_image_width:c-descriptor_window_image_width
        x1 = i-w;
        y1 = j-w;
        x2 = i+w;
        y2 = j+w;
        I_xx = grad_xx_accum(x2,y2) - grad_xx_accum(x1-1,y2) - grad_xx_accum(x2,y1-1) + grad_xx_accum(x1-1,y1-1);
        I_yy = grad_yy_accum(x2,y2) - grad_yy_accum(x1-1,y2) - grad_yy_accum(x2,y1-1) + grad_yy_accum(x1-1,y1-1);
        I_xy = grad_xy_accum(x2,y2) - grad_xy_accum(x1-1,y2) - grad_xy_accum(x2,y1-1) + grad_xy_accum(x1-1,y1-1);
        C = I_xx * I_yy - I_xy^2 - alpha * (I_xx + I_yy);
        if C>thr
            n=n+1;
            C_arr(n) = C;
            x(n, 1) = j;
            y(n, 1) = i;
        end
    end
end
[~, ind] = sort(C_arr, 'descend');
x = x(ind,:);
y = y(ind,:);
ind = zeros(1,n);
visit = zeros(r,c);
w = descriptor_window_image_width/4;
for i=1:n
    if visit(y(i), x(i)) == 0
        ind(i) = 1;
        for j=y(i)-w:y(i)+w
            for k=x(i)-w:x(i)+w
                if dot([j, k] - [y(i), x(i)], [j, k] - [y(i), x(i)]) <= w^2
                    visit(j,k) = 1;
                end
            end
        end
    end
end
ind = logical(ind);
x = x(ind,:);
y = y(ind,:);
confidence = 1;
scale = 1;
orientation = 1;
% After computing interest points, here's roughly how many we return
% For each of the three image pairs
% - Notre Dame: ~1300 and ~1700
% - Mount Rushmore: ~3500 and ~4500
% - Episcopal Gaudi: ~1000 and ~9000

end

