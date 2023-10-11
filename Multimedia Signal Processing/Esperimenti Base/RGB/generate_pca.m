function [T, PCA, AVERAGE] = generate_pca(features_space, N)
    [T, PCA, temp1,temp1,temp1, AVERAGE] = pca(features_space, 'Centered', true, 'NumComponents', N);
end