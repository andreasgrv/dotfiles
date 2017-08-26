$pdflatex = 'xelatex -interaction=nonstopmode -synctex=1 --shell-escape %O %S';
$pdf_previewer = 'start evince --unique';
# For nomenclature
add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
  system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg");
}
