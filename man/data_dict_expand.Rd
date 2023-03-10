% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-dictionaries_functions.R
\name{data_dict_expand}
\alias{data_dict_expand}
\title{Transform a columns in a data dictionary component to a new component}
\usage{
data_dict_expand(
  data_dict,
  from = "Variables",
  name_prefix = "Categories::",
  to = "Categories"
)
}
\arguments{
\item{data_dict}{A list of tibble(s) representing meta data to be
transformed. Automatically generated if not provided.}

\item{from}{Symbol identifying the name of the component (tibble) to take
column(s) from. Default is 'Variables'.}

\item{name_prefix}{Character string of the prefix of columns of interest.
This prefix will be used to select columns, and to rename them in the 'to'
component. Default is 'Categories::'.}

\item{to}{Symbol identifying the name of the component (tibble) to create
column(s) to. Default is 'Categories'.}
}
\value{
A list of tibble(s) identifying a data dictionary.
}
\description{
Transforms any columns in a data dictionary component to a new component.
If the component 'from' contains any column starting with 'prefix', (xx,yy),
these columns will be added as 'xx' and 'yy' in the component identified by
'to'. This tibble will be created if necessary, and columns will be added,
from left to right. (unique names will be generated if necessary).
Separator of each element is the following structure :
'name = xx1 ; name = xx2'.
This function is the reversed operation of \code{\link[=data_dict_flatten]{data_dict_flatten()}}
}
\details{
A data dictionary-like structure must be a list of at least one or two
data frame or data frame extension (e.g. a tibble) named 'Variables'
and 'Categories' (if any), representing meta data of an associated dataset.
The 'Variables' component must contain at least 'name' column and the
'Categories' component must at least contain 'variable' and 'name'
columns to be usable in any function of the package.
To be considered as a minimum (workable) data dictionary, it must also
have unique and non-null entries in 'name' column and the combination
'name'/'variable' must also be unique in 'Categories'.
In addition, the data dictionary may follow Maelstrom research standards,
and its content can be evaluated accordingly, such as naming convention
restriction, columns like 'valueType', 'missing' and 'label(:xx)',
and/or any taxonomy provided.
}
\examples{
\dontrun{
# Example 1: yyy yyy yyy.
}

}
\seealso{
\code{\link[=data_dict_flatten]{data_dict_flatten()}}
}
