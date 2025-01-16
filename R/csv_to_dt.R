NULL
#'
#' It transform a csv-like response from GET or a csv-formatted character string into a data table
#'
#' @param string csv-formatted character string
#' @param header logical parameters
#' @param numeric logical argument 
#'
#' @importFrom stringr str_trim
#'
#' @return a \code{data.table} object
#' 
#' 
#' @importFrom data.table rbindlist
#' 
#' @export
#' 
#' @examples
#' string <- "code,name \n 1,John \n 2,Laura"
#' dt <- csv_to_dt(string)
#' 
#
csv_to_dt <- function(string,header=TRUE,numeric=TRUE) {
  string <- as.character(string)
  string <- unlist(strsplit(string,"\n"))
  out <- rbindlist(lapply(strsplit(string, ","), function(x) as.list(x)), fill = TRUE,use.names=FALSE)
  if (header) {
    nn <- as.character(out[1,])
    out <-out[-1,]
    names(out) <- nn
    
    
  }
  
  if (numeric) {
    cond_numeric <-list()
    outt33 <-out
    for (it in names(out)) {
      print(it)
      vc <- out[[it]] |> str_trim()
      vc <- vc[!is.na(vc)]
      vc <- vc[vc!=""]
      vn <- vc  |> as.numeric()
      
      
      cond_tempp <- !any(is.na(vn)) ###all(  vc==as.character(vn) 
      cond_numeric[[it]] <-(cond_tempp==TRUE) & !is.na(cond_tempp)
      
      if (cond_numeric[[it]]){
        
        out[[it]] <- out[[it]] |> str_trim() |> as.numeric()
        
      }
      
      
    }
    
  }
    
   

  
  
  return(out)
}
