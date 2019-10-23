% This function will extract a set of feature descriptors from the training images,
% cluster them into a visual vocabulary with k-means,
% and then return the cluster centers.

% Notes:
% - To save computation time, we might consider sampling from the set of training images.
% - Per image, we could randomly sample descriptors, or densely sample descriptors,
% or even try extracting descriptors at interest points.
% - For dense sampling, we can set a stride or step side, e.g., extract a feature every 20 pixels.
% - Recommended first feature descriptor to try: HOG.

% Function inputs: 
% - 'image_paths': a N x 1 cell array of image paths.
% - 'vocab_size' the size of the vocabulary.

% Function outputs:
% - 'vocab' should be vocab_size x descriptor length. Each row is a cluster centroid / visual word.

function vocab = build_vocabulary( image_paths, vocab_size )

image_n = length(image_paths);
feat = zeros(100000,144);
feat_n = 0;
idx = randperm(image_n, 750);

for k = idx
    image = im2single(imread(image_paths{k}));
    [n, m] = size(image);
    step = floor(max(n,m) / 10);
    
    for i=1:step:n-15
        for j=1:step:m-15
            features = extractHOGFeatures(image(i:i+15,j:j+15), 'CellSize',[4 4],'BlockSize',[1 1]);
            feat_n = feat_n + 1;
            feat(feat_n, :) = features;
        end
    end
    
end
disp(feat_n);
feat = feat(1:feat_n,:);
[idx, vocab] = kmeans(feat,vocab_size,'MaxIter',1000);







