function [Mdl, Y] = generate_mdl(PCA)

    X = PCA';
    Y = [];
    for i = 1:150
        Y = cat(1,Y,{'Alessandro'});
    end
    for i = 1:150
        Y = cat(1,Y,{'Raffaele'});
    end
    for i = 1:150
        Y = cat(1,Y,{'Cesare'});
    end
    for i = 1:150
        Y = cat(1,Y,{'Umberto'});
    end
    Y = categorical(Y);

    Mdl = fitcecoc(X,Y,'Learners',templateSVM('Standardize',true),'ObservationsIn','columns');
end

