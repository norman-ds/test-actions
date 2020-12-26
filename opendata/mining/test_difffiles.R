# test if files are equal
fun_all.equal <- function(f1) {
  purrr::map_dfr(myfiles, 
             ~ tibble::as_tibble_row(c(file1 = f1, file2 = .x,
               test = all.equal(readLines(f1, warn = F), readLines(.x, warn = F)))))
}

fun_fromjson <- function(f1) {
  purrr::map_dfr(myfiles, 
             ~ tibble::as_tibble_row(c(file1 = f1, file2 = .x,
               test = identical(jsonlite::fromJSON(f1), jsonlite::fromJSON(.x)))))
}


(myfiles <- list.files("data", pattern = 'datei33', full.names = T, recursive = T))

purrr::map(myfiles, fun_all.equal)
purrr::map(myfiles, fun_fromjson)

