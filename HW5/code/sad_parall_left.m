function sad_slice = sad_parall_left(right,pad_left, d, block_width)
    s = size(right);
    w = s(2);
    h = s(1);
    sad_sum = zeros(h, w, block_width^2);
    
    pad = round(block_width/2) - 1;
    % pad for block
    padded_left = padarray(pad_left,[pad pad], -1, 'both');

    for bx = 1 : block_width
        for by = 1 : block_width
            temp = abs(right - padded_left(by:h-1 + by, bx + d:w-1 + bx + d,:));
            temp(right == -1) = 5;
            temp(padded_left(by:h-1 + by, bx + d:w-1 + bx + d,:) == -1) = 5;
            sad_sum(:,:,bx + block_width * by) = mean(temp,3);
        end
    end
    sad_slice = mean(sad_sum,3);
    sad_slice(sad_slice == 15) = -1;
    sad_slice(sad_slice > 1) = -1;
    
    % Confidence = 1 - SAD
    sad_slice = 1 - sad_slice;
    
    % still not going to use -1 regions
    sad_slice(sad_slice == 2) = -1;
end












%                 Srl = 0;
%                 Sr = 0;
%                 Sl = 0;
%                 m = block_width;
%                 Srr = 0;
%                 Sll = 0;
%                 
%                 parfor bx = -(round(block_width/2) - 1) : (round(block_width/2) - 1)
%                     for by = -(round(block_width/2) - 1) : (round(block_width/2) - 1)
%                         if (i + bx) <= 0 || (i + bx) > w || (j + by) <= 0 || (j + by) > h
%                             Il = double(img_left(j, i));
%                         else
%                             Il = double(img_left(j + by, i + bx));
%                         end
%                         if (i_t + bx) <= 0 || (i_t + bx) > w || (j_t + by) <= 0 || (j_t + by) > h
%                             Ir = double(img_right(j_t, i_t));
%                         else
%                             Ir = double(img_right(j_t + by, i_t + bx));
% 
%                         end
%                         
%                         Srl = Srl + Il * Ir;
%                         Sr = Sr + Ir;
%                         Sl = Sl + Il;
%                         Srr = Srr + Ir * Ir;
%                         Sll = Sll + Il * Il;
% 
%                     end
%                 end
