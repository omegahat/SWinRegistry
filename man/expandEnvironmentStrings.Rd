\name{expandEnvironmentStrings}
\alias{expandEnvironmentStrings}
\title{Expand symbolic strings containing environment parameters}
\description{
 This is used to translate or expand the environment
 parameters in a string into their current values.
 Strings of this form are often stored in the 
 registry using the \code{REG_EXPAND_SZ} type. 

 This is an interface to the 
 Windows C-level API routine
 \code{ExpandEnvironmentStrings}.
}
\usage{
expandEnvironmentStrings(x)
}
\arguments{
  \item{x}{a character vector containing the strings to be expanded.}
}
\value{
 A character vector of the same length as the
 input argument (\code{x}) with the values 
 expanded.
}

\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{getRegistryKeyValues}}

 \code{\link{.resolveToplevelRegistryKey}}
}

\examples{
  els <- getRegistryKeyValues("Environment", "HKEY_CURRENT_USER")
  expandEnvironmentStrings(els)
}
\keyword{utilities}

