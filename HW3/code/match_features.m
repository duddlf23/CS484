% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Please implement the "nearest neighbor distance ratio test", 
% Equation 4.18 in Section 4.1.3 of Szeliski. 
% For extra credit you can implement spatial verification of matches.

%
% Please assign a confidence, else the evaluation function will not work.
%

% This function does not need to be symmetric (e.g., it can produce
% different numbers of matches depending on the order of the arguments).

% Input:
% 'features1' and 'features2' are the n x feature dimensionality matrices.
%
% Output:
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index in features2. 
%
% 'confidences' is a k x 1 matrix with a real valued confidence for every match.

function [matches, confidences] = match_features(features1, features2)

% Placeholder random matches and confidences.
n_f_1 = size(features1, 1);
%disp(n_f_1);
n_f_2 = size(features2, 1);
%disp(n_f_2);
matches = zeros(n_f_1, 2);
confidences = zeros(1, n_f_1);
%matches = [,2];
%confidences = [];
n = 0;
thr = 0.6;

for i = 1:n_f_1
    f_1_i = features1(i,:);
    min1 = -1;
    min2 = -1;
    min1_i = 0;
    min2_i = 0;
    for j = 1:n_f_2
        f_2_j = features2(j,:);
        dist = dot(f_1_i - f_2_j, f_1_i - f_2_j);
        if min1 == -1
            min1 = dist;
            min1_i = j;
        elseif dist < min1
            min2 = min1;
            min2_i = min1_i;
            min1 = dist;
            min1_i = j;
        elseif min2 == -1 || dist < min2
            min2 = dist;
            min2_i = j;
        end
    end
    nndr = min1 / max(min2, 0.0001);
    if nndr < thr
        n = n + 1;
        matches(n, 1) = i;
        matches(n, 2) = min1_i;
        confidences(n) = 1 - nndr;
    end
end

ind = (confidences == 0);

confidences(confidences == 0) = [];
matches(ind, :) = [];

%disp(length(confidences));
%matches = matches(ind,:);
%dddd
        
%matches(:,1) = randperm(num_features); 
%matches(:,2) = randperm(num_features);
%confidences = rand(num_features,1);

% Remember that the NNDR test will return a number close to 1 for 
% feature points with similar distances.
% Think about how confidence relates to NNDR.