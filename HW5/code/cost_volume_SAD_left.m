function cost_vol = cost_volume_SAD_left(right, left, block_width, max_disparity)
    s = size(right);
    w = s(2);
    h = s(1);
    
    cost_vol = zeros(h, w, max_disparity);

    % padding with max disparity
    pad_left = padarray(left, [0 max_disparity], -1, 'post');


    for d = 1: 1 : max_disparity

        cost_vol(:, :, d) = sad_parall_left(right, pad_left, d, block_width);
    end

end
