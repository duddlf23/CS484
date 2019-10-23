% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width. 
%   You can assume that descriptor_window_image_width will be a multiple of 4 
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, descriptor_window_image_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

%Placeholder that you can delete. Empty features.
features = zeros(size(x,1), 128, 'single');
n = size(x,1);
[r, c] = size(image);
%features = zeros(n, 256, 'single');
% for i =1:n
%     m = 0;
%     for j=x(i)-8:x(i)+7
%         for k=y(i)-8:y(i)+7
%             m=m+1;
%             features(i,m) = image(k,j);
%         end
%     end
% end
%disp(size(image));
    
grad_x =  imfilter(image, fspecial('sobel')', 'replicate');
grad_y =  imfilter(image, fspecial('sobel'), 'replicate');


grad = (grad_x.^2 + grad_y.^2).^0.5;
ori = atan2d(grad_y, grad_x) + 180;

w = descriptor_window_image_width/2;
gauss_distance = fspecial('gaussian', 16, 4);

for i =1:n
    f_i = 0;
    
    grad_patch = grad(y(i)-w:y(i)+w-1, x(i)-w:x(i)+w-1);
    grad_patch = grad_patch .* gauss_distance;
    ori_patch = ori(y(i)-w:y(i)+w-1, x(i)-w:x(i)+w-1);
    ori_patch = grad_patch .* ori_patch;
    dominant_orient = sum(ori_patch(:))/sum(grad_patch(:));
    if dominant_orient == 360
        shift = -7;
    else
        shift = -floor(dominant_orient / 45);
    end
    for j=y(i)-w:4:y(i)+4
        for k=x(i)-w:4:x(i)+4
            h = zeros(1,8);
            for l=j:j+3
                for m=k:k+3
                    if ori(l,m) == 360
                        h_i = 8;
                    else
                        h_i = floor(ori(l,m) / 45) + 1;
                    end
                    h(h_i) = h(h_i) + grad(l,m) ;
                end
            end
            h = circshift(h,shift);
            features(i, f_i+1:f_i+8) = h(:);
            f_i = f_i + 8;
        end
    end
    features(i,:) = normr(features(i,:));
    features(i, features(i,:) > 0.2) = 0.2;
    features(i,:) = normr(features(i,:));
end

    
end








