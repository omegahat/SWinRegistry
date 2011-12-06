\name{createRegistryKey}
\alias{createRegistryKey}
\alias{deleteRegistryKey}
\alias{flushRegistryKey}
\title{Manage Registry Keys}
\description{
 These functions allow one to manage the set of keys in a
 part of the registry.  One can create and delete a key.
 Also, \code{flushRegistryKey} can be used
 to force any changes to be immediately reflected
 in the registry.
}
\usage{
createRegistryKey(path, key = character(0), top = .BuiltinKeys[1], recursive = FALSE, check = TRUE)
deleteRegistryKey(path, key, top = .BuiltinKeys[1], asKey = FALSE, recursive = FALSE, resolve = TRUE)
flushRegistryKey(path, top = .BuiltinKeys[1])
}
\arguments{
  \item{path}{the hierarchical path in the registry that is combined with \code{top}
   to identify the folder containing the key of interest.}
  \item{key}{the name of a key within a folder within the registry.}
  \item{top}{if specified, the name of a top-level key in the registry
    which is combined with path to identify the folder in which the
    key of interest is to be found
  }
  \item{check}{a logical value indicating whether we should check whether the key exists
   or not before attempting to create it. If  \code{TRUE} and the key exists, we simply
   return the path.  If the key exists but is merely a value and not a regular
   key that can support sub-keys, we raise an error.}
  \item{asKey}{a logical value which, if \code{TRUE} removes the key
   and which if \code{FALSE} removes the value of the key.}
  \item{recursive}{a logical value which is currently ignored. 
    If this is activated, it would allow one to remove a folder that
    contains other keys.}
  \item{resolve}{a logical value indicating whether to check
   whether the key exists and whether it is a value or a key.}
}
\details{

}
\value{
\item{createRegistryKey}{
 A logical value indicating whether the key was created or not.
If the key already existed, this is \code{FALSE}. If
the key was created anew, this is \code{TRUE}.
}
\item{deleteRegistryKey}{
 A logical value which is \code{TRUE}
 or else an error is thrown.
}
\item{flushRegistryKey} {
 A logical value which is \code{TRUE}
 or else an error is thrown.
}
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{getRegistryValue}}
 \code{\link{setRegistryValue}}

 \code{\link{.resolveToplevelRegistryKey}}
 \code{regedit.exe}
}

\examples{
}
\keyword{utilities}

