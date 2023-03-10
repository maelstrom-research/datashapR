% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/09-opal_functions.R
\name{opal_files_pull}
\alias{opal_files_pull}
\title{Download files from an Opal environment}
\usage{
opal_files_pull(opal, from, to = paste0(getwd(), "/opal_files"))
}
\arguments{
\item{opal}{Opal login attributes.}

\item{from}{A character string of a path where the files will be taken from
in R.}

\item{to}{A character string of a path where the files will be placed to in
Opal.}
}
\value{
Folder(s) containing files coming from Opal in user R environment.
}
\description{
Downloads files from Opal environment to local. It is a wrapper of
\code{\link[opalr:opal.file_download]{opalr::opal.file_download()}}.
The user must be allowed to interact with their Opal. The errors
provided may be associated to the handler or the read/write
permissions to Opal. The user must have adequate credentials
to interact with their Opal environment.
}
\details{
The user must be allowed to interact with their Opal. The errors
provided may be associated to the handler or the read/write
permissions to Opal. The user must have adequate credentials
to interact with their Opal environment.
}
\examples{
\dontrun{
# use case 1: download all files from a project folder (""home/project/"")
# or a
# user's folder (""home/administrator/"").
opal_files_pull(
opal = o,
from = ""/home/administrator/DEMO/data_processing_elements"",
to = ""DEMO"")
# use case 2: download specific file from an Opal folder and rename it.
opal_files_pull(
opal = o,
}

}
\seealso{
Please see \href{https://opaldoc.obiba.org/en/dev/}{Opal documentation}for further
information.
}
