function features_vector = luminance_features_vector256(x, f_v, f_h, h_o)
    reSize = [256 256];
    r = centerCropWindow2d(size(x),reSize);
    J = imcrop(x,r);
    J1 = rgb2hsi(J);
    I = J1(:,:,3)*255;
    I_v = imfilter(I,f_v);
    I_h = imfilter(I,f_h);
    Q_v = min(max(round(I_v) + 2,0),4);
    Q_h = min(max(round(I_h) + 2,0),4);
    C_v = imfilter(Q_v,h_o);
    C_h = imfilter(Q_h,h_o);
    h_v = hist(C_v(:),[0:624]);
    h_h = hist(C_h(:),[0:624]);
    features_vector = cat(2, h_v,h_h);
end
