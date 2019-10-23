%% HW5-c
function d = calculate_disparity_map(img_left, img_right, window_size, max_disparity)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    s = size(img_right);
    w = s(2);
    h = s(1);
    
    cost_vol = zeros(h, w, max_disparity);

    pad_left = padarray(img_left, [0 max_disparity], -1, 'post');
    
    block_pad = round(window_size/2) - 1;
    padded_left = padarray(pad_left,[block_pad block_pad], 'replicate', 'both');
 
    pad_right = padarray(img_right, [block_pad block_pad], 'replicate', 'both');
 
    
    filter = zeros(window_size, window_size);
    
    filter(1:window_size, 1:window_size) = 1 / (window_size^2);
    
    avg_right = imfilter(img_right, filter, 'replicate');
    avg_left = imfilter(pad_left, filter, 'replicate');

    a = zeros(window_size^2);
    b = zeros(window_size^2);
    for i=1:h
        for j=1:w
            for d = 1:max_disparity
                avg_l = avg_left(i, j + d);
                avg_r = avg_right(i,j);
                A = padded_left(i:i+block_pad+1, j+d:j+d+block_pad+1);
                a = A(:) - avg_l;
                B = pad_right(i:i+block_pad+1, j:j+block_pad+1);
                b = B(:) - avg_r;
                cost_vol(i,j,d) = -dot(a,b) / (norm(a) * norm(b));
            end
        end
    end
    
    for d = 1:max_disparity
        cost_vol(:,:,d) = imfilter(cost_vol(:,:,d), filter, 'replicate');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % winner takes all
    [min_val, index] = min(cost_vol,[],3);
    
    d = index;
end

