function Co = compute_compactness(bound, mask)
    %{
        Computes compactness.

        IN: Boundary (perimeter) logical matrix, mask logical matrix
        OUT: Compactness measure
    %}

    P = sum(bound, 'all');
    A = sum(or(mask, bound), 'all');

    Co = (P^2)/A;
end