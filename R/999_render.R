render <- function() {
  qpdf::pdf_combine(
    input = c(
      "icon/Capa Renaest.pdf",
      "00-main.pdf", 
      "icon/Contra Capa Renaest.pdf"
    ),
    output = "rp01_analise_renaest.pdf"
  )
}

if (!interactive()) {
  render()
}
