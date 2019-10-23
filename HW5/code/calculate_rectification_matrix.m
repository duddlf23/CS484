%% HW5-b
function [t1, t2] = calculate_rectification_matrix(f, imageSize, pts1, pts2)

    % Find the epipole
    [u, d, v] = svd(f);
    epipole = u(:, 3);

    % Find g, r, t matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here
    w = imageSize(2);
    h = imageSize(1);
    t = eye(3);
    t(1,3) = -w / 2;
    t(2,3) = -h / 2;
    e = epipole / epipole(3);
    e2 = t * e;
    
    ang = atan2(e2(2), e2(1));
    co = cos(-ang + pi);
    si = sin(-ang + pi );
    
    r = eye(3);
    r(1,1) = co;
    r(1,2) = -si;
    r(2,1) = si;
    r(2,2) = co;
    
    e3 = r * e2;
    g = eye(3);
    g(3,1) = -1 / e3(1);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Compute the overall transformation for the second image.
    t2 = g * r * t;
    t([1,2], 3) = -t([1,2], 3);
    t2 = t * t2;
    if(t2(end)) ~= 0
      t2 = t2 / t2(end);
    end

    %--------------------------------------------------------------------------
    % Compute the projective transformation for the first camera.
    %--------------------------------------------------------------------------

    % Compute a (partial) synthetic camera matrix for the second camera.
    % This is matrix M, such that F=SM, where S is a skew-symmetric matrix.  
    % Unfortunately, M cannot be computed using the usual factorization, where
    % S = [e]_x and M = [e]_x * F, because then M will be singular. Instead, M
    % must be computed using the SVD of F.
    % See http://www.robots.ox.ac.uk/~vgg/hzbook/hzbook2/clarification_rectification.pdf
    z = [ 0, -1, 0;
               1,  0, 0;
               0,  0, 1];
    d(3,3) = (d(1,1) + d(2,2)) / 2;
    m = u * z * d * v';

    % Compute the transformation for the first camera so the rows in the first
    % camera correspond the rows at the same location in the second camera.
    h1r = t2 * m;

    % Compute the transformation for the first camera so the points have
    % (approximately) the same column locations in the first and second images.
    numPoints = size(pts1, 1);
    p1 = h1r * [pts1'; ones(1, numPoints)];
    p2 = t2  * [pts2'; ones(1, numPoints)];

    p2InfinityIdx = abs(p2(3,:)) < eps;
    p2(3, p2InfinityIdx) = eps;
    b = p2(1,:) ./ p2(3,:) .* p1(3,:);
    y = p1' \ b';
    h1c = [y(1), y(2), y(3);          
           0,    1,    0;
           0,    0,    1];

    % Compute the overall transformation for the first camera.
    t1 = h1c * h1r;
    if(t1(end)) ~= 0
      t1 = t1 / t1(end);
    end

    t1 = t1';
    t2 = t2';

    %% Delete here when you run your code


end