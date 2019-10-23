%% MATLAB version R2018a


%% read bayer pattern images
data_path = '../data/scene/';
img_path_1 = [data_path,'bayer_cam1.png'];
img_path_2 = [data_path,'bayer_cam2.png'];
bayer_img1 = imread(img_path_1);
bayer_img2 = imread(img_path_2);

%% HW5-a
img1 = bayer_to_rgb_bicubic(bayer_img1);
img2 = bayer_to_rgb_bicubic(bayer_img2);

%% read feature points
feature_point = importdata([data_path, 'feature_points.txt']);
pts1 = feature_point(1:8,1:2);
pts2 = feature_point(1:8,3:4);

%% visualize matching points on images
figure;
subplot(1,2,1);
imshow(img1);title('Left image');hold on;
plot(pts1(:,1),pts1(:,2),'ro');
subplot(1,2,2);
imshow(img2);title('Right image');hold on;
plot(pts2(:,1),pts2(:,2),'go');

%% HW5-b
Fundamental_matrix = calculate_fundamental_matrix(pts1, pts2);

%% HW5-c
[Homography_left, Homography_right] = calculate_rectification_matrix(Fundamental_matrix, size(img1), pts1, pts2);

%% Rectifiy each image
[Rectified_img_left, Rectified_img_right] = rectifyStereoImages(img1, img2, Homography_left, Homography_right, 'OutputView', 'full');

%% visualize rectified images
figure;
subplot(1,2,1);
imshow(Rectified_img_left);title('Rectified Left image');hold on;
subplot(1,2,2);
imshow(Rectified_img_right);title('Rectified Right image');hold on;

%% HW5-d
% generate a disparity map from the two rectified images
% Use NCC for matching cost function with window size 3
window_size = 3;
max_disparity = 50;

gray_img1 = im2double(rgb2gray(Rectified_img_left));
gray_img2 = im2double(rgb2gray(Rectified_img_right));

Disparity_map = calculate_disparity_map(gray_img1, gray_img2, window_size, max_disparity);

figure;imagesc(Disparity_map);colorbar;









