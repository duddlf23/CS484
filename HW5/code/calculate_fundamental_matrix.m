%% HW5-a
% Use Normalized Eight-Point algorithm
function f = calculate_fundamental_matrix(pts1, pts2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here

    [n, m] = size(pts1);
    
    A = zeros(n,9);
    
    for i=1:n
        x = pts1(i,1);
        y = pts1(i,2);
        x2 = pts2(i,1);
        y2 = pts2(i,2);
        A(i,1) = x*x2;
        A(i,2) = x*y2;
        A(i,3) = x;
        A(i,4) = y*x2;
        A(i,5) = y*y2;
        A(i,6) = y;
        A(i,7) = x2;
        A(i,8) = y2;
        A(i,9) = 1;
    end
    
    A2 = A.' * A;
    [v, e] = eig(A2);
    
    k = 1;
    eigen_value = e(k,k);
    f = v(:,k);
    f = f / norm(f);
    F = zeros(3,3);
    for i=1:3
        for j=1:3
            F(i,j) = f(i + (j-1) * 3);
        end
    end
    
    [U, S, V] = svd(F);
    S(3,3) = 0;
    F2 = U*S*V.';
    
    f = F2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Delete here when you run your code
    
end