function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
    %filter = rot90(filter, 2);
    [f_m, f_n] = size(filter);
    assert(mod(f_m, 2) ~= 0 && mod(f_n, 2) ~= 0, 'even size filter error');
    mid_f_m = (f_m + 1)/2;
    mid_f_n = (f_n + 1)/2;
    [m,n,channel] = size(image);
    output = zeros(m,n,channel);
    % padding
    pad_img = padarray(image, [mid_f_m - 1 mid_f_n - 1]);
    [m2,n2,c2] = size(pad_img);
    % fill up-pad
    x = mid_f_m;
    for i=1:mid_f_m - 1
        x = x - 1;
        for j=1:n2
            if j < mid_f_n
                y = mid_f_n - j;
            elseif j >= mid_f_n + n
                y = n - (j - (n + mid_f_n));
            else
                y = j - mid_f_n + 1;
            end
            pad_img(i,j) = image(x,y);
        end
    end
    % fill down-pad
    x = m + 1;
    for i=m+mid_f_m:m2
        x = x - 1;
        for j=1:n2
            if j < mid_f_n
                y = mid_f_n - j;
            elseif j >= mid_f_n + n
                y = n - (j - (n + mid_f_n));
            else
                y = j - mid_f_n + 1;
            end
            pad_img(i,j) = image(x,y);
        end
    end
    % fill left-pad, right-pad
    for i=mid_f_m:m+mid_f_m-1
        x = i - mid_f_m + 1;
        for j=1:mid_f_n-1
            y = mid_f_n - j;
            pad_img(i,j) = image(x,y);
        end
        for j=n+mid_f_n:n2
            y = n - (j - (n + mid_f_n));
            pad_img(i,j) = image(x,y);
        end
    end
    
    %using fft based convolution
    for c=1:channel
        conv_fft = ifft2(fft2(pad_img(:,:,c),m2+f_m-1,n2+f_n-1).*fft2(filter,m2+f_m-1,n2+f_n-1));
        output(:,:,c) = conv_fft(f_m:m+f_m-1, f_n:n+f_n-1);
    end


end
