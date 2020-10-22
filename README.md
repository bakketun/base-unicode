# Base Unicode

Input must be a string of Unicode scalar values, ie. code points in the range 0..D7FF₁₆ and E000₁₆..10FFFF₁₆. The code points are converted into digits by subtracting 2048 for scalar values in the range E000₁₆..10FFFF₁₆. The digits forms a number in base 1112064. The most significant digit represent the first scalar value of the string.

This encoding ensures that any non-negative integer has a mapping to a well-formed Unicode string.

## Examples

257567123001016994007884030689936651950881509385686722166578431211920744481

"yes"ᵤ + "no"ᵤ = "yÓâ"ᵤ
