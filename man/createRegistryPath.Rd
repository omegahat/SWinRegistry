\name{createRegistryPath}
\alias{createRegistryPath}
\title{Constructor for representation of a registry entry}
\description{
 This allows one to create an identifier  for an entry in
the Windows registry, identifying the entry as either a simple
value or a regular key which potentially has sub-keys.
}
\usage{
createRegistryPath(path, top, isValue)
}
\arguments{
  \item{path}{a character vector giving the path or sequence
   of entries identifying the hierarchical entry 
   in the Windows registry. This is resolved relative
   to the \code{top} element.
   }
  \item{top}{the top-level key of the root of the registry}
  \item{isValue}{a logical value indicating whether the path 
   identifies a key or a value}
}
\value{
 An object of class 
 \code{} or \code{} depending
 on the value of \code{isValue}.
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


%\seealso{}
\examples{
createRegistryPath("SOFTWARE", "HKEY_LOCAL_MACHINE", FALSE)
 # Partial matching for the top argument
createRegistryPath("SOFTWARE", "HKEY_LOC", FALSE)
 # Using integers based on the index in the .BuiltinKeys
createRegistryPath("SOFTWARE", 4, FALSE)


 # Nested path using a single string.
createRegistryPath("SOFTWARE\\\\R-core\\\\R", 4, FALSE)
 # Nested path and a Value reference.
createRegistryPath("SOFTWARE\\\\R-core\\\\R\\\\InstallPath", 4, TRUE)

 # Mixing the forms in which we specify the path, elements and 
 # a single string with \\
createRegistryPath(c("a", "b", "c", "x\\\\y\\\\z"), "HKEY_LOCAL_MACHINE", TRUE)
}
\keyword{interface}

