\name{getRegistryKeyValues-methods}
\docType{methods}
\alias{getRegistryKeyValues-methods}
\alias{getRegistryKeyValues,RegistryKeyPath,missing-method}
\alias{getRegistryKeyValues,character-method}
\alias{getRegistryValue-methods}
\alias{getRegistryValue,character-method}
\alias{getRegistryValue,RegistryKeyPath-method}
\title{Value of one or more keys in the Windows registry}
\description{
These methods provide different ways to specify the path
of interest to fetch the name-value pairs or
single value in the Windows registry.
}
\section{Methods}{
\describe{

\item{path = "RegistryKeyPath", top = "missing"}{ given a path }
\item{path = "character"}{ treat the character as a path }

% getRegistryValue
\item{path = "character"}{ treat the character vector as a path in the registry }
\item{path = "RegistryKeyPath"}{ an actual path object }
}}
\keyword{methods}
\keyword{utilities}

