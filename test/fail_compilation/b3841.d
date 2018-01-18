// PERMUTE_ARGS:
// REQUIRED_ARGS: -w -o-

/*
TEST_OUTPUT:
---
fail_compilation/b3841.d(42): Deprecation: use of complex type `cfloat` is deprecated, use `std.complex.Complex!(float)` instead
fail_compilation/b3841.d-mixin-44(44): Warning: `char += float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `int += float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `long += double` is performing truncating conversion
fail_compilation/b3841.d(42): Deprecation: use of complex type `cfloat` is deprecated, use `std.complex.Complex!(float)` instead
fail_compilation/b3841.d-mixin-44(44): Warning: `char -= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `int -= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `long -= double` is performing truncating conversion
fail_compilation/b3841.d(42): Deprecation: use of complex type `cfloat` is deprecated, use `std.complex.Complex!(float)` instead
fail_compilation/b3841.d-mixin-44(44): Warning: `char *= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `int *= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `long *= double` is performing truncating conversion
fail_compilation/b3841.d(42): Deprecation: use of complex type `cfloat` is deprecated, use `std.complex.Complex!(float)` instead
fail_compilation/b3841.d-mixin-44(44): Warning: `char /= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `int /= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `long /= double` is performing truncating conversion
fail_compilation/b3841.d(42): Deprecation: use of complex type `cfloat` is deprecated, use `std.complex.Complex!(float)` instead
fail_compilation/b3841.d-mixin-44(44): Warning: `char %= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `int %= float` is performing truncating conversion
fail_compilation/b3841.d-mixin-44(44): Warning: `long %= double` is performing truncating conversion
fail_compilation/b3841.d(42): Deprecation: use of imaginary type `idouble` is deprecated, use `double` instead
fail_compilation/b3841.d(43): Deprecation: use of imaginary type `ifloat` is deprecated, use `float` instead
fail_compilation/b3841.d(42): Deprecation: use of imaginary type `ifloat` is deprecated, use `float` instead
fail_compilation/b3841.d(43): Deprecation: use of imaginary type `idouble` is deprecated, use `double` instead
fail_compilation/b3841.d(42): Deprecation: use of imaginary type `idouble` is deprecated, use `double` instead
fail_compilation/b3841.d(43): Deprecation: use of imaginary type `ifloat` is deprecated, use `float` instead
fail_compilation/b3841.d(42): Deprecation: use of imaginary type `ifloat` is deprecated, use `float` instead
fail_compilation/b3841.d(43): Deprecation: use of imaginary type `idouble` is deprecated, use `double` instead
---
*/


void f(string op, LHS, RHS)()
{
    // pragma(msg, LHS, " += ", RHS);
    LHS a;
    RHS b;
    mixin("a "~op~" b;");
}

template Ops(T...)
{
    alias Ops = T;
}

void main()
{
    foreach (string op; Ops!("+=", "-=", "*=", "/=", "%="))
    {
        // OK
        f!(op, int, int)();
        f!(op, long, int)();
        f!(op, long, short)();
        f!(op, float, long)();
        f!(op, cfloat, long)();
        f!(op, double, float)();

        // Should that really be OK ?
        f!(op, short, int)();
        f!(op, float, double)();

        // Not OK, truncating conversion.
        f!(op, char, float)();
        f!(op, int, float)();
        f!(op, long, double)();
    }

    foreach (string op; Ops!("+=", "-="))
    {
        // OK
        f!(op, idouble, ifloat)();

        // Should that really be OK ?
        f!(op, ifloat, idouble)();
    }

    // OK
    f!("^^=", int, int)();
    f!("^^=", long, int)();
    f!("^^=", long, short)();
    f!("^^=", float, long)();
    f!("^^=", double, float)();
    // Should that really be OK ?
    f!("^^=", float, double)();
}
