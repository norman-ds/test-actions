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

###################################################################
# test in detail with pretty json files

fun_diff <- function(f1,f2, fun) {
  prettyjson <- function(f1) {
    j1 <- jsonlite::fromJSON(f1)
    tmp1 <- tempfile()
    jsonlite::write_json(j1, tmp1, pretty=T)
    tmp1
  }
  
  tf1 <- prettyjson(f1)
  tf2 <- prettyjson(f2)
  res <- fun(tf1,tf2)
  unlink(c(tf1, tf2))
  res
}
fun_system <- function(f1, f2) {
  command <- paste("diff -w", f1, f2)
  try(system(command, intern = TRUE))
}
#fun_system(myfiles[6], myfiles[5])

fun_diff(myfiles[6], myfiles[5], fun_system)


