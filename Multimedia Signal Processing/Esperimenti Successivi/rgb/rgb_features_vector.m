function features_vector = rgb_features_vector256(x, f_v, f_h, h_o)
    reSize = [256 256];
    r = centerCropWindow2d(size(x),reSize);
    J = imcrop(x,r);
    R = J(:,:,1);
    G = J(:,:,2);
    B = J(:,:,3);
    R_v = imfilter(R,f_v);
    R_h = imfilter(R,f_h);
    G_v = imfilter(G,f_v);
    G_h = imfilter(G,f_h);
    B_v = imfilter(B,f_v);
    B_h = imfilter(B,f_h);
    QR_v = min(max(round(R_v) + 2,0),4);
    QR_h = min(max(round(R_h) + 2,0),4);
    QG_v = min(max(round(G_v) + 2,0),4);
    QG_h = min(max(round(G_h) + 2,0),4);
    QB_v = min(max(round(B_v) + 2,0),4);
    QB_h = min(max(round(B_h) + 2,0),4); 
    CR_v = imfilter(QR_v,h_o);
    CR_h = imfilter(QR_h,h_o);
    CG_v = imfilter(QG_v,h_o);
    CG_h = imfilter(QG_h,h_o);
    CB_v = imfilter(QB_v,h_o);
    CB_h = imfilter(QB_h,h_o);
    hR_v = hist(CR_v(:),[0:624]);
    hR_h = hist(CR_h(:),[0:624]);
    hG_v = hist(CG_v(:),[0:624]);
    hG_h = hist(CG_h(:),[0:624]);
    hB_v = hist(CB_v(:),[0:624]);
    hB_h = hist(CB_h(:),[0:624]);
    features_vector = cat(2, hR_v, hR_h, hG_v, hG_h, hB_v, hB_h);
end

