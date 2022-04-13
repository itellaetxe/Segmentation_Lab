%% Check for all images

close all;

imagefiles = dir('./Segmentation_Classification_Lab/*.png');      
nfiles = length(imagefiles);    % Number of files found

varTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", ...
    "double", "double", "double", "double", "double", "double", "double"];

varNames = ["Img", "Compactness", "Texture_contr_x", "Texture_corr_x", "Texture_energy_x", ...
    "Texture_homog_x", "Texture_contr_y", "Texture_corr_y", "Texture_energy_y", "Texture_homog_y", ...
    "Shape_mom1", "Shape_mom2", "Shape_mom3", "Shape_mom4", "Contour_signature", "Fourier_descr"];

df = table('Size', [nfiles, length(varNames)], 'VariableTypes', varTypes, 'VariableNames', varNames);

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread("./Segmentation_Classification_Lab/" + currentfilename);
   images{ii} = im2double(rgb2gray(currentimage))+randn([400 400]).*.02;
   df.Img(ii) = imagefiles(ii).name;
end

for i = 1:nfiles
    [tmp_mask, tmp_bound] = segment_element(cell2mat(images(i)));
    df.Compactness(i) = compute_compactness(tmp_bound, tmp_mask);

    [text_stat_x, text_stat_y] = compute_texture_statistics(images{i}, tmp_mask);
    df.Texture_contr_x(i) = text_stat_x.Contrast;
    df.Texture_corr_x(i) = text_stat_x.Correlation;
    df.Texture_energy_x(i) = text_stat_x.Energy;
    df.Texture_homog_x(i) = text_stat_x.Homogeneity;
    df.Texture_contr_y(i) = text_stat_y.Contrast;
    df.Texture_corr_y(i) = text_stat_y.Correlation;
    df.Texture_energy_y(i) = text_stat_y.Energy;
    df.Texture_homog_y(i) = text_stat_y.Homogeneity;

    df.Shape_mom1(i) = compute_shape_moments(tmp_mask, 1);
    df.Shape_mom2(i) = compute_shape_moments(tmp_mask, 2);
    df.Shape_mom3(i) = compute_shape_moments(tmp_mask, 3);
    df.Shape_mom4(i) = compute_shape_moments(tmp_mask, 4);

%     [df.Contour_signature(i), ~, ~] = edge_features(images{i});
    [~, df.Fourier_descr(i)] = fourier_descriptors(imcomplement(images{i}));
end


