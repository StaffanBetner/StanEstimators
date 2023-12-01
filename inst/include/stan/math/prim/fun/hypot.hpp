#ifndef STAN_MATH_PRIM_FUN_HYPOT_HPP
#define STAN_MATH_PRIM_FUN_HYPOT_HPP

#include <stan/math/prim/meta.hpp>
#include <stan/math/prim/functor/apply_scalar_binary.hpp>
#include <cmath>

namespace stan {
namespace math {

/**
 * Return the length of the hypotenuse of a right triangle with
 * opposite and adjacent side lengths given by the specified
 * arguments (C++11).  In symbols, if the arguments are
 * <code>x</code> and <code>y</code>, the result is <code>sqrt(x *
 * x + y * y)</code>.
 *
 * @param x First argument.
 * @param y Second argument.
 * @return Length of hypotenuse of right triangle with opposite
 * and adjacent side lengths x and y.
 */
template <typename T1, typename T2, require_all_arithmetic_t<T1, T2>* = nullptr>
inline double hypot(T1 x, T2 y) {
  using std::hypot;
  return hypot(x, y);
}

/**
 * Enables the vectorized application of the hypot function,
 * when the first and/or second arguments are containers.
 *
 * @tparam T1 type of first input
 * @tparam T2 type of second input
 * @param a First input
 * @param b Second input
 * @return hypot function applied to the two inputs.
 */
template <typename T1, typename T2, require_any_container_t<T1, T2>* = nullptr,
          require_all_not_nonscalar_prim_or_rev_kernel_expression_t<
              T1, T2>* = nullptr>
inline auto hypot(const T1& a, const T2& b) {
  return apply_scalar_binary(
      a, b, [&](const auto& c, const auto& d) { return hypot(c, d); });
}

}  // namespace math
}  // namespace stan
#endif
