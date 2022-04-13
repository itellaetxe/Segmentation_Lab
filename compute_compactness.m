function Co = compute_compactness(bound, mask)
    P = sum(bound, 'all');
    A = sum(or(mask, bound), 'all');

    Co = (P^2)/A;
end