\name{.resolveToplevelRegistryKey}
\alias{.resolveToplevelRegistryKey}
\title{Hierarchical Registry Path Specification}
\description{
 This function is used in all of the registry functions
 in this package to identify a key within the registry.
 The basic philosophy is to allow easy ways to specify
 a position in the registry for both interactive
 and programmatic use.
 There are 2 basic approaches which are then combined
 with two ways to specify the starting point.
 The two basic ways are to 
 a) specify the path via a single string whose
  path elements are separated by \\\\;
 or b) to specify the path elements as 
  separate elements of a character vector.

 One can specify the entire path in either of these ways,
 that is starting at the top-most node in the registry,
 e.g \code{HKEY_CURRENT_USER}, \code{HKEY_CLASSES_ROOT}, ...
 Alternatively, one can specify the top-most node of interest
 via the \code{top} argument and give the path from the node
 in either of these two ways.
}
\usage{
.resolveToplevelRegistryKey(top, path)
}

\arguments{
  \item{top}{the name of one of the top-level keys in the registry such as 
   \code{HKEY_CURRENT_USER}, \code{HKEY_CLASSES_ROOT}, etc.
   If one wants to specify this in the \code{path} argument,
  pass this as \code{NULL} or \code{""}}
  \item{path}{the path of keys  in the registry given as a 
  single string with elements separated by \code{\\\\} or 
  a character vector with an per key in the path}
}
\value{
 A list with the top-level key name
 and the sub-path from that given as a string with
 keys separated by \code{\\\\}.
 This is then used by the C code to identify the package.
}

\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
\code{\link{getRegistryValue}}
\code{\link{setRegistryValue}}

\code{\link{createRegistryKey}}
\code{\link{deleteRegistryKey}}
\code{\link{flushRegistryKey}}

\code{\link{getRegistryKeyValues}}
\code{\link{getRegistrySubKeyNames}}
}

\examples{
#  .resolveToplevelRegistryKey("", "HKEY_CURRENT_USER\\b\\c")
  .resolveToplevelRegistryKey("HKEY_CURRENT_USER", "a\\b\\c")
  .resolveToplevelRegistryKey("HKEY_CURRENT_USER", c("a","b", "c"))
}
\keyword{utilities}

