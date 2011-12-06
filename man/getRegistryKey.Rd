\name{getRegistryValue}
\alias{getRegistryValue}
\title{Value of a Key in the Windows registry}
\description{
 Get the value of a specific, individual key in the registry.
 This key is assumed to have a value rather than being 
 merely a container key for other sub-keys.
}
\usage{
getRegistryValue(path, key, isError = TRUE, top = .BuiltinKeys[1])
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{path}{the path to the specified node in which the
   actual key is located. 
   The path can be specfied in a variety of ways.
   It can be a single string with nodes in the path separated
   by the \\\\ character (e.g. \code{Control Panel\\\\Appearance\\\\Schemes}).
   Alternatively, it can be given as a character vector
   containing the elements of the path as individual
   elements of the character vector.
   This separates the elements of the path in the same way that
   the  \\\\ character does.
   In either cases,
   the top-level key can be specified within this path
   or alternatively can be given  by the \code{top} argument.
   Using the \code{top} argument makes it easier to use the
   built-in keys in the registry.
   And one can specify these by partial matching of the names
   or by numeric index into the \code{.BuiltinKeys} 
   vector.
 }
  \item{key}{the name of the key whose value is to be retrieved.
   If this is not specified, the key is taken to be the last element
   of path.}
  \item{isError}{ a logical value that indicates whether to throw an error
    if the key does not exist, or simply return a missing value.
    This allows the caller to avoid having to first check if the key exists
    or handle the error with a call to \code{try}.
   }
  \item{top}{the identifier of the top-level key in which to resolve 
    the \code{path} argument.
    This can be omitted if the top-level node is included in the \code{path}
    argument.
    This can be a name that partially matches those in the
    \code{.BuiltinKeys} vector or alternatively    
    the index of the entry in this vector.
    This is used as a convenience interface to
    minimize typing.
  }
}
\details{
 This calls the C-level API routine 
 \code{RegQueryValueEx}.
 The conversion from the registry value to an S object
 is done according to the following mapping of the types:

}
\value{
 The value from the key converted to an S object.
}

\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{getRegistryKeyValues}}
 \code{\link{getRegistrySubKeyNames}}

 \code{\link{.resolveToplevelRegistryKey}}
}

\examples{
 getRegistryValue("Control Panel\\\\Current", "Color Schemes", top = "HKEY_CURRENT_USER")

 setRegistryValue("HKEY_CURRENT_USER\\\\Volatile Environment\\\\duncan", value = "foobar")
 getRegistryValue("HKEY_CURRENT_USER\\\\Volatile Environment", "duncan")

\dontrun{
getRegistryValue("SNormal\\CLSID\\")
[1] "{C484D2F9-21F5-49AC-8C8D-2007E12245D3}"
getRegistryValue("SNormal\\CLSID", "")
[1] "{C484D2F9-21F5-49AC-8C8D-2007E12245D3}"
getRegistryValue(c("SNormal", "CLSID"), "")
[1] "{C484D2F9-21F5-49AC-8C8D-2007E12245D3}"
getRegistryValue(c("SNormal", "CLSID", ""))
[1] "{C484D2F9-21F5-49AC-8C8D-2007E12245D3}"
}
}
\keyword{utilities}

