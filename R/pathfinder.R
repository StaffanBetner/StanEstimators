setOldClass("draws_df")
setClass("StanPathfinder",
  slots = c(
    metadata = "list",
    timing = "list",
    draws = "draws_df"
  )
)

#' Summary method for objects of class \code{StanPathfinder}.
#'
#' @docType methods
#' @name summary-StanPathfinder
#' @rdname summary-StanPathfinder
#' @aliases summary-StanPathfinder summary,StanPathfinder-method
#'
#' @param object A \code{StanPathfinder} object.
#' @param ... Additional arguments, currently unused.
#'
#' @export
setMethod("summary", "StanPathfinder", function(object, ...) {
  posterior::summarise_draws(object@draws)
})

#' stan_pathfinder
#'
#' Estimate parameters using Stan's pathfinder algorithm
#'
#' @param fn Function to estimate parameters for
#' @param par_inits Initial values
#' @param additional_args List of additional arguments to pass to the function
#' @param grad_fun Function calculating gradients w.r.t. each parameter
#' @param lower Lower bound constraint(s) for parameters
#' @param upper Upper bound constraint(s) for parameters
#' @param seed Random seed
#' @param refresh Number of iterations for printing
#' @param quiet (logical) Whether to suppress Stan's output
#' @param output_dir Directory to store outputs
#' @param output_basename Basename to use for output files
#' @param sig_figs Number of significant digits to use for printing
#' @param init_alpha (positive real) The initial step size parameter.
#' @param tol_obj (positive real) Convergence tolerance on changes in objective function value.
#' @param tol_rel_obj (positive real) Convergence tolerance on relative changes in objective function value.
#' @param tol_grad (positive real) Convergence tolerance on the norm of the gradient.
#' @param tol_rel_grad (positive real) Convergence tolerance on the relative norm of the gradient.
#' @param tol_param (positive real) Convergence tolerance on changes in parameter value.
#' @param history_size (positive integer) The size of the history used when
#'   approximating the Hessian.
#' @param num_psis_draws (positive integer) Number PSIS draws to return.
#' @param num_paths (positive integer) Number of single pathfinders to run.
#' @param save_single_paths (logical) Whether to save the results of single
#'   pathfinder runs in multi-pathfinder.
#' @param max_lbfgs_iters (positive integer) The maximum number of iterations
#'   for LBFGS.
#' @param num_draws (positive integer) Number of draws to return after performing
#'   pareto smooted importance sampling (PSIS).
#' @param num_elbo_draws (positive integer) Number of draws to make when
#'   calculating the ELBO of the approximation at each iteration of LBFGS.
#' @return \code{StanPathfinder} object
#' @export
stan_pathfinder <- function(fn, par_inits, additional_args = list(), grad_fun = NULL,
                          lower = -Inf, upper = Inf,
                          seed = NULL,
                          refresh = NULL,
                          quiet = FALSE,
                          output_dir = NULL,
                          output_basename = NULL,
                          sig_figs = NULL,
                          init_alpha = NULL, tol_obj = NULL,
                          tol_rel_obj = NULL, tol_grad = NULL,
                          tol_rel_grad = NULL, tol_param = NULL,
                          history_size = NULL, num_psis_draws = NULL,
                          num_paths = NULL, save_single_paths = NULL,
                          max_lbfgs_iters = NULL, num_draws = NULL,
                          num_elbo_draws = NULL) {
  inputs <- prepare_inputs(fn, par_inits, additional_args, grad_fun, lower, upper,
                            output_dir, output_basename)
  method_args <- list(
    init_alpha = init_alpha,
    tol_obj = tol_obj,
    tol_rel_obj = tol_rel_obj,
    tol_grad = tol_grad,
    tol_rel_grad = tol_rel_grad,
    tol_param = tol_param,
    history_size = history_size,
    num_psis_draws = num_psis_draws,
    num_paths = num_paths,
    save_single_paths = format_bool(save_single_paths),
    max_lbfgs_iters = max_lbfgs_iters,
    num_draws = num_draws,
    num_elbo_draws = num_elbo_draws
  )

  output <- list(
    file = inputs$output_filepath,
    diagnostic_file = NULL,
    refresh = refresh,
    sig_figs = sig_figs,
    profile_file = NULL
  )

  args <- build_stan_call(method = "pathfinder",
                          method_args = method_args,
                          data_file = inputs$data_filepath,
                          init = inputs$init_filepath,
                          seed = seed,
                          output_args = output)

  call_stan(args, ll_fun = inputs$ll_function, grad_fun = inputs$grad_function, quiet)

  parsed <- parse_csv(inputs$output_filepath)

  methods::new("StanPathfinder",
    metadata = parsed$metadata,
    timing = parsed$timing,
    draws = posterior::as_draws_df(setNames(data.frame(parsed$samples), parsed$header))
  )
}
