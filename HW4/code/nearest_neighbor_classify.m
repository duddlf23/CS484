%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

% Useful functions:
%  matching_indices = strcmp(string, cell_array_of_strings)
%    This can tell you which indices in train_labels match a particular
%    category. Not necessary for simple one nearest neighbor classifier.
 
%   [Y,I] = MIN(X) if you're only doing 1 nearest neighbor, or
%   [Y,I] = SORT(X) if you're going to be reasoning about many nearest
%   neighbors 

N = size(train_image_feats, 1);
M = size(test_image_feats, 1);
categories = unique(train_labels);
C = length(categories);

predicted_categories = cell(M, 1);
NBNN = true;

if NBNN
    D = zeros(C,M);
    C_train = cell(C, 1);
    for i=1:C
        idx = strcmp(train_labels, categories{i});
        C_train{i} = train_image_feats(idx, :);
    end
    num_f = 8;
    num_iter = length(train_image_feats(1,:)) / num_f;
    for i=1:M
        for j=1:C
            d = C_train{j} - test_image_feats(i,:);
            d = d.^2;
            dd = zeros(size(d,1), num_iter);
            for k=1:num_iter
                for l=1:num_f
                    dd(:,k) = dd(:,k) + d( : , (k - 1) * num_f + l);
                end
            end
            dd = min(dd);
            D(j, i) = D(j, i) + sum(dd);
        end
        [~,idx] = min(D(:,i));
        predicted_categories{i} = categories{idx};
    end
    
else
    D = pdist2(train_image_feats, test_image_feats);
    K = 15;
    for i=1:M
        [~,idx] = sort(D(:,i));
        cnt = zeros(C, 1);
        for j=1:K
            id = strcmp(categories, train_labels{idx(j)});
            ii = find(id);
            cnt(ii) = cnt(ii) + 1;
        end
        [~, idx] = max(cnt);
        predicted_categories{i} = categories{idx};
    end
end







