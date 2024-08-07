\newcommand{\CRANpkg}{\href{https://CRAN.R-project.org/package=#1}{\pkg{#1}}}
\name{lokerns}
\title{Kernel Regression Smoothing with Local Plug-in Bandwidth}
\alias{lokerns}
\alias{lokerns.default}
\alias{lokerns.formula}
\description{
  Nonparametric estimation of regression functions and their derivatives
  with kernel regression estimators and automatically adapted \bold{local}
  plug-in bandwidth function.
}
\usage{
lokerns(x, \dots)

\method{lokerns}{default}(x, y=NULL, deriv = 0, n.out=300, x.out=NULL, x.inOut = TRUE,
        korder = deriv + 2, hetero=FALSE, is.rand=TRUE,
        inputb = is.numeric(bandwidth) && all(bandwidth > 0),
        m1 = 400, xl=NULL, xu=NULL,
        s=NULL, sig=NULL, bandwidth=NULL, trace.lev = 0, \dots)

\method{lokerns}{formula}(formula, data, subset, na.action, \dots)
}
%% FIXME : The argument list of lokerns() and glkerns() are identical
%% -----   and the \arguments{..} description is 99% identical
%%				('local bandwith array' vs 'global bandwith')
%% ====> Really should  merge these help pages or make one of them very short!
\arguments{
  \item{x}{vector of design points, not necessarily ordered.}
  \item{y}{vector of observations of the same length as \code{x}.}
  \item{deriv}{order of derivative of the regression function to be
    estimated.  Only \code{deriv = 0,1,2} are allowed for automatic smoothing,
    whereas \code{deriv = 0,1,2,3,4}  is possible when smoothing with
    an input bandwidth array.  By default, \code{deriv=0}.}
  \item{n.out}{number of output design points where the function has to
    be estimated; default is \code{n.out=300}.}
  \item{x.out}{vector of output design points where the function has to
    be estimated.  The default is an equidistant grid of n.out points
    from min(x) to max(x).}
  \item{x.inOut}{logical or character string indicating if \code{x.out}
    should contain the input \code{x} values.
    Note that this argument did not exist, equivalently to being
    \code{FALSE}, up to \pkg{lokern} version \code{1.0-9}.

    In order for \code{\link{residuals}()} or \code{\link{fitted}()}
    methods to be applicable, it must be \code{TRUE} or a character
    string specifying one of the \code{methods}s of
    \code{\link[sfsmisc]{seqXtend}} (package \CRANpkg{sfsmisc}). The default,
    \code{TRUE} corresponds to method \code{"aim"}.
  }
  \item{korder}{
    nonnegative integer giving the kernel order \eqn{k}; it defaults to
    \code{korder = deriv+2} or \eqn{k = \nu + 2} where \eqn{k - \nu}
    must be even.  The maximal possible values are for automatic
    smoothing, \eqn{k \le 4}{k <= 4}, whereas for smoothing with input
    bandwidth array, \eqn{k \le 6}{k <= 6}.
  }
  \item{hetero}{
    logical: if TRUE, heteroscedastic error variables are assumed for
    variance estimation, if FALSE the variance estimation is optimized for
    homoscedasticity. Default value is hetero=FALSE.
  }
  \item{is.rand}{
    logical: if \code{TRUE} (default), random x are assumed and the
    s-array of the convolution estimator is computed as smoothed
    quantile estimators in order to adapt this variability.  If FALSE,
    the s-array is choosen as mid-point sequences as the classical
    Gasser-Mueller estimator, this will be better for equidistant and
    fixed design.
  }
  \item{inputb}{
    logical: if true, a local input bandwidth array is used; if
    \code{FALSE} (by default when \code{bandwidth} is not specified), a
    data-adaptive local plug-in bandwidths array is calculated and used.
  }
  \item{m1}{
    integer, the number of grid points for integral approximation when
    estimating the plug-in bandwidth. The default, 400, may be increased
    if a very large number of observations are available.
  }
  \item{xl, xu}{
    numeric (scalars), the lower and upper bounds for integral
    approximation and variance estimation when estimating the plug-in
    bandwidth. By default (when \code{xl} and \code{xu} are not specified),
    the 87\% middle part of \eqn{[xmin,xmax]} is used.
  }
  \item{s}{
    s-array of the convolution kernel estimator. If it is not given by input
    it is calculated as midpoint-sequence of the ordered design points for
    \code{is.rand=FALSE} or as quantiles estimators of the design density
    for \code{is.rand=TRUE}.
  }
  \item{sig}{variance of the error variables.  If it is not given by
    input or if \code{hetero=TRUE} it is calculated by a
    nonparametric variance estimator.}
  \item{bandwidth}{
    \emph{local} bandwidth array for kernel regression estimation.  If it is
    not given by input or if \code{inputb=FALSE} a data-adaptive local
    plug-in bandwidth array is used instead.}
  \item{trace.lev}{integer indicating how much the internal (Fortran
    level) computations should be \dQuote{traced}, i.e., be reported.
    The default, \code{0}, does not print anything.}

%%% formula method:
  \item{formula}{a \code{\link{formula}} of the form \code{y ~ pred},
    specifying the response variable \code{y} and predictor variable
    \code{pred} which must be in \code{data}.}
  \item{data}{an optional matrix or data frame (or similar: see
    \code{\link{model.frame}}) containing the variables in the
    formula \code{formula}.  By default the variables are taken from
    \code{environment(formula)}.}
  \item{subset}{an optional vector specifying a subset of observations
    to be used.}
  \item{na.action}{a function which indicates what should happen when
    the data contain \code{NA}s.  Defaults to
    \code{getOption("na.action")}.}
  \item{\dots}{for the \code{formula} method: Optional arguments all
    passed to \code{lokerns.default()}.}
}
\value{
  an object of class(es) \code{c("lokerns", "KernS")}, which is
  a list including used parameters and estimator, containing among others
  \item{x}{vector of ordered design points.}
  \item{y}{vector of observations ordered with respect to x.}
  \item{bandwidth}{local bandwidth array which was used for kernel
    regression estimation.}
  \item{x.out}{vector of ordered output design points.}
  \item{est}{vector of estimated regression function or its derivative
    (at \code{x.out}).}
  \item{sig}{variance estimation which was used for calculating the
    plug-in bandwidths if hetero=TRUE (default) and either inputb=FALSE
    (default) or is.rand=TRUE (default).}
  \item{deriv}{derivative of the regression function which was estimated.}
  \item{korder}{order of the kernel function which was used.}
  \item{xl}{lower bound for integral approximation and variance estimation.}
  \item{xu}{upper bound for integral approximation and variance estimation.}
  \item{s}{vector of midpoint values used for the convolution kernel
    regression estimator.}
}
\details{
  This function calls an efficient and fast algorithm for automatically
  adaptive nonparametric regression estimation with a kernel method.

  Roughly spoken, the method performs a local averaging of the
  observations when estimating the regression function. Analogously, one
  can estimate derivatives of small order of the regression function.
  Crucial for the kernel regression estimation used here is the choice
  the local bandwidth array. Too small bandwidths will lead to a wiggly
  curve, too large ones will smooth away important details.  The
  function lokerns calculates an estimator of the regression function or
  derivatives of the regression function with an automatically chosen
  local plugin bandwidth function. It is also possible to use a local
  bandwidth array which are specified by the user.

  Main ideas of the plugin method are to estimate the optimal bandwidths
  by estimating the asymptotically optimal mean squared error optimal
  bandwidths. Therefore, one has to estimate the variance for
  homoscedastic error variables and a functional of a smooth variance
  function for heteroscedastic error variables, respectively. Also, one
  has to estimate an integral functional of the squared \eqn{k}-th derivative
  of the regression function (\eqn{k=\code{korder}}) for the global
  bandwidth and the squared \eqn{k}-th derivative itself for the local
  bandwidths.

  Some more details are in \code{\link{glkerns}}.% e.g. *polynomial* kernels
}
\references{
  All the references in \code{\link{glkerns}}.
}
\seealso{\code{\link{glkerns}} for \bold{gl}obal bandwidth computation.
  \code{\link{plot.KernS}} documents all the methods for \code{"KernS"}
  classed objects.
}
\examples{
data(cars)
lofit <- lokerns(dist ~ speed, data=cars)
lofit # print() method
\dontshow{# equivalence of formula and (x,y) method:
lof1 <- lokerns(cars$ speed, cars$ dist)
ii <- names(lof1) != "call"
stopifnot(all.equal(lof1[ii], lofit[ii], tol = 1e-15))
}
if(require("sfsmisc")) {
  TA.plot(lofit)
} else { plot(residuals(lofit) ~ fitted(lofit)); abline(h = 0, lty=2) }
qqnorm(residuals(lofit), ylab = "residuals(lofit)")

## nice simple plot of data + smooth
plot(lofit)

(sb <- summary(lofit$bandwidth))
op <- par(fg = "gray90", tcl = -0.2, mgp = c(3,.5,0))
plot(lofit$band, ylim=c(0,3*sb["Max."]), type="h",#col="gray90",
     ann = FALSE, axes = FALSE)

boxplot(lofit$bandwidth, add = TRUE, at = 304, boxwex = 8,
        col = "gray90",border="gray", pars = list(axes = FALSE))
axis(4, at = c(0,pretty(sb)), col.axis = "gray")
par(op)
par(new=TRUE)
plot(dist ~ speed, data = cars,
     main = "Local Plug-In Bandwidth Vector")
lines(lofit, col=4, lwd=2)
mtext(paste("bandwidth in [",
            paste(format(sb[c(1,6)], dig = 3),collapse=","),
            "];  Median b.w.=",formatC(sb["Median"])))

## using user-specified bandwidth array
myBW <- round(2*lofit$bandwidth, 2)
(lofB <- lokerns(dist ~ speed, data=cars, bandwidth = myBW)) # failed (for a while)
## can use deriv=3 (and 4) here:
lofB3 <- lokerns(dist ~ speed, data=cars, bandwidth = myBW, deriv=3)
plot(lofB)
lines(lofB3, col=3)
stopifnot(inherits(lofB3, "KernS"), identical(lofB3$korder, 5L))
}
\keyword{smooth}
