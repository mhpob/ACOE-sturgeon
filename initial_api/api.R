#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(data.table)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#' @get /alert
#' @serializer cat
function(fish = 'unknown') {
  payload <- as.data.table(fish)
  payload[, detection_time := Sys.time()]

  fwrite(payload, 'result/detection_log.csv', append = TRUE)
  
  
  paste0('Detection of ', payload$fish, ' logged at ', payload$detection_time)
  
}


## @post /alertssss
function(req, fish = 'unknown') {
  payload <- req$argsBody
  
  if (length(payload) > 1) {
    stop("Too many parameters.")
  }
  
  if (!all(names(payload) == c("fish"))) {
    stop("Dont do this.")
  }

  payload <- as.data.table(payload)
  payload[, detection_time := Sys.time()]

  fwrite(payload, 'result/detection_log.csv', append = TRUE)
  
  list(
    msg = paste0('Detection of', payload$fish, 'logged at', as.POSIXct(payload$detection_time, format = '%Y%m%d%H%M%S'))
  )
}


#* @get /fls
function() {
  list(
    fls = list.files(),
    res = list.files("result")
  )
}

#* @get /log
#' @serializer print
function(){
  fread('result/detection_log.csv') 
}