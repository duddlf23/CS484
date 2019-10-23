%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_words(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x feature vector length
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct feature descriptors here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% feature descriptors will look very different from a smaller version of the same
% image.

load('vocab.mat')
vocab_size = size(vocab, 1);
disp(vocab_size);
N = length(image_paths);
image_feats = zeros(N,vocab_size);
disp(N);
disp(size(image_feats));
vocab = cast(vocab, 'single');

soft_assignment = true;

for k=1:N
    disp(k);
    image = im2single(imread(image_paths{k}));
    [n, m] = size(image);
    
    step = floor(max(n,m) / 30);
    %step = 15;
    %disp([n,m,step]);
    
    %features = extractHOGFeatures(image, 'CellSize',[4 4],'BlockSize',[1 1]);
    %size(features);
    for i=1:step:n-15
        %disp(i);
        for j=1:step:m-15
            features = extractHOGFeatures(image(i:i+15,j:j+15), 'CellSize',[4 4],'BlockSize',[1 1]);
            %disp(features);
            D = pdist2(vocab, cast(features, 'single'));
            if soft_assignment
                D = -10 * D.^2;
                eD = exp(D);
                image_feats(k,:) = image_feats(k,:) + (eD / sum(eD)).';
            else
                [~, idx] = min(D(:,1));
                image_feats(k,idx) = image_feats(k,idx) + 1;
            end
        end
    end
    %disp(sum(image_feats(k,:)));
    image_feats(k,:) = image_feats(k,:) / max(image_feats(k,:));
end


