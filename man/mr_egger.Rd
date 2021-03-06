% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/mr_egger-methods.R
\docType{methods}
\name{mr_egger}
\alias{mr_egger}
\alias{mr_egger,MRInput-method}
\title{MR-Egger method}
\usage{
mr_egger(object, robust = FALSE, penalized = FALSE, correl = FALSE,
  distribution = "normal", alpha = 0.05, ...)

\S4method{mr_egger}{MRInput}(object, robust = FALSE, penalized = FALSE,
  correl = FALSE, distribution = "normal", alpha = 0.05, ...)
}
\arguments{
\item{object}{An \code{MRInput} object.}

\item{robust}{Indicates whether robust regression using the \code{lmrob()} function from the package \code{robustbase} should be used in the method.}

\item{penalized}{Indicates whether a penalty should be applied to the weights to downweight the contribution of genetic variants with outlying ratio estimates to the analysis.}

\item{correl}{If the genetic variants are correlated, then this correlation can be accounted for. The matrix of correlations between must be provided: the elements of this matrix are the correlations between the individual variants (diagonal elements are 1). If a correlation is specified, then the values of \code{"robust"} and \code{"penalized"} are taken as \code{FALSE}.}

\item{distribution}{The type of distribution used to calculate the confidence intervals, can be \code{"normal"} (the default option) or \code{"t-dist"}. If the distribution is \code{"t-dist"}, then a t-distribution is used in case of over-dispersion. In case of under-dispersion, the confidence interval is the wider of that using the estimated residual standard error and a t-distribution, or that using a residual standard error of 1 and a normal distribution. This ensures that under-dispersion is not "doubly penalized" by setting the residual standard error to 1 and using a t-distribution, and also that the random-effects analysis is no more precise than a fixed-effect analysis would be.}

\item{alpha}{The significance level used to calculate the confidence interval. The default value is 0.05.}

\item{...}{Additional arguments to be passed to the regression method.}
}
\value{
The output of the function is an \code{Egger} object containing:

 \item{Model}{A character string giving the type of model used (\code{"random"}).}
 \item{Exposure}{A character string giving the name given to the exposure.}
 \item{Outcome}{A character string giving the name given to the outcome.}
 \item{Correlation}{The matrix of genetic correlations.}
 \item{Robust}{\code{TRUE} if robust estimate has been calculated, \code{FALSE} otherwise.}
 \item{Penalized}{\code{TRUE} if weights have been penalized, \code{FALSE} otherwise.}
 \item{Estimate}{The value of the causal estimate (slope coefficient).}
 \item{StdError.Est}{Standard error of the causal estimate.}
 \item{Pvalue.Est}{The p-value associated with the estimate (calculated as Estimate/StdError as per Wald test) using a normal or t-distribution (as specified in \code{distribution}).}
 \item{CILower.Est}{The lower bound of the causal estimate based on the estimated standard error and the significance level provided.}
 \item{CIUpper.Est}{The upper bound of the causal estimate based on the estimated standard error and the significance level provided.}
 \item{Intercept}{The value of the intercept estimate.}
 \item{StdError.Int}{Standard error of the intercept estimate.}
 \item{Pvalue.Int}{The p-value associated with the intercept.}
 \item{CILower.Int}{The lower bound of the intercept based on the estimated standard error and the significance level provided.}
 \item{CIUpper.Int}{The upper bound of the intercept based on the estimated standard error and the significance level provided.}
 \item{Alpha}{The significance level used when calculating the confidence intervals (same as \code{alpha} above).}
 \item{SNPs}{The number of genetic variants (SNPs) included in the analysis.}
 \item{Causal.pval}{The p-value for the MR-Egger causal estimate.}
 \item{Pleio.pval}{The p-value for the MR-Egger intercept test (a low p-value suggests either directional pleiotropy or failure of the InSIDE assumption, and indicates that the IVW estimate is biased).}
 \item{RSE}{The estimated residual standard error from the regression model.}
 \item{Heter.Stat}{Heterogeneity statistic (Cochran's Q statistic) and associated p-value: the null hypothesis is that the regression model (including an intercept) fits the regression model with no additional variability. Rejection of the null hypothesis is expected if genetic variants are pleiotropic, and doesn't mean that the MR-Egger analysis or the InSIDE assumption is invalid.}
\item{I.sq}{A measure of heterogeneity between the genetic associations with the exposure (see Bowden IJE 2016). Low values of \code{I.sq} relate both to large differences in precision between MR-Egger and IVW estimates, and to more weak instrument bias (in a two-sample setting, this is attenuation of MR-Egger estimate towards the null).}
}
\description{
The \code{mr_egger} function implements the MR-Egger method introduced by Bowden et al (2015).

This method provides: 1) a test of the for directional pleiotropy (the MR-Egger intercept test), 2) a test for a
causal effect, and 3) an estimate of the causal effect.
If the intercept term differs from zero, then the genetic variants are not all valid instrumental variables and
the standard (inverse-variance weighted) estimate is biased. If the InSIDE (Instrument Strength Independent of Direct Effect) assumption holds, then the MR-Egger slope parameter provides a test for a causal effect, and a consistent estimate of the causal effect even if the intercept differs from zero.
}
\details{
The causal estimate is obtained by regression of the associations with the outcome on the associations with the risk factor, with weights being the inverse-variances of the associations with the outcome. The intercept is estimated (in contrast with the inverse-variance weighted method, where the intercept is set to zero).

As part of the analysis, the genetic variants are orientated so that all of the associations with the risk factor are positive (and signs of associations with the outcome are changed to keep the orientation consistent if required). Re-orientation of the genetic variants is performed automatically as part of the function.

The MR-Egger model uses a random-effects model (\code{"random"}); a fixed-effect model does not make sense as pleiotropy leads to heterogeneity between the causal estimates targeted by the genetic variants. The (multiplicative) random-effects model allows over-dispersion in the regression model. Under-dispersion is not permitted (in case of under-dispersion, the residual standard error is set to 1).
}
\examples{
mr_egger(mr_input(bx = ldlc, bxse = ldlcse, by = chdlodds, byse = chdloddsse))
mr_egger(mr_input(bx = ldlc, bxse = ldlcse, by = chdlodds, byse = chdloddsse),
  robust = TRUE)
mr_egger(mr_input(bx = ldlc, bxse = ldlcse, by = chdlodds, byse = chdloddsse),
  penalized = TRUE)
mr_egger(mr_input(calcium, calciumse, fastgluc, fastglucse, corr=calc.rho))
  ## correlated variants

}
\references{
Jack Bowden, George Davey Smith, Stephen Burgess. Mendelian randomization with invalid instruments: effect estimation and bias detection through Egger regression. International Journal of Epidemiology 2015; 44:512--525. doi: 10.1093/ije/dyv080.

Confidence intervals, and robust and penalized weights: Stephen Burgess, Jack Bowden, Frank Dudbridge, Simon G Thompson. Robust instrumental variable methods using multiple candidate instruments with application to Mendelian randomization. arXiv 2016; 1606.03729.

I-squared statistic: Jack Bowden and others. Assessing the suitability of summary data for Mendelian randomization analyses using MR-Egger regression: The role of the I2 statistic. Int J Epidemiol 2016 (to appear).
}
