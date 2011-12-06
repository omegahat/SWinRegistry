\name{getRegistry}
\alias{getRegistry}
\title{Recursively retrieve registry keys and values}
\description{
 This recursively iterates over the specified
 key and its sub-keys and returns a list of lists
 that provide the key-value pairs and the same for
 the sub-keys.
}
\usage{
getRegistry(path = character(0), top = .BuiltinKeys[1])
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{path}{the identifier for a registry key.}
  \item{top}{the top-level key in which the path specification 
    is found.}
}
\details{

}
\value{
  A list of length 2
  \item{values}{a list giving the key-value pairs in this key}
  \item{folders}{a list with an element for each of the sub-keys
   in this key. Each element has the same structure as this return value,
   i.e. a list of length 2.}
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{getRegistrySubKeyNames}}
 \code{\link{getRegistryKeyValues}}
}
\examples{
 if(registryKeyExists(c("SOFTWARE", "R-core"), 4))
   getRegistry(c("SOFTWARE", "R-core"), top = 4)
}
\keyword{utilities}


