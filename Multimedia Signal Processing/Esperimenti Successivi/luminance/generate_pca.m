function [T, PCA, AVERAGE] = generate_pca(features_space, N)
    [T, PCA, temp1,temp2,temp3, AVERAGE] = pca(features_space, 'Centered', true, 'NumComponents', N);
end