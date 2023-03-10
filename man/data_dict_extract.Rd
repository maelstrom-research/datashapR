% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-dictionaries_functions.R
\name{data_dict_extract}
\alias{data_dict_extract}
\title{Create a data dictionary in the Maelstrom Research format from a dataset}
\usage{
data_dict_extract(data, as_mlstr_data_dict = TRUE)
}
\arguments{
\item{data}{A tibble identifying the input data observations which contains
meta data as attributes.}

\item{as_mlstr_data_dict}{Whether the output data dictionary has a simple
data dictionary structure or not (meaning has a Maelstrom data dictionary
structure, compatible with Maelstrom ecosystem such as Opal environment).
FALSE by default.}
}
\value{
A list of tibble(s) identifying a data dictionary.
}
\description{
Creates a data dictionary in the Maelstrom Research formats (with 'Variables'
and Categories' in separate tibbles and standard columns in each) from any
dataset in tibble format. If the input dataset has no associated metadata, a
data dictionary with a minimal of information is created from the column
(variable) names to create the data dictionary structure required for
madshapR (all columns except variable names will be blank).
}
\details{
A dataset must be a data frame or data frame extension (e.g. a tibble) and
can be associated to a data dictionary. If not, a minimum workable data
dictionary can always be generated, when any column will be reported, and
any factor column will be analysed as categorical variable (the column
'levels' will be created for that. In addition, the dataset may follow
Maelstrom research standards, and its content can be evaluated accordingly,
such as naming convention restriction, or id columns declaration (which
full completeness is mandatory.
}
\examples{
\dontrun{
# use case 1: create a data dictionary from any dataset
data_dict_extract(iris)
# use case 2: create a data dictionary with project and categorical variables
}

}
