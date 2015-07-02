function [a] = balu2mil(X,d,Bag)

        d_mil = genmillabels(d, 1);
        a = genmil(X,d_mil,Bag);
end