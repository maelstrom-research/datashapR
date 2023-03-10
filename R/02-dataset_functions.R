#' @title
#' Create an empty dataset from a data dictionary
#'
#' @description
#' Creates an empty dataset using information contained in a data dictionary.
#' The columns name are the 'name' provided in the 'Variables' tibble of the
#' data dictionary. If a 'valueType' or alternatively 'typeof' column is
#' provided, the class of each column is set accordingly (default is text).
#'
#' @details
#' A data dictionary-like structure must be a list of at least one or two
#' data frame or data frame extension (e.g. a tibble) named 'Variables'
#' and 'Categories' (if any), representing meta data of an associated dataset.
#' The 'Variables' component must contain at least 'name' column and the
#' 'Categories' component must at least contain 'variable' and 'name'
#' columns to be usable in any function of the package.
#' To be considered as a minimum (workable) data dictionary, it must also
#' have unique and non-null entries in 'name' column and the combination
#' 'name'/'variable' must also be unique in 'Categories'.
#' In addition, the data dictionary may follow Maelstrom research standards,
#' and its content can be evaluated accordingly, such as naming convention
#' restriction, columns like 'valueType', 'missing' and 'label(:xx)',
#' and/or any taxonomy provided.
#'
#' @param data_dict A list of tibble(s) representing meta data of an
#' associated dataset (to be generated).
#' @param data_dict_apply whether to apply the data dictionary to its dataset.
#' The resulting tibble will have for each column its associated meta data as
#' attributes. The factors will be preserved. FALSE by default.
#'
#' @return
#' A tibble identifying the dataset created from the variable names list in
#' 'Variables' component of the data dictionary.
#'
#' @examples
#' \dontrun{
#' # Example 1: yyy yyy yyy.
#' }
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
data_extract <- function(data_dict, data_dict_apply = FALSE){

  # tests
  if(toString(attributes(data_dict)$`Mlstr::class`) == "Mlstr_data_dict"){
    data_dict <- as_mlstr_data_dict(data_dict, as_data_dict = TRUE)}else{
      data_dict <- as_data_dict(data_dict)}

  if(nrow(data_dict[['Variables']]) == 0){
    data <- tibble(.rows = 0)
    return(data)}

  if(!is.logical(data_dict_apply))
    stop(call. = FALSE,
'`data_dict_apply` must be TRUE of FALSE (FALSE by default)')


  # valueType/typeof() is needed to generate dataset, which will be all text if
  # not present
  vT_list <- madshapR::valueType_list

  data_dict_temp <- data_dict

  if(is.null(data_dict_temp[["Variables"]][['valueType']])){
    data_dict_temp[["Variables"]] <-
      data_dict_temp[["Variables"]] %>%
      left_join(
        vT_list %>%
          select(
            typeof = .data$`toTypeof`,
            valueType = .data$`toValueType`) %>%
          distinct, by = "typeof") %>%
      mutate(valueType = replace_na(.data$`valueType`, "character"))}

  data <-
    data_dict_temp[["Variables"]]  %>%
    select(.data$`name`) %>%
    pivot_wider(names_from = .data$`name`, values_from = .data$`name`) %>%
    slice(0)

  for(i in seq_len(ncol(data))){
    # stop()}
    data[i] <-
      as_valueType(data[i], data_dict_temp[["Variables"]]$`valueType`[i])
  }

  if(data_dict_apply == TRUE){
    data <- data_dict_apply(data, data_dict)
    return(data)
  }

  dataset <- as_dataset(data,attributes(data)$`Mlstr::col_id`)
  return(data)
}

#' @title
#' Remove value labels of a data frame, leaving its unlabelled columns
#'
#' @description
#' Removes any attributes attached to a tibble. Any value in columns will be
#' preserved. Any 'Date' (typeof) column will be recasted as character to
#' preserve information.
#'
#' @details
#' A dataset must be a data frame or data frame extension (e.g. a tibble) and
#' can be associated to a data dictionary. If not, a minimum workable data
#' dictionary can always be generated, when any column will be reported, and
#' any factor column will be analysed as categorical variable (the column
#' 'levels' will be created for that. In addition, the dataset may follow
#' Maelstrom research standards, and its content can be evaluated accordingly,
#' such as naming convention restriction, or id columns declaration (which
#' full completeness is mandatory.
#'
#' @seealso
#' [haven::zap_labels()].
#'
#' @param dataset A tibble identifying the input data observations associated to
#' its data dictionary.
#'
#' @return
#' A tibble identifying a dataset.
#'
#' @examples
#' \dontrun{
#' # Example 1: yyy yyy yyy.
#' }
#'
#' @import dplyr tidyr fabR
#' @importFrom rlang .data
#' @importFrom lubridate is.Date
#'
#' @export
dataset_zap_data_dict <- function(dataset){

  as_dataset(dataset %>% fabR::add_index(.force = TRUE))

  for(i in seq_len(length(dataset))){
  # stop()}
    if(is.Date(dataset[[i]])) dataset[[i]] <- as.character(dataset[[i]])
  }

  data <- dataset %>% lapply(as.vector) %>% as_tibble()

  return(data)
}

#' @title
#' Create a study as a list of datasets
#'
#' @description
#' Assembles a study from datasets. A study is a list containing at least one
#' dataset, that can be used directly in keys functions of the package.
#'
#' @details
#' A dataset must be a data frame or data frame extension (e.g. a tibble) and
#' can be associated to a data dictionary. If not, a minimum workable data
#' dictionary can always be generated, when any column will be reported, and
#' any factor column will be analysed as categorical variable (the column
#' 'levels' will be created for that. In addition, the dataset may follow
#' Maelstrom research standards, and its content can be evaluated accordingly,
#' such as naming convention restriction, or id columns declaration (which
#' full completeness is mandatory.
#'
#' @param dataset_list A list of tibble(s), identifying the input data
#' observations.
#' @param data_dict_apply whether to apply the data dictionary to its dataset.
#' The resulting tibble will have for each column its associated meta data as
#' attributes. The factors will be preserved. FALSE by default.
#'
#' @return
#' A list of tibble(s), each of them identifying datasets in a study.
#'
#' @examples
#' \dontrun{
#' # Example 1: yyy yyy yyy.
#' }
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
study_create <- function(dataset_list, data_dict_apply = FALSE){

  # tests input
  if(is.data.frame(dataset_list)) dataset_list <- list(dataset_list)
  if(!is.logical(data_dict_apply))
    stop(call. = FALSE,
         '`data_dict_apply` must be TRUE of FALSE (FALSE by default)')

  study <- dataset_list %>% lapply(FUN = function(x) {
    if(data_dict_apply == TRUE){
      x <- tibble(data_dict_apply(x)) ; return(x)}else{return(x)}
  })

  fargs <- as.list(match.call(expand.dots = TRUE))
  if(is.null(names(dataset_list))){
    names(study) <-
      fabR::make_name_list(as.character(fargs['dataset_list']), study)}

  study <- as_study(study)

  return(study)
}

#' @title
#' Validate and coerce any object as dataset
#'
#' @description
#' Confirms that the input object is a valid dataset, and return it as a dataset
#' with the appropriate mlstr_class attribute. This function mainly helps
#' validate input within other functions of the package but could be used to
#' check if a dataset is valid.
#'
#' @details
#' A dataset must be a data frame or data frame extension (e.g. a tibble) and
#' can be associated to a data dictionary. If not, a minimum workable data
#' dictionary can always be generated, when any column will be reported, and
#' any factor column will be analysed as categorical variable (the column
#' 'levels' will be created for that. In addition, the dataset may follow
#' Maelstrom research standards, and its content can be evaluated accordingly,
#' such as naming convention restriction, or id columns declaration (which
#' full completeness is mandatory.
#'
#' @param object A potential dataset to be coerced.
#' @param col_id A character string specifying the name(s) of the column(s)
#' which refer to key identifier of the dataset. The column(s) must be named
#' of indicated by position.
#'
#' @return
#' A tibble identifying a dataset.
#'
#' @examples
#' \dontrun{
#' # example
#'}
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
as_dataset <- function(object, col_id = NULL){

  # if only the tibble is given in parameter
  if(is.data.frame(object)) {

    # first column must be completly filled
    if(ncol(object) == 0){
      attributes(object)$`Mlstr::class` <- "dataset"
      attributes(object)$`Mlstr::col_id` <- NULL
      return(object)}

    # if(is.null(col_id)) col_id <- names(object)[[1]]
    # if !is.null(col_id) column must be present and completely filled
    if(length(intersect(names(object), col_id)) != length(unique(col_id)))
      stop(call. = FALSE,
           "All of your id column(s) must be present in your dataset.")

    if(sum(is.na(object[col_id])) > 0)
      stop(call. = FALSE,
           "Your id column(s) must not contain any NA values.")

    attributes(object)$`Mlstr::class` <- "dataset"
    attributes(object)$`Mlstr::col_id` <- col_id

    object <-
      object %>% select(all_of(col_id), everything())

    return(object)
  }

  # else
  stop(call. = FALSE,
"\n\n
This object is not a dataset as defined by Maelstrom standards which must be
a data frame. Please refer to documentation.")

}

#' @title
#' Validate and coerce any object as study
#'
#' @description
#' Confirms that the input object is a valid study, and return it as a study
#' with the appropriate mlstr_class attribute. This function mainly helps
#' validate input within other functions of the package but could be used to
#' check if a study is valid.
#'
#' @details
#' A study must be a named list containing at least one data frame or
#' data frame extension (e.g. a tibble), each of them being datasets.
#' The name of each tibble will be use as the reference name of the dataset.
#'
#' @seealso
#' For a better assessment, please use [madshapR::dataset_evaluate()].
#'
#' @param object A potential study to be coerced.
#'
#' @return
#' A list of tibble(s), each of them identifying datasets in a study.
#'
#' @examples
#' \dontrun{
#' # example
#'}
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
as_study <- function(object){

  # check if names in object exist
  name_objs <-
    vapply(X = as.list(names(object)),
           FUN = function(x) nchar(x),
           FUN.VALUE = integer(1))

  if(is.null(names(object)) | all(name_objs) == FALSE){
    stop(call. = FALSE,
"One or more datasets are not named. Please provide named list of datasets.")}

  # check if names in object are unique
  if(!setequal(length(names(object)),length(unique(names(object))))){
    stop(call. = FALSE,
"The name of your datasets are not unique. Please provide different names.")}

  # check if listed datasets
  tryCatch(
    object <- object %>% lapply(FUN = function(x) as_dataset(x)),
    error = function(x) stop(call. = FALSE,
      "\n\nThis object is not a study as defined by Maelstrom standards.
It must be exclusively a list of (at least one) dataset(s).
Please refer to documentation."))

  attributes(object)$`Mlstr::class` <- "study"
  return(object)

}

#' @title
#' Evaluate if any object is a dataset or not
#'
#' @description
#' Confirms whether the input object is a valid dataset.
#' This function mainly helps validate input within other functions of the
#' package but could be used to check if a dataset is valid.
#'
#' @details
#' A dataset must be a data frame or data frame extension (e.g. a tibble) and
#' can be associated to a data dictionary. If not, a minimum workable data
#' dictionary can always be generated, when any column will be reported, and
#' any factor column will be analysed as categorical variable (the column
#' 'levels' will be created for that. In addition, the dataset may follow
#' Maelstrom research standards, and its content can be evaluated accordingly,
#' such as naming convention restriction, or id columns declaration (which
#' full completeness is mandatory.
#'
#' @seealso
#' For a better assessment, please use [madshapR::dataset_evaluate()].
#'
#' @param object A potential dataset to be evaluated.
#'
#' @return
#' A logical.
#'
#' @examples
#' \dontrun{
#' # example
#'}
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
is_dataset <- function(object){

  object <- object
  # if only the tibble is given in parameter
  test <- fabR::silently_run(try(as_dataset(object),silent = TRUE))
  if(class(test)[1] == 'try-error')    return(FALSE)
  return(TRUE)

}

#' @title
#' Evaluate if any object is a study or not
#'
#' @description
#' Confirms whether the input object is a valid study.
#' This function mainly helps validate input within other functions of the
#' package but could be used to check if a study is valid.
#'
#' @details
#' A study must be a named list containing at least one data frame or
#' data frame extension (e.g. a tibble), each of them being datasets.
#' The name of each tibble will be use as the reference name of the dataset.
#'
#' @param object A potential study to be evaluated.
#'
#' @return
#' A logical.
#'
#' @examples
#' \dontrun{
#' # example
#'}
#'
#' @import dplyr tidyr
#' @importFrom rlang .data
#'
#' @export
is_study <- function(object){

  object <- object
  # if only the study is given in parameter
  test <- fabR::silently_run(try(as_study(object),silent = TRUE))
  if(class(test)[1] == 'try-error')    return(FALSE)
  return(TRUE)

}
