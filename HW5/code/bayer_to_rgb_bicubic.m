%% HW5-b
% generate rgb image from bayer pattern image using bicubic interpolation
function rgb_img = bayer_to_rgb_bicubic(bayer_img)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here

    [n, m, f] = size(bayer_img);
    
    rgb_img = zeros(n,m,3);
    
    for i = 1:n
        for j = 1:m
            if mod(i, 2) == 1 && mod(j, 2) == 1
                rgb_img(i, j, 1) = bayer_img(i, j);
            elseif mod(i, 2) == 1 && mod(j, 2) == 0
                if j == m
                    rgb_img(i,j,1) = bayer_img(i,j - 1);
                else
                    rgb_img(i,j,1) = (bayer_img(i,j-1) + bayer_img(i,j+1)) / 2;
                end
            elseif mod(i, 2) == 0 && mod(j, 2) == 1
                if i == n
                    rgb_img(i,j,1) = bayer_img(i - 1,j);
                else
                    rgb_img(i,j,1) = (bayer_img(i - 1,j) + bayer_img(i + 1,j)) / 2;
                end
            elseif mod(i, 2) == 0 && mod(j, 2) == 0
                if i == n && j == m
                    rgb_img(i,j,1) = bayer_img(i-1,j-1);
                elseif i == n
                    rgb_img(i,j,1) = (bayer_img(i-1,j-1) + bayer_img(i-1,j+1)) / 2;
                elseif j == m
                    rgb_img(i,j,1) = (bayer_img(i-1,j-1) + bayer_img(i+1,j-1)) / 2;
                else
                    rgb_img(i,j,1) = (bayer_img(i-1,j-1) + bayer_img(i-1,j+1) + bayer_img(i+1,j-1) + bayer_img(i+1,j+1)) / 4;
                end
            end
        end
    end

        
    for i = 1:n
        for j = 1:m
            if mod(i, 2) == 0 && mod(j, 2) == 0
                rgb_img(i, j, 3) = bayer_img(i, j);
            elseif mod(i, 2) == 0 && mod(j, 2) == 1
                if j == 1
                    rgb_img(i,j,3) = bayer_img(i,j + 1);
                else
                    rgb_img(i,j,3) = (bayer_img(i,j-1) + bayer_img(i,j+1)) / 2;
                end
            elseif mod(i, 2) == 1 && mod(j, 2) == 0
                if i == 1
                    rgb_img(i,j,3) = bayer_img(i + 1,j);
                else
                    rgb_img(i,j,3) = (bayer_img(i - 1,j) + bayer_img(i + 1,j)) / 2;
                end
            elseif mod(i, 2) == 1 && mod(j, 2) == 1
                if i == 1 && j == 1
                    rgb_img(i,j,3) = bayer_img(i+1,j+1);
                elseif i == 1
                    rgb_img(i,j,3) = (bayer_img(i+1,j-1) + bayer_img(i+1,j+1)) / 2;
                elseif j == 1
                    rgb_img(i,j,3) = (bayer_img(i-1,j+1) + bayer_img(i+1,j+1)) / 2;
                else
                    rgb_img(i,j,3) = (bayer_img(i-1,j-1) + bayer_img(i-1,j+1) + bayer_img(i+1,j-1) + bayer_img(i+1,j+1)) / 4;
                end
            end
        end
    end
    
    for i = 1:n
        for j = 1:m
            if mod(i,2) ~= mod(j,2)
                rgb_img(i,j,2) = bayer_img(i,j);
            else
                if i == 1 && j == 1
                    rgb_img(i,j,2) = (bayer_img(i,j+1) + bayer_img(i+1,j)) / 2;
                elseif i == n && j == m
                    rgb_img(i,j,2) = (bayer_img(i,j-1) + bayer_img(i-1,j)) / 2;
                elseif i == 1
                    rgb_img(i,j,2) = (bayer_img(i,j-1) + bayer_img(i,j+1) + bayer_img(i+1,j)) / 3;
                elseif i == n
                    rgb_img(i,j,2) = (bayer_img(i,j-1) + bayer_img(i,j+1) + bayer_img(i-1,j)) / 3;
                elseif j == 1
                    rgb_img(i,j,2) = (bayer_img(i-1,j) + bayer_img(i,j+1) + bayer_img(i+1,j)) / 3;
                elseif j == m
                    rgb_img(i,j,2) = (bayer_img(i-1,j) + bayer_img(i,j-1) + bayer_img(i+1,j)) / 3;
                else
                    rgb_img(i,j,2) = (bayer_img(i-1,j) + bayer_img(i+1,j) + bayer_img(i,j-1) + bayer_img(i,j+1))/ 4;
                end
            end
        end
    end
    
    rgb_img = cast(rgb_img, 'uint8');
    
    %disp (n)
    
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %rgb_img = bayer_img;
end